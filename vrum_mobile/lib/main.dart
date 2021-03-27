import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(MaterialApp(
    title: 'Navigation Basics',
    home: FirstRoute(),
  ));
}

Position _currentPosition;

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pedestrian"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Back'),
        ),
      ),
    );
  }
}

class CarRoute extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Vehicle"),
      ),
      body: Column(
      children: <Widget>[
        Text(
        "LAT: ${_currentPosition.latitude}, LNG: ${_currentPosition.longitude}"
        ),
        ElevatedButton(
          child: Text("Get location"),
          onPressed: () {
            _getCurrentLocation();
          },
        ),
        Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Back'),
          ),
        ),
      ],
    ),
    );

  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}

  _getCurrentLocation() async {
    try {
      var currentLocation = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      _currentPosition = null;
    }
    return _currentPosition;
  }

