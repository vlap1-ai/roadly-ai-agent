import 'package:flutter/material.dart';
import 'package:mobile/screens/navigation_screen.dart';
import 'package:mobile/services/directions_service.dart';

class RoutePreviewScreen extends StatefulWidget {
  final String currentLocation;
  final String destination;

  const RoutePreviewScreen({
    super.key,
    required this.currentLocation,
    required this.destination,
  });

  @override
  State<RoutePreviewScreen> createState() =>
      _RoutePreviewScreenState();
}

class _RoutePreviewScreenState extends State<RoutePreviewScreen> {
  String distance = "Loading...";
  String duration = "Loading...";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadDirections();
  }

  Future<void> loadDirections() async {
    try {
      final result = await DirectionService.getRoute(
        origin: widget.currentLocation,
        destination: widget.destination,
      );

      setState(() {
        distance = result["distance"]!;
        duration = result["duration"]!;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        distance = "Unavailable";
        duration = "Unavailable";
        isLoading = false;
      });

      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Route Preview"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),

            const Icon(
              Icons.route,
              size: 90,
              color: Colors.blue,
            ),

            const SizedBox(height: 20),

            const Text(
              "Preview Your Route",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            Card(
              child: ListTile(
                leading: const Icon(Icons.my_location),
                title: const Text("From"),
                subtitle: Text(widget.currentLocation),
              ),
            ),

            const SizedBox(height: 15),

            Card(
              child: ListTile(
                leading: const Icon(Icons.location_on),
                title: const Text("To"),
                subtitle: Text(widget.destination),
              ),
            ),

            const SizedBox(height: 30),

            Card(
              child: ListTile(
                leading: const Icon(Icons.directions_car),
                title: const Text("Estimated Time"),
                subtitle: Text(duration),
              ),
            ),

            const SizedBox(height: 15),

            Card(
              child: ListTile(
                leading: const Icon(Icons.straighten),
                title: const Text("Distance"),
                subtitle: Text(distance),
              ),
            ),

            const Spacer(),

            SizedBox(
              height: 55,
              child: ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => NavigationScreen(
                              destination: widget.destination,
                            ),
                          ),
                        );
                      },
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        "Start Navigation",
                        style: TextStyle(fontSize: 18),
                      ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}