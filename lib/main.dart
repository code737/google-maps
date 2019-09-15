import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps Demo',
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();
  static const LatLng _center = const LatLng(21.484891, 39.197094);
  final Set<Marker> _markers = {};
  LatLng _lastMapPosition = _center;
  MapType _currentMapType = MapType.normal;

  static final CameraPosition _position1 = CameraPosition(
      bearing: 192.833,
      target: LatLng(21.484891, 39.197094),
      tilt: 59.440,
      zoom: 11.0);

  _onCamerMove(CameraPosition position) {
    setState(() {
      _lastMapPosition = position.target;
    });
  }

  _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  _onAddMarkerButtonPressed() {
    setState(() {
      _markers.add(Marker(
          markerId: MarkerId(_lastMapPosition.toString()),
          position: _lastMapPosition,
          infoWindow:
              InfoWindow(title: 'This is a Title', snippet: 'This is Snippest'),
          icon: BitmapDescriptor.defaultMarker));
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: _currentMapType,
            initialCameraPosition: CameraPosition(target: _center, zoom: 10.0),
            markers: _markers,
            onCameraMove: _onCamerMove,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          Align(
              alignment: Alignment.center, child: Text("${_lastMapPosition}")),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.center,
              child: Column(
                children: <Widget>[
                  button(_onMapTypeButtonPressed, Icons.map),
                  SizedBox(
                    height: 16.0,
                  ),
                  button(_onAddMarkerButtonPressed, Icons.add_location)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

Widget button(Function function, IconData icon) {
  return FloatingActionButton(
    onPressed: function,
    materialTapTargetSize: MaterialTapTargetSize.padded,
    backgroundColor: Colors.blue,
    child: Icon(
      icon,
      size: 36.0,
    ),
  );
}