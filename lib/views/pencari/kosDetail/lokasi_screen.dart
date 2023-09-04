import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LokasiScreen extends StatefulWidget {
  final String lokasi;

  const LokasiScreen({super.key, required this.lokasi});

  @override
  _LokasiScreenState createState() => _LokasiScreenState();
}

class _LokasiScreenState extends State<LokasiScreen> {
  late GoogleMapController _mapController;
  late LatLng _center;
  late BitmapDescriptor _markerIcon;

  @override
  void initState() {
    super.initState();
    var location = widget.lokasi.split(',');
    var latitude = double.parse(location[0].trim());
    var longitude = double.parse(location[1].trim());
    var geolocation = GeoPoint(latitude, longitude);

    _center = LatLng(double.parse(location[0]), double.parse(location[1]));

    // Inisialisasi ikon marker dari file PNG di assets
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(48, 48)),
            'assets/images/logo.png')
        .then((value) => setState(() {
              _markerIcon = value;
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lokasi Kos'),
      ),
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 15,
        ),
        markers: {
          Marker(
            markerId: const MarkerId('kos'),
            position: _center,
            icon: _markerIcon,
          ),
        },
      ),
    );
  }
}
