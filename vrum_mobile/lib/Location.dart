import 'package:background_location/background_location.dart';
import 'package:rxdart/rxdart.dart';

class LocationProvider {
  final locationStream = BehaviorSubject<Location>();
  LocationProvider() {}

  startLocationUpdates() {
    BackgroundLocation.setAndroidNotification(
      title: "V.R.U.M.",
      message: "Recording Location",
      icon: "@mipmap/ic_launcher",
    );
    BackgroundLocation.startLocationService();

    BackgroundLocation.getLocationUpdates((location) {
      locationStream.add(location);
    });
  }

  Future<bool> requestLocationPermissions(
      {Function() onGrantedCallback, Function() onDeniedCallback}) async {
    bool granted = false;
    await BackgroundLocation.getPermissions(onGranted: () {
      onGrantedCallback;
      granted = true;
    }, onDenied: () {
      onDeniedCallback;
      granted = false;
    });
    return granted;
  }
}
