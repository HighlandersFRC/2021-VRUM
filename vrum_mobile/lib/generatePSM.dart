import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:background_location/background_location.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

import 'main.dart' as main;
import 'models/personal_safety_message.dart';

class GeneratePSM {
  int prevTime = DateTime.now().millisecondsSinceEpoch;
  final psmStream = BehaviorSubject<PersonalSafetyMessage>();
  HttpClient client = new HttpClient();
  Uuid uuid = Uuid();
  List<PathHistoryPoint> pathHistory;
  StreamSubscription<Location> locationSub;
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
    PersonalSafetyMessage psm = PersonalSafetyMessage(id: uuid.v4(), basicType: pedestrianType, secMark: 0, timestamp: currTime, msgCnt: 1, deviceId: main.deviceId, position: position, accuracy: location.accuracy, speed: location.speed, heading: location.bearing, pathHistory: pathHistory);

//     client.postUrl(Uri.parse("https://vrum-rest-api.azurewebsites.net/psm/"))
//         .then((HttpClientRequest request) {
// // Optionally set up headers...
//       request.headers.add("apikey",'9994912f-7d93-402a-9d55-77d7c748704c');
//       final msg = JsonEncoder().convert(psm.toJson()); //.withIndent("    ")
//       print(msg);
//       request.write(msg);
// // Optionally write to the request object...
// // Then call close.
//       return request.close();
//     })
//         .then((HttpClientResponse response) {
// // Process the response.
//       print(response.statusCode);
//       print(response.reasonPhrase);
//     });

    psmStream.add(psm);

    var client = http.Client();
    try {
      var url = Uri.parse("https://vrum-rest-api.azurewebsites.net/vru/");
      var response = await http.post(url, headers : {"apikey":'9994912f-7d93-402a-9d55-77d7c748704c'}, body: JsonEncoder().convert(psm.toJson()));
      print(response.statusCode);
    } finally {
      client.close();
    }

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
      pathHistory.add(pathPoint);
    }
  }



}
