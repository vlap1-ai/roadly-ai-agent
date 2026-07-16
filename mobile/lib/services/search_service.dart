import 'dart:convert';

import 'package:http/http.dart' as http;

class PlacesService {
  static const String apiKey = "AIzaSyDG3MYq60VCNVhSZhKc0QscmVVOp5sY190";

  static Future<List<String>> search(String input) async {
    if (input.isEmpty) return [];

    final url = Uri.parse(
      "https://maps.googleapis.com/maps/api/place/autocomplete/json"
      "?input=$input"
      "&key=$apiKey",
    );

    final response = await http.get(url);

      print("Status Code: ${response.statusCode}");
      print(response.body);

    if (response.statusCode != 200) {
      return [];
    }

    final json = jsonDecode(response.body);

    final predictions = json["predictions"] as List;

    return predictions
        .map((e) => e["description"] as String)
        .toList();
  }
}