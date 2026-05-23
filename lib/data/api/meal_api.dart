import '../classes/food.dart';
import 'api_service.dart';

class MealApi {
  final ApiService _api;

  MealApi(this._api);

  /// Registra uma nova refeição.
  ///
  /// [userId] UUID do usuário logado.
  /// [date] Data/hora da refeição (ISO 8601).
  /// [foods] Lista de alimentos com seus alérgenos selecionados.
  Future<void> createMeal({
    required String userId,
    required DateTime date,
    required List<Food> foods,
  }) async {
    await _api.post('/api/meals', {
      'userId': userId,
      'date': date.toUtc().toIso8601String(),
      'foods': foods.map((f) => {
            'description': f.description,
            'allergenIds': f.allergens
                .map((a) => int.tryParse(a.id) ?? 0)
                .where((id) => id > 0)
                .toList(),
          }).toList(),
    });
  }
}
