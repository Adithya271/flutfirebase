import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:infokos/provider/kos_provider.dart';
import 'package:provider/provider.dart';

class LokasiScreen extends StatefulWidget {
  const LokasiScreen({Key? key}) : super(key: key);

  @override
  State<LokasiScreen> createState() => LokasiScreenState();
}

class LokasiScreenState extends State<LokasiScreen> {
  LatLng? _selectedLocation;

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-6.4816949022314425, 106.54515793328058),
    zoom: 7, //zoom in dan zoom out
  );

  @override
  Widget build(BuildContext context) {
    final KosProvider kosProvider = Provider.of<KosProvider>(context);
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _selectedLocation ?? _kGooglePlex.target,
          zoom: 10,
        ),
        onTap: (LatLng location) {
          setState(() {
            _selectedLocation = location;
          });
        },
        markers: _selectedLocation == null
            ? {}
            : {
                Marker(
                  markerId: const MarkerId('m1'),
                  position: _selectedLocation!,
                ),
              },
      ),
      // Add a FloatingActionButton to save the selected location
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 730, right: 280),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FloatingActionButton(
              onPressed: () {
                if (_selectedLocation != null) {
                  double latitude =
                      _selectedLocation!.latitude.clamp(-90.0, 90.0);
                  double longitude =
                      _selectedLocation!.longitude.clamp(-180.0, 180.0);
                  kosProvider.getFormData(
                    lokasi: '$latitude, $longitude',
                    latitude: latitude,
                    longitude: longitude,
                  );
                  // Show SnackBar after saving the location
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Lokasi telah disimpan'),
                        backgroundColor: Color.fromARGB(255, 250, 171, 0)),
                  );
                }
                Navigator.pop(context);
              },
              child: const Icon(Icons.save),
            ),
          ],
        ),
      ),
    );
  }
}
