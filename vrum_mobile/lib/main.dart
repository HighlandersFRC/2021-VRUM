import 'dart:async';
import 'dart:io';

import 'package:background_location/background_location.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:vrum_mobile/Location.dart';
import 'package:vrum_mobile/generatePSM.dart';
import 'package:vrum_mobile/getPSM.dart';

void main() {
  runApp(MaterialApp(
    title: 'Navigation Basics',
    // home: MapSample(),
    home: FirstRoute(),
  ));
}

bool allowLocation = false;
final LocationProvider locationProvider = LocationProvider();
final locationStream = locationProvider.locationStream;
final getPsm = GetPSM();
Uuid uuid = Uuid();
String deviceId;

class FirstRoute extends StatefulWidget {

  Future<void> getPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    deviceId = prefs.getString('device_id');
    if (deviceId == null) {
      deviceId = uuid.v4();
      prefs.setString('device_id', deviceId);
    }
  }

  @override
  _FirstRouteState createState() {
    getPrefs();
    return _FirstRouteState();
  }
}

class _FirstRouteState extends State<FirstRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            ElevatedButton(
              child: Text('Pedestrian'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PedestrianRoute()),
                );
              },
            ),
            ElevatedButton(
              child: Text('Vehicle'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CarRoute()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('To the lake!'),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}

class PedestrianRoute extends StatelessWidget {
  void sendPSM() async {
    print('Sent PSM');
  }

  // void main() {
  //   const time = const Duration(seconds: 30);
  //   Timer.periodic(time, (Timer timer) {
  //     sendPSM();
  //   });
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pedestrian"),
      ),
      body: Column(
        children: <Widget>[
          Center(
              child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Back'),
              ),
              // var time = const Duration(//milliseconds: // // seconds: // // minutes: // ...);
              //   Timer.periodic(time, (timer) => {sentPSM()}
              // ),
              StreamBuilder<Location>(
                  stream: locationStream,
                  builder: (context, snapshot) {
                    if (allowLocation) {
                      return Text(
                        "Latitude: ${snapshot.data?.latitude}, Latitude: ${snapshot.data?.longitude}",
                      );
                    } else {
                      return Text(
                        "Latitude: null, Longitude: null",
                      );
                    }
                  }),
              ElevatedButton(
                onPressed: () {
                  allowLocation = true;
                  generatePSM(locationStream);
                },
                child: Text("Get Location"),
              ),
            ],
          )),
        ],
      ),
    );
  }
}

class CarRoute extends StatelessWidget {
  // UpdateTextState createState() => UpdateTextState();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Vehicle"),
      ),
      body: Column(
        children: <Widget>[
          Center(
              child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Back'),
              ),
              StreamBuilder<Location>(
                  stream: locationStream,
                  builder: (context, snapshot) {
                    if (allowLocation) {
                      return Text(
                        "Latitude: ${snapshot.data?.latitude}, Latitude: ${snapshot.data?.longitude}",
                      );
                    } else {
                      return Text(
                        "Latitude: null, Longitude: null",
                      );
                    }
                  }),
              ElevatedButton(
                onPressed: () {
                  getPsm.startLocationUpdates(locationStream);
                  allowLocation = true;
                },
                child: Text("Get Location"),
              ),
              Container(
                height: 400,
                child: StreamBuilder<Set<Marker>>(
                  stream: getPsm.vehicleMarkersStream,
                  builder: (context, snapshot) {
                    return GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(
                          bearing: 0,
                          target: LatLng(40.060729, -105.209224),
                          zoom: 15
                      ),
                      markers: snapshot.data ?? Set<Marker>.of([]),
                    );
                  }
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }

  // @override
  // State<StatefulWidget> createState() {
  //   // TODO: implement createState
  //   throw UnimplementedError();
  // }
}
