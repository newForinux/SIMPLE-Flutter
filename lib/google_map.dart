import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  int _markerIdCounter = 0;
  LatLng pos = LatLng(0, 0);

  Completer<GoogleMapController> _controller = Completer();


  @override
  Widget build(BuildContext context) {
    final Map args = ModalRoute.of(context)!.settings.arguments as Map;
      double _lat = args['lat'];
      double _lng = args['lng'];
      LatLng initLocation = LatLng(_lat, _lng);

      String _markerIdVal({bool increment = false}) {
        String val = 'marker_id_$_markerIdCounter';
        if (increment) _markerIdCounter++;
        return val;
    }


    void _onMapCreated(GoogleMapController controller) async {
      _controller.complete(controller);

      MarkerId markerId = MarkerId(_markerIdVal());
      LatLng position = initLocation;
      Marker marker = Marker(
        markerId: markerId,
        position: position,
        draggable: false,
      );
      setState(() {
        _markers[markerId] = marker;
      });

      Future.delayed(Duration(seconds: 1), () async {
        GoogleMapController controller = await _controller.future;
        controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: position,
              zoom: 18.0,
            ),
          ),
        );
      });

    }


    return Scaffold(
      appBar: AppBar(
        title: Text('나의 위치 찾기'),
      ),
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.75,
            child: GoogleMap(
              markers: Set<Marker>.of(_markers.values),
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: LatLng(_lat, _lng),
                zoom: 18.0,
              ),
              myLocationEnabled: true,
              onCameraMove: (CameraPosition position) {
                if(_markers.length > 0) {
                  MarkerId markerId = MarkerId(_markerIdVal());
                  Marker marker = _markers[markerId]!;
                  Marker updatedMarker = marker.copyWith(
                    positionParam: position.target,
                  );

                  setState(() {
                    _markers[markerId] = updatedMarker;
                    pos = position.target;
                  });
                }
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            width: MediaQuery.of(context).size.width,
            height: 80,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context, pos),
              child: Text(
                '이 위치로 할게요!',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xff3a9ad9)),
              ),
            ),
          )
        ],
      ),
    );
  }
}
