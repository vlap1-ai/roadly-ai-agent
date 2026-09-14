import 'dart:convert';

import 'package:http/http.dart' as http;

class SearchService {
  final String apiKey;

  SearchService(this.apiKey);

  Future<List<Map<String, dynamic>>> searchPlaces(String query) async {
    if (query.trim().isEmpty) {
      return [];
    }

    final url = Uri.parse(
      'https://places.googleapis.com/v1/places:searchText',
    );

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'X-Goog-Api-Key': apiKey,
        'X-Goog-FieldMask':
            'places.id,'
            'places.displayName,'
            'places.formattedAddress,'
            'places.location,'
            'places.types',
      },
      body: jsonEncode({
        'textQuery': query.trim(),
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Place Search failed: ${response.statusCode} ${response.body}',
      );
    }

    final data = jsonDecode(response.body);

    return List<Map<String, dynamic>>.from(
      data['places'] ?? [],
    );
  }
}