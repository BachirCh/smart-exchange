import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ConstatMap extends StatefulWidget {
  final double lat;
  final double long;
  const ConstatMap({super.key, required this.lat, required this.long});

  @override
  State<ConstatMap> createState() => _ConstatMapState();
}

class _ConstatMapState extends State<ConstatMap> {
  late GoogleMapController mapController;
   
  late LatLng _center = LatLng(widget.lat, widget.long);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: null,
        elevation: 2,
        surfaceTintColor: Colors.white,
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 14.0,
        ),
        markers: {
          Marker(
               markerId:  MarkerId("Casa"),
               position: _center,
               infoWindow: InfoWindow(
               title: "Constat",
               snippet: "Constat test",
            ),
            ), // Marker
      },
      ),
    );
  }
}
