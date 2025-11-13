import 'dart:convert';
import 'package:carte_app/data/classes/allergen.dart';
import 'package:http/http.dart' as http;

class AllergensApi {
  final String baseUrl;
  AllergensApi({required this.baseUrl});

  Future<List<Allergen>> fetchAllergens() async {
    final res = await http.get(Uri.parse('$baseUrl/allergens'));
    if (res.statusCode != 200) {
      throw Exception('Failed to load allergens: ${res.statusCode}');
    }

    final body = jsonDecode(res.body);

    if (body is List && body.first is Map) {
      return body
          .map<Allergen>((e) => Allergen.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    throw Exception('Unexpected allergens payload: ${res.body}');
  }
}
