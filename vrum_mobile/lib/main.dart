import 'dart:async';
import 'dart:io';

import 'package:background_location/background_location.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_tts/flutter_tts.dart';
import 'package:vrum_mobile/Location.dart';
import 'package:vrum_mobile/generatePSM.dart';
import 'package:vrum_mobile/getPSM.dart';

void main() {
  runApp(MaterialApp(
    title: 'Navigation Basics',
    home: FirstRoute(),
  ));
}

bool allowLocation = false;
final LocationProvider locationProvider = LocationProvider();
final locationStream = locationProvider.locationStream;
class FirstRoute extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Column (
        children: <Widget> [
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
          child: Column (
            children: [ElevatedButton(
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
                    if(allowLocation) {
                      return Text(
                        "Latitude: ${snapshot.data?.latitude}, Latitude: ${snapshot.data?.longitude}",
                      );
                    }
                    else {
                      return Text(
                        "Latitude: null, Longitude: null",
                      );
                    }
                  }
              ),
              ElevatedButton(
                onPressed: () {
                  allowLocation = true;
                  generatePSM(locationStream);
                },
                child: Text("Get Location"),
              ),
            ],
          )
      ),
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
          child: Column (
            children: [ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Back'),
            ),
              StreamBuilder<Location>(
                  stream: locationStream,
                  builder: (context, snapshot) {
                    if(allowLocation) {
                      return Text(
                        "Latitude: ${snapshot.data?.latitude}, Latitude: ${snapshot.data?.longitude}",
                      );
                    }
                    else {
                      return Text(
                          "Latitude: null, Longitude: null",
                      );
                    }
                  }
              ),
              ElevatedButton(
                onPressed: () {
                  getPSM(locationStream);
                  allowLocation = true;},
                child: Text("Get Location"),
              ),
            ],
          )
        ),
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


