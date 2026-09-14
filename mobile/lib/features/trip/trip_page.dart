import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TripPage extends StatefulWidget {
  final LatLng? destination;

  const TripPage({
    super.key,
    this.destination,
  });

  @override
  State<TripPage> createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  GoogleMapController? _mapController;

  LatLng? _currentLocation;

  bool _isLoadingLocation = true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled =
          await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        setState(() {
          _isLoadingLocation = false;
        });
        return;
      }

      LocationPermission permission =
          await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() {
          _isLoadingLocation = false;
        });
        return;
      }

      final Position position =
          await Geolocator.getCurrentPosition();

      final LatLng location = LatLng(
        position.latitude,
        position.longitude,
      );

      setState(() {
        _currentLocation = location;
        _isLoadingLocation = false;
      });

      _moveMapToDestination();
    } catch (e) {
      setState(() {
        _isLoadingLocation = false;
      });
    }
  }

  void _moveMapToDestination() {
    if (_mapController == null ||
        widget.destination == null) {
      return;
    }

    _mapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: widget.destination!,
          zoom: 16,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Set<Marker> markers = {};

    if (_currentLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: _currentLocation!,
          infoWindow: const InfoWindow(
            title: 'Your location',
          ),
        ),
      );
    }

    if (widget.destination != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('destination'),
          position: widget.destination!,
          infoWindow: const InfoWindow(
            title: 'Destination',
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Start a Trip'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: widget.destination ??
                  const LatLng(47.6062, -122.3321),
              zoom: 14,
            ),
            myLocationEnabled: _currentLocation != null,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
            markers: markers,
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;

              _moveMapToDestination();
            },
          ),

          if (_isLoadingLocation)
            const Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(),
                      ),
                      SizedBox(width: 12),
                      Text('Getting your location...'),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}