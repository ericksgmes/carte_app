import '../classes/food.dart';
import 'api_service.dart';

class FoodApi {
  final ApiService _api;

  FoodApi(this._api);

  Future<List<Food>> fetchByUserId(String userId) async {
    final body = await _api.get('/api/foods?userId=$userId');
    if (body is! List) throw Exception('Resposta inesperada de /api/foods');
    return body.map((e) => Food.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Food> createFood({
    required String userId,
    required String description,
    required List<int> allergenIds,
  }) async {
    final body = await _api.post('/api/foods', {
      'userId': userId,
      'description': description,
      'allergenIds': allergenIds,
    });
    return Food.fromJson(body as Map<String, dynamic>);
  }
}