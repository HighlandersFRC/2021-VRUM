import 'dart:convert';
import 'dart:io';

import 'package:background_location/background_location.dart';
import 'package:rxdart/rxdart.dart';
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
            /// ------------------------------- All of this should be moved to another file -------------------------------
            /// -------------------------------                                               -------------------------------
          }
);
      },
      onDenied: () {
      },
    );
  }
}