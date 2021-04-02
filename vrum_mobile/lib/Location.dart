import 'package:background_location/background_location.dart';
import 'package:rxdart/rxdart.dart';

class LocationProvider {
  final locationStream = BehaviorSubject<Location>();
  LocationProvider([int intervalSeconds = 10]) {
    BackgroundLocation.getPermissions(
      onGranted: () {
        BackgroundLocation.setAndroidNotification(
          title: "V.R.U.M.",
          message: "Recording Location",
          icon: "@mipmap/ic_launcher",
        );
        BackgroundLocation.startLocationService();
        BackgroundLocation.getLocationUpdates((location) {
          print(location);
          locationStream.add(location);
        });
      },
      onDenied: () {
      },
    );
  }
}