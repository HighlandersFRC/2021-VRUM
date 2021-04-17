import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:background_location/background_location.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:maps_toolkit/maps_toolkit.dart' as mapsToolkit;
import 'package:rxdart/rxdart.dart';
import 'package:vrum_mobile/models/personal_safety_message.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GetPSM {
  FlutterTts flutterTts = FlutterTts();
  HttpClient client = new HttpClient();
  int prevTime = DateTime.now().millisecondsSinceEpoch;
  int prevNotiTime = DateTime.now().millisecondsSinceEpoch;
  BehaviorSubject<Set<Marker>> vehicleMarkersStream = BehaviorSubject<Set<Marker>>();
  StreamSubscription<Location> locationSub;

  GetPSM() {

  }

  startLocationUpdates(BehaviorSubject<Location> LocationStream) {
    locationSub = LocationStream.listen((location) {timePSM(location);});
  }

  stopLocationUpdates() {
    if (locationSub != null) {
      locationSub.cancel();
    }
  }

  timePSM(Location location, {int intervalSeconds = 1}) {
    int currTime = DateTime
        .now()
        .millisecondsSinceEpoch;
    if (currTime - prevTime >= intervalSeconds * 1000) {
      prevTime = currTime;
      readPSM(location, currTime);
    }
  }

  readPSM(Location location, int dateTime) async {
    final latitude = location.latitude;
    final longitude = location.longitude;
    final heading = location.bearing;
    final speed = location.speed;
    double timeToCollision = 10;
    final minDistanceToCollision = 20.0;
    final maxAngle = 30.0;
    var url = Uri.parse("https://vrum-rest-api.azurewebsites.net/psm/?latitude=$latitude&longitude=$longitude&datetime=$dateTime");
    var response = await http.get(url, headers : {"apikey":'9994912f-7d93-402a-9d55-77d7c748704c'});
    final body = response.body;
    final jsonBody = JsonDecoder().convert(body);
    print(jsonBody);
    final markers = Set<Marker>.of([]);
    final ids = [];
    final rng = new Random();
    for (final psm in jsonBody['psms']) {
      final psmFromJSON = PersonalSafetyMessage.fromJson(psm);
      if (ids.contains(psmFromJSON.id)) {
        continue;
      }
      else {
        ids.add(psmFromJSON.id);
      }
      Marker marker = Marker(
        markerId: MarkerId(psmFromJSON.id),
        position: LatLng(
          psmFromJSON.position.lat,
          psmFromJSON.position.lon,
        ),
      );
      markers.add(marker);
    }
    vehicleMarkersStream.add(markers);

    for(final i in jsonBody['psms']) {
      final psmFromJSON = PersonalSafetyMessage.fromJson(i);
      final deltaDistance = mapsToolkit.SphericalUtil.computeDistanceBetween(mapsToolkit.LatLng(latitude, longitude), (mapsToolkit.LatLng(psmFromJSON.position.lat, psmFromJSON.position.lon)));
      final bearing = mapsToolkit.SphericalUtil.computeAngleBetween(mapsToolkit.LatLng(latitude, longitude),(mapsToolkit.LatLng(psmFromJSON.position.lat, psmFromJSON.position.lon)));
      if(deltaDistance < minDistanceToCollision || ((bearing - heading).abs() < maxAngle && (deltaDistance/speed) < timeToCollision)) {
        sendNotification();
        break;
      }
      print(psmFromJSON.toJson());
    }
  }

  sendNotification() {
    int currNotiTime = DateTime.now().millisecondsSinceEpoch;
    if(currNotiTime - prevNotiTime >= 5 * 1000) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(msg: "You are near a pedestrian", toastLength: Toast.LENGTH_SHORT);
      flutterTts.speak("You are near a pedestrian!");
    }
  }
}