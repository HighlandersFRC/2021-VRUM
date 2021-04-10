import 'dart:convert';
import 'dart:io';

import 'package:background_location/background_location.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';
import 'package:vrum_mobile/Models/personal_safety_message.dart';

class LocationProvider {
  final locationStream = BehaviorSubject<Location>();
  final psmStream = BehaviorSubject<PersonalSafetyMessage>();
  HttpClient client = new HttpClient();
  Uuid uuid = Uuid();
  LocationProvider([int intervalSeconds = 10]) {
    BackgroundLocation.getPermissions(
      onGranted: () {
        BackgroundLocation.setAndroidNotification(
          title: "V.R.U.M.",
          message: "Recording Location",
          icon: "@mipmap/ic_launcher",
        );
        BackgroundLocation.startLocationService();

        int prevTime = DateTime.now().millisecondsSinceEpoch;
        BackgroundLocation.getLocationUpdates((location) {
          int currTime = DateTime.now().millisecondsSinceEpoch;
          if (currTime - prevTime >= intervalSeconds*1000) {
            prevTime = currTime;
            print(location);

            locationStream.add(location);

            /// ------------------------------- All of this should be moved to another file -------------------------------

            Position position = Position(
              lat: location.latitude,
              lon: location.longitude,
              elevation: location.altitude,
            );
            PersonalSafetyMessage psm = PersonalSafetyMessage(basicType: 'aPEDESTRIAN', secMark: 0, timestamp: currTime, msgCnt: 1, id: uuid.v4(), position: position, accuracy: location.accuracy, speed: location.speed, heading: location.bearing);


            client.postUrl(Uri.parse("https://vrum-rest-api.azurewebsites.net/psm/"))
                .then((HttpClientRequest request) {
              // Optionally set up headers...
              request.headers.add("apikey",'9994912f-7d93-402a-9d55-77d7c748704c');
              final msg = JsonEncoder().convert(psm.toJson()); //.withIndent("    ")
              print(msg);
              request.write(msg);
              // Optionally write to the request object...
              // Then call close.
              return request.close();
            })
                .then((HttpClientResponse response) {
              // Process the response.
              print(response.statusCode);
              print(response.reasonPhrase);
            });

            psmStream.add(psm);
            /// -------------------------------                                               -------------------------------
          }
        });
      },
      onDenied: () {
      },
    );
  }
}