import 'api_service.dart';

class SymptomApi {
  final ApiService _api;

  SymptomApi(this._api);

  /// Registra um novo sintoma.
  ///
  /// [userId] UUID do usuário logado.
  /// [description] Descrição do sintoma.
  /// [date] Data/hora em que ocorreu.
  Future<void> createSymptom({
    required String userId,
    required String description,
    required DateTime date,
  }) async {
    await _api.post('/api/symptoms', {
      'userId': userId,
      'description': description,
      'date': date.toUtc().toIso8601String(),
    });
  }
}
