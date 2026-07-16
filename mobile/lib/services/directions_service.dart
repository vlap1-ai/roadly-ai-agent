import 'dart:convert';

import 'package:http/http.dart' as http;

class DirectionService {
  static const String apiKey = "AIzaSyDG3MYq60VCNVhSZhKc0QscmVVOp5sY190";

  static Future<Map<String, String>> getRoute({
    required String origin,
    required String destination,
  }) async {
    final url =
        "https://maps.googleapis.com/maps/api/directions/json"
        "?origin=${Uri.encodeComponent(origin)}"
        "&destination=${Uri.encodeComponent(destination)}"
        "&key=$apiKey";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception("Failed to load directions");
    }

    final json = jsonDecode(response.body);

    if (json["status"] != "OK") {
      throw Exception(json["status"]);
    }

    final leg = json["routes"][0]["legs"][0];

    return {
      "distance": leg["distance"]["text"],
      "duration": leg["duration"]["text"],
    };
  }
}