import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:background_location/background_location.dart';
import 'package:rxdart/rxdart.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';
import 'package:vrum_mobile/Models/personal_safety_message.dart';

class LocationProvider {
  final locationStream = BehaviorSubject<Location>();
  LocationProvider() {
    BackgroundLocation.getPermissions(
      onGranted: () {
        BackgroundLocation.setAndroidNotification(
          title: "V.R.U.M.",
          message: "Recording Location",
          icon: "@mipmap/ic_launcher",
        );
        BackgroundLocation.startLocationService();

        BackgroundLocation.getLocationUpdates((location) {
            locationStream.add(location);
          }
        );
      },
      onDenied: () {
      },
    );
  }

  static setAndroidNotification({String title, String message, String icon}) {
    BackgroundLocation.setAndroidNotification(
      title: title,
      message: message,
      icon: icon,
    );
  }

  /// Get the current location once.
  Future<Location> getCurrentLocation() async {
    Completer<Location> completer = Completer();

    Location _location = Location();
    await getLocationUpdates((location) {
      _location.latitude = location.latitude;
      _location.longitude = location.longitude;
      _location.accuracy = location.accuracy;
      _location.altitude = location.altitude;
      _location.bearing = location.bearing;
      _location.speed = location.speed;
      _location.time = location.time;
      completer.complete(_location);
    });

    return completer.future;
  }

  /// Ask the user for location permissions
  static getPermissions({Function onGranted, Function onDenied}) async {
    await Permission.locationWhenInUse.request();
    if (await Permission.locationWhenInUse.isGranted) {
      if (onGranted != null) {
        onGranted();
      }
    } else if (await Permission.locationWhenInUse.isDenied ||
        await Permission.locationWhenInUse.isPermanentlyDenied ||
        await Permission.locationWhenInUse.isRestricted ) {
      if (onDenied != null) {
        onDenied();
      }
    }
  }

  getLocationUpdates(Function(Location) func) {
    BackgroundLocation.getLocationUpdates((location) => func(location));
  }

  startLocationService() {
    BackgroundLocation.startLocationService();
  }

  stopLocationService() {
    BackgroundLocation.stopLocationService();
  }
}