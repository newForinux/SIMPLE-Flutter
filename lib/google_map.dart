import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Completer<GoogleMapController> _controller = Completer();

  static CameraPosition _kGooglePlex (double lat, double lng) => CameraPosition(
    target: LatLng(lat, lng),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    final Map args = ModalRoute.of(context)!.settings.arguments as Map;
    double _lat = args['lat'];
    double _lng = args['lng'];

    return Scaffold(
      appBar: AppBar(
        title: Text('dadfasd'),
      ),
      body: GoogleMap(
        myLocationButtonEnabled: true,
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex(_lat, _lng),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),

    );
  }
}
