import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../services/api/search_service.dart';
import '../trip/trip_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

 final SearchService _searchService = SearchService(
  const String.fromEnvironment('GOOGLE_PLACES_API_KEY'),
);

  List<Map<String, dynamic>> _results = [];
  bool _isSearching = false;
  String? _error;

  Future<void> _search() async {
    final query = _searchController.text.trim();

    if (query.isEmpty) {
      return;
    }

    setState(() {
      _isSearching = true;
      _error = null;
      _results = [];
    });

    try {
      final results = await _searchService.searchPlaces(query);

      if (!mounted) return;

      setState(() {
        _results = results;
        _isSearching = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.toString();
        _isSearching = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Roadly'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _search(),
              decoration: InputDecoration(
                hintText: 'Search places...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: _search,
                ),
                border: const OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            if (_isSearching)
              const CircularProgressIndicator(),

            if (_error != null)
              Text(
                _error!,
                style: const TextStyle(color: Colors.red),
              ),

                        Expanded(
              child: ListView.builder(
                itemCount: _results.length,
                itemBuilder: (context, index) {
                  final place = _results[index];

                  final displayName =
                      place['displayName']?['text'] ?? 'Unknown place';

                  final address =
                      place['formattedAddress'] ?? '';

                  return ListTile(
                    leading: const Icon(Icons.location_on),
                    title: Text(displayName),
                    subtitle: Text(address),
                    onTap: () {
                      final location = place['location'];

                      if (location == null) {
                        return;
                      }

                      final latitude = location['latitude'];
                      final longitude = location['longitude'];

                      if (latitude == null || longitude == null) {
                        return;
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TripPage(
                            destination: LatLng(
                              latitude,
                              longitude,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TripPage(),
                  ),
                );
              },
              child: const Text('Start a Trip'),
            ),
          ],
        ),
      ),
    );
  }
}