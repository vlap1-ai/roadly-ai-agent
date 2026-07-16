import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'package:mobile/screens/current_location_screen.dart';
import 'package:mobile/screens/route_preview_screen.dart';
import 'package:mobile/services/search_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String currentLocation = "Getting location...";

  final TextEditingController destinationController =
      TextEditingController();

  List<String> predictions = [];

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  @override
  void dispose() {
    destinationController.dispose();
    super.dispose();
  }

  Future<void> getCurrentLocation() async {
    try {
      LocationPermission permission =
          await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() {
          currentLocation = "Location permission denied";
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition();

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      Placemark place = placemarks.first;

      setState(() {
        currentLocation =
            "${place.locality}, ${place.administrativeArea}";
      });
    } catch (e) {
      setState(() {
        currentLocation = "Unable to get location";
      });
    }
  }

  Future<void> searchPlaces(String value) async {
    print("Searching: $value");

    final results = await PlacesService.search(value);

    print(results);

    setState(() {
      predictions = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Roadly"),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),

              Image.asset(
                "assets/roadly_logo.png",
                height: 80,
                width: 80,
              ),

              const SizedBox(height: 20),

              const Text(
                "Welcome to Roadly",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Your smart driving companion",
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 30),

              Card(
                child: ListTile(
                  leading: const Icon(Icons.my_location),
                  title: const Text("Current Location"),
                  subtitle: Text(currentLocation),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CurrentLocationScreen(
                          currentLocation: currentLocation,
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: destinationController,
                onChanged: searchPlaces,
                decoration: const InputDecoration(
                  hintText: "Search destination",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
              ),

             if (predictions.isNotEmpty)
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 180,
                ),
                child: Card(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: predictions.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const Icon(Icons.location_on),
                        title: Text(predictions[index]),
                        onTap: () {
                          destinationController.text = predictions[index];

                          setState(() {
                            predictions = [];
                          });
                        },
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    final destination =
                        destinationController.text.trim();

                    if (destination.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Please enter a destination",
                          ),
                        ),
                      );
                      return;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RoutePreviewScreen(
                          currentLocation: currentLocation,
                          destination: destination,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    "Start Navigation",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  } 
}
