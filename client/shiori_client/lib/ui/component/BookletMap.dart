import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class BookletMap extends StatelessWidget {
  const BookletMap({
    Key key,
    @required this.posi,
    @required Completer<GoogleMapController> controller,
  }) : _controller = controller, super(key: key);

  final CameraPosition posi;
  final Completer<GoogleMapController> _controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: posi,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        zoomControlsEnabled: false,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
