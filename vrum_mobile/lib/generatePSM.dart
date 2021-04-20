import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:background_location/background_location.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';
import 'package:vrum_mobile/apiController.dart';

import 'main.dart' as main;
import 'models/personal_safety_message.dart';

class GeneratePSM {
  int prevTime = DateTime.now().millisecondsSinceEpoch;
  final psmStream = BehaviorSubject<PersonalSafetyMessage>();
  HttpClient client = new HttpClient();
  Uuid uuid = Uuid();
  List<PathHistoryPoint> pathHistory = [];
  StreamSubscription<Location> locationSub;
  ApiController apiController = ApiController();
  GeneratePSM() {

  }

  startLocationUpdates(BehaviorSubject<Location> LocationStream, String pedestrianType) {
    locationSub = LocationStream.listen((location) {filterPSM(location, pedestrianType);});
  }

  stopLocationUpdates() {
    if (locationSub != null) {
      locationSub.cancel();
    }
  }
  // when postPSM is called, it will generate a PSM
  postPSM(Location location, int currTime, String pedestrianType)  async {
    Position position = Position(
      lat: location.latitude,
      lon: location.longitude,
      elevation: location.altitude,
    );
    PersonalSafetyMessage psm = PersonalSafetyMessage(id: uuid.v4(), basicType: pedestrianType, timestamp: currTime, msgCnt: 1, deviceId: main.deviceId, position: position, accuracy: location.accuracy, speed: location.speed, heading: location.bearing, pathHistory: pathHistory);

    psmStream.add(psm);

    apiController.postApiRequest("https://vrum-rest-api.azurewebsites.net/secure/psm/", JsonEncoder().convert(psm.toJson()));
  }
  // when filterPSM is called, it will check whether there is a new location and whether enough time has passed in between PSMs
  filterPSM(Location location, pedestrianType, {int intervalSeconds = 1}) {
    int currTime = DateTime
        .now()
        .millisecondsSinceEpoch;
    if (currTime - prevTime >= intervalSeconds * 1000) {
      prevTime = currTime;
      postPSM(location, currTime, pedestrianType);
      Position position = Position(
        lat: location.latitude,
        lon: location.longitude,
        elevation: location.altitude,
      );
      var pathPoint = PathHistoryPoint(position: position, timestamp: currTime, speed: location.speed, heading: location.bearing);
      if(pathHistory.length >= 10) {
        pathHistory.removeAt(0);
      }
      pathHistory.add(pathPoint);
    }
  }



}
