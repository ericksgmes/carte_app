import 'dart:convert';
import 'package:http/http.dart' as http;

class Allergens {
  final String baseUrl;

  Allergens({required this.baseUrl});

  Future<List<String>> fetchAllergens() async {
    final response = await http.get(Uri.parse('$baseUrl/allergens'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Exemplo esperando algo tipo: ["gluten","dairy","soy"]
      if (data is List) {
        return data.map((e) => e.toString()).toList();
      }

      // Exemplo se vier: [{ "name": "gluten" }, ...]
      // return (data as List).map((e) => e['name'] as String).toList();
    }

    throw Exception('Failed to load allergens: ${response.statusCode}');
  }
}
