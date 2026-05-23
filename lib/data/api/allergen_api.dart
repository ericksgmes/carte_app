import '../classes/allergen.dart';
import 'api_service.dart';

class AllergenApi {
  final ApiService _api;

  AllergenApi(this._api);

  Future<List<Allergen>> fetchAll() async {
    final body = await _api.get('/api/allergens');

    if (body is! List) {
      throw Exception('Resposta inesperada de /api/allergens: $body');
    }

    return body
        .map((e) => Allergen.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
