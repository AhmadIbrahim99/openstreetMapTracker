import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({Key? key}) : super(key: key);

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  bool isTrack = false; // we will cange the contronnel according to this
  //initMapWithUserPosition make it false
  MapController controller = MapController(
    initMapWithUserPosition: false,
    initPosition: GeoPoint(latitude: 31, longitude: 34),
    areaLimit: BoundingBox(
      east: 10.4922941,
      north: 47.8084648,
      south: 45.817995,
      west: 5.9559113,
    ),
  );

  //initMapWithUserPosition make it true
  MapController controller2 = MapController(
    initMapWithUserPosition: true,
    areaLimit: BoundingBox(
      east: 10.4922941,
      north: 47.8084648,
      south: 45.817995,
      west: 5.9559113,
    ),
  );
//enable track
  enableTrack() async {
    await controller.enableTracking();
    isTrack = true;
  }

//get the location
  getCurrentLocation() async {
    enableTrack();
    updateLocation();
  }

//update location
  updateLocation() async {
    await controller.currentLocation();
    await controller.setZoom(stepZoom: 8);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Driver"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: OSMFlutter(
          controller: (isTrack) ? controller2 : controller,
          trackMyPosition: isTrack,
          initZoom: 13,
          stepZoom: 1.0,
          onLocationChanged: (geoPoint) {
            setState(() async {
              await controller.goToLocation(geoPoint);
            });
          },
          userLocationMarker: UserLocationMaker(
            personMarker: const MarkerIcon(
              icon: Icon(
                Icons.location_history_rounded,
                color: Colors.red,
                size: 48,
              ),
            ),
            directionArrowMarker: const MarkerIcon(
              icon: Icon(
                Icons.double_arrow,
                size: 48,
              ),
            ),
          ),
          roadConfiguration: RoadConfiguration(
            startIcon: const MarkerIcon(
              icon: Icon(
                Icons.person,
                size: 64,
                color: Colors.brown,
              ),
            ),
            roadColor: Colors.yellowAccent,
          ),
          markerOption: MarkerOption(
              defaultMarker: const MarkerIcon(
            icon: Icon(
              Icons.person_pin_circle,
              color: Colors.blue,
              size: 56,
            ),
          )),
          // showDefaultInfoWindow: true, //You Can showDefaultInfoWindow But I dont Know How to handle it
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          onPressed: () {
            setState(() {
              getCurrentLocation();
            });
          },
          child: const Icon(Icons.location_searching),
        ),
      ),
    );
  }
}
