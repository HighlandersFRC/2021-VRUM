import 'dart:async';
import 'dart:io';

import 'package:background_location/background_location.dart';
import 'package:flutter/material.dart';
import 'package:vrum_mobile/Location.dart';

void main() {
  runApp(MaterialApp(
    title: 'Navigation Basics',
    home: FirstRoute(),
  ));
}

bool allowLocation = false;
final LocationProvider locationProvider = LocationProvider(10);
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
                onPressed: () {allowLocation = true;},
                child: Text("Get Location"),
              ),
              ElevatedButton(
                child: Text("Button to Post"),
                onPressed: () {
                  HttpClient client = new HttpClient();
                  client.postUrl(Uri.parse("https://vrum-rest-api.azurewebsites.net/user_location/?longitude=-104.8405004&latitude=41.1394557&user_id=555"))
                      .then((HttpClientRequest request) {
                    // Optionally set up headers...
                    request.headers.add("apikey",'9994912f-7d93-402a-9d55-77d7c748704c');
                    // Optionally write to the request object...
                    // Then call close.
                    return request.close();
                  })
                      .then((HttpClientResponse response) {
                    // Process the response.
                    print(response);
                  });
                  print("sent response");
                }
              )
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
                onPressed: () {allowLocation = true;},
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


