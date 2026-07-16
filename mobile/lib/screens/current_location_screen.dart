import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class CurrentLocationScreen extends StatefulWidget {
  final String currentLocation;

  const CurrentLocationScreen({
    super.key,
    required this.currentLocation,
  });

  @override
  State<CurrentLocationScreen> createState() =>
      _CurrentLocationScreenState();
}

class _CurrentLocationScreenState
    extends State<CurrentLocationScreen> {
  GoogleMapController? mapController;

  Marker? selectedMarker;

  String selectedPlace = "";
  String selectedAddress = "";

  final LatLng initialPosition = const LatLng(
    47.6062,
    -122.3321,
  );

  Future<void> onMapTap(LatLng position) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isEmpty) return;

      final place = placemarks.first;

      setState(() {
        selectedMarker = Marker(
          markerId: const MarkerId("selected"),
          position: position,
        );

        selectedPlace = place.name ?? "Unknown Place";

        selectedAddress =
            "${place.street}, ${place.locality}, ${place.administrativeArea}";
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Current Location"),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 350,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: initialPosition,
                zoom: 13,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: true,
              compassEnabled: true,
              mapToolbarEnabled: true,

              onTap: onMapTap,

              markers: {
                ?selectedMarker,
              },

              onMapCreated: (controller) {
                mapController = controller;
              },
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  const Text(
                    "Your Current Location",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.my_location),
                      title: const Text("Detected Location"),
                      subtitle: Text(widget.currentLocation),
                    ),
                  ),

                  if (selectedPlace.isNotEmpty)
                    Card(
                      margin: const EdgeInsets.all(20),
                      child: ListTile(
                        leading: const Icon(Icons.location_on),
                        title: Text(selectedPlace),
                        subtitle: Text(selectedAddress),
                      ),
                    ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Use Current Location",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}