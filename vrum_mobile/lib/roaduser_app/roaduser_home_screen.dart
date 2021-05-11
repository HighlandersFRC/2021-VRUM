import 'dart:ui';

import 'package:background_location/background_location.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vrum_mobile/getPSM.dart';
import 'package:vrum_mobile/main.dart';
import 'package:vrum_mobile/pedestrian_app/pedestrian_app_theme.dart';

import 'roaduser_app_theme.dart';

class HotelHomeScreen extends StatefulWidget {
  @override
  _HotelHomeScreenState createState() => _HotelHomeScreenState();
}

BitmapDescriptor pedestrianIcon;
BitmapDescriptor vehicleIcon;
GoogleMapController _mapController;

void onMapCreated(controller) {
  _mapController = controller;
}

void setMapCameraLocation(Location location) => _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(location.latitude, location.longitude),
          zoom: 15,
          //bearing: location.bearing,
        ),
      ),
    );

class _HotelHomeScreenState extends State<HotelHomeScreen>
    with TickerProviderStateMixin {
  AnimationController animationController;
  GetPSM getPSM = new GetPSM();
  bool locationTurnedOn;

  final ScrollController _scrollController = ScrollController();

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 5));

  @override
  void initState() {
    locationTurnedOn = false;
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    super.initState();
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(), 'assets/pedestrian_app/Active_img_small.png')
        .then((value) => pedestrianIcon = value);

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(), 'assets/fitness_app/VehicleSmall.png')
        .then((value) => vehicleIcon = value);
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: HotelAppTheme.buildLightTheme(),
      child: Container(
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Column(
                  children: <Widget>[
                    getAppBarUI(),
                    Expanded(
                      child: Container(
                          child: Stack(
                        children: <Widget>[
                          StreamBuilder<Set<Marker>>(
                              stream: getPSM.vehicleMarkersStream,
                              builder: (context, snapshot) {
                                return GoogleMap(
                                  mapType: MapType.normal,
                                  initialCameraPosition: CameraPosition(
                                      bearing: 0,
                                      target: LatLng(40.060729, -105.209224),
                                      zoom: 15),
                                  markers: snapshot.data ?? Set<Marker>.of([]),
                                  onMapCreated: onMapCreated,
                                );
                              }),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: FloatingActionButton(
                              onPressed: () {
                                setState(() {
                                  locationTurnedOn = !locationTurnedOn;
                                });
                                if (locationTurnedOn) {
                                  Fluttertoast.showToast(
                                      msg: "Started Tracking Location",
                                      toastLength: Toast.LENGTH_SHORT);
                                  getPSM.startLocationUpdates(locationStream);
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Stopped Tracking Location",
                                      toastLength: Toast.LENGTH_SHORT);
                                  getPSM.stopLocationUpdates();
                                }
                              },
                              child: Icon(
                                locationTurnedOn
                                    ? Icons.stop
                                    : Icons.play_arrow,
                                color: FitnessAppTheme.white,
                                size: 40,
                              ),
                            ),
                          ),
                        ],
                      )),
                      // child: NestedScrollView(
                      //   controller: _scrollController,
                      //   headerSliverBuilder:
                      //       (BuildContext context, bool innerBoxIsScrolled) {
                      //     return <Widget>[
                      //       SliverList(
                      //         delegate: SliverChildBuilderDelegate(
                      //             (BuildContext context, int index) {
                      //           return Column(
                      //             children: <Widget>[
                      //               getSearchBarUI(),
                      //               getTimeDateUI(),
                      //             ],
                      //           );
                      //         }, childCount: 1),
                      //       ),
                      //       SliverPersistentHeader(
                      //         pinned: true,
                      //         floating: true,
                      //         delegate: ContestTabHeader(
                      //           getFilterBarUI(),
                      //         ),
                      //       ),
                      //     ];
                      //   },
                      //   body: Container(
                      //     color:
                      //         HotelAppTheme.buildLightTheme().backgroundColor,
                      //
                      //   ),
                    ),
                    // )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getListUI() {
    return Container(
      decoration: BoxDecoration(
        color: HotelAppTheme.buildLightTheme().backgroundColor,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              offset: const Offset(0, -2),
              blurRadius: 8.0),
        ],
      ),
      child: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height - 156 - 50,
            child: FutureBuilder<bool>(
              future: getData(),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox();
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Widget getTimeDateUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 18, bottom: 16),
    );
  }

  Widget getSearchBarUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: HotelAppTheme.buildLightTheme().backgroundColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(38.0),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        offset: const Offset(0, 2),
                        blurRadius: 8.0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getFilterBarUI() {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 24,
            decoration: BoxDecoration(
              color: HotelAppTheme.buildLightTheme().backgroundColor,
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    offset: const Offset(0, -2),
                    blurRadius: 8.0),
              ],
            ),
          ),
        ),
        Container(
          color: HotelAppTheme.buildLightTheme().backgroundColor,
          child: Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 4),
            child: Row(),
          ),
        ),
        const Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Divider(
            height: 1,
          ),
        )
      ],
    );
  }

  Widget getAppBarUI() {
    return Container(
      decoration: BoxDecoration(
        color: HotelAppTheme.buildLightTheme().backgroundColor,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              offset: const Offset(0, 2),
              blurRadius: 8.0),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top, left: 8, right: 8),
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(32.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.arrow_back),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'Road User',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ContestTabHeader extends SliverPersistentHeaderDelegate {
  ContestTabHeader(
    this.searchUI,
  );
  final Widget searchUI;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return searchUI;
  }

  @override
  double get maxExtent => 52.0;

  @override
  double get minExtent => 52.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
