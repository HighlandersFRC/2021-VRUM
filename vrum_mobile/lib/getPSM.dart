import 'dart:convert';
import 'dart:io';
import 'package:background_location/background_location.dart';
import 'package:http/http.dart' as http;
import 'package:maps_toolkit/maps_toolkit.dart';
import 'package:rxdart/rxdart.dart';
import 'package:vrum_mobile/models/personal_safety_message.dart';
import 'package:fluttertoast/fluttertoast.dart';

class getPSM {
  HttpClient client = new HttpClient();
  int prevTime = DateTime.now().millisecondsSinceEpoch;
  getPSM(BehaviorSubject<Location> LocationStream) {
    LocationStream.listen((location) {timePSM(location);});
  }

  timePSM(Location location, {int intervalSeconds = 1}) {
    int currTime = DateTime
        .now()
        .millisecondsSinceEpoch;
    if (currTime - prevTime >= intervalSeconds * 1000) {
      prevTime = currTime;
      readPSM(location.latitude, location.longitude, currTime);
    }
  }

  readPSM(double latitude, double longitude, int dateTime) async {
    var url = Uri.parse("https://vrum-rest-api.azurewebsites.net/psm/?latitude=$latitude&longitude=$longitude&datetime=$dateTime");
    var response = await http.get(url, headers : {"apikey":'9994912f-7d93-402a-9d55-77d7c748704c'});
    final body = response.body;
    final jsonBody = JsonDecoder().convert(body);
    print(jsonBody);
    for(final i in jsonBody['psms']) {
      final psmFromJSON = PersonalSafetyMessage.fromJson(i);
      final deltaDistance = SphericalUtil.computeDistanceBetween(LatLng(latitude, longitude), (LatLng(psmFromJSON.position.lat, psmFromJSON.position.lon)));
      if(deltaDistance < 50) {
        Fluttertoast.showToast(msg: "You are near a pedestrian", toastLength: Toast.LENGTH_SHORT);
        break;
      }
      print(psmFromJSON.toJson());
    }
  }
}