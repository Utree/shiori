import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:shiori_client/ui/screen/Booklet.dart';

class BookletMap extends StatefulWidget {
  final CameraPosition posi;
  final Completer<GoogleMapController> controller;
  final List<TravelSpot> travelSpot;

  const BookletMap({
    Key key,
    @required this.posi,
    @required this.controller,
    @required this.travelSpot,
  });

  @override
  _BookletMap createState() => _BookletMap();
}


class _BookletMap extends State<BookletMap> {
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  void _add(String markerName, LatLng place) {
    /**
     * ピンを追加
     */
    final MarkerId markerId = MarkerId(markerName);

    final Marker marker = Marker(
      markerId: markerId,
      position: place,
      infoWindow: InfoWindow(title: markerName),
    );

    setState(() {
      markers[markerId] = marker;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        markers: Set<Marker>.of(markers.values),
        mapType: MapType.normal,
        initialCameraPosition: widget.posi,
        onMapCreated: (GoogleMapController controller) {
          // マーカーを追加
          setState(() {
            for(TravelSpot travelSpot in widget.travelSpot) {
              _add(travelSpot.name, LatLng(travelSpot.lat, travelSpot.lng));
            }
          });
          widget.controller.complete(controller);
        },
        zoomControlsEnabled: false,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
