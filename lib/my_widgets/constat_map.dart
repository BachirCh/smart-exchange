import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ConstatMap extends StatefulWidget {
  const ConstatMap({super.key});

  @override
  State<ConstatMap> createState() => _ConstatMapState();
}

class _ConstatMapState extends State<ConstatMap> {
  late GoogleMapController mapController;

  final LatLng _center = LatLng(33.589159, -7.673579);

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
         const Marker(
               markerId:  MarkerId("Casa"),
               position: LatLng(33.589159, -7.673579),
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
