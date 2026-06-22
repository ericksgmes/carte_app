import 'api_service.dart';

class MealApi {
  final ApiService _api;

  MealApi(this._api);

  Future<void> createMeal({
    required String userId,
    required DateTime date,
    required String description,
  }) async {
    await _api.post('/api/meals', {
      'userId': userId,
      'date': date.toUtc().toIso8601String(),
      'description': description,
    });
  }
}
