import 'dart:typed_data';
import 'api_service.dart';

class ReportPair {
  final int mealId;
  final String mealDate;
  final int symptomId;
  final String symptomDate;
  final int minutesBetween;
  final String symptomDescription;

  const ReportPair({
    required this.mealId,
    required this.mealDate,
    required this.symptomId,
    required this.symptomDate,
    required this.minutesBetween,
    required this.symptomDescription,
  });

  factory ReportPair.fromJson(Map<String, dynamic> json) => ReportPair(
        mealId: json['mealId'] as int,
        mealDate: json['mealDate'] as String,
        symptomId: json['symptomId'] as int,
        symptomDate: json['symptomDate'] as String,
        minutesBetween: json['minutesBetween'] as int,
        symptomDescription: json['symptomDescription'] as String,
      );
}

class ReportResult {
  final String userId;
  final List<ReportPair> pairs;
  final Map<String, int> symptomFrequency;
  final Map<String, int> allergenFrequency;
  final int mealCount;

  const ReportResult({
    required this.userId,
    required this.pairs,
    required this.symptomFrequency,
    required this.allergenFrequency,
    required this.mealCount,
  });

  factory ReportResult.fromJson(Map<String, dynamic> json) => ReportResult(
        userId: json['userId'] as String,
        pairs: (json['pairs'] as List)
            .map((e) => ReportPair.fromJson(e as Map<String, dynamic>))
            .toList(),
        symptomFrequency: Map<String, int>.from(
          (json['symptomFrequency'] as Map).map(
            (k, v) => MapEntry(k as String, (v as num).toInt()),
          ),
        ),
        allergenFrequency: json['allergenFrequency'] != null
            ? Map<String, int>.from(
                (json['allergenFrequency'] as Map).map(
                  (k, v) => MapEntry(k as String, (v as num).toInt()),
                ),
              )
            : {},
        mealCount: (json['mealCount'] as num?)?.toInt() ?? 0,
      );
}

class ReportApi {
  final ApiService _api;

  ReportApi(this._api);

  Future<ReportResult> getReport({
    required String userId,
    int windowHours = 8,
    DateTime? from,
    DateTime? to,
  }) async {
    final params = StringBuffer('?windowHours=$windowHours');
    if (from != null) {
      params.write('&from=${Uri.encodeComponent(from.toUtc().toIso8601String())}');
    }
    if (to != null) {
      // Inclui o dia inteiro do "to": vai até 23:59:59 do dia selecionado
      final endOfDay = DateTime(to.year, to.month, to.day, 23, 59, 59);
      params.write('&to=${Uri.encodeComponent(endOfDay.toUtc().toIso8601String())}');
    }

    final body = await _api.get('/api/reports/users/$userId$params');
    return ReportResult.fromJson(body as Map<String, dynamic>);
  }

  Future<Uint8List> exportReport({
    required String userId,
    int windowHours = 8,
    DateTime? from,
    DateTime? to,
  }) async {
    final params = StringBuffer('?windowHours=$windowHours');
    if (from != null) {
      params.write('&from=${Uri.encodeComponent(from.toUtc().toIso8601String())}');
    }
    if (to != null) {
      final endOfDay = DateTime(to.year, to.month, to.day, 23, 59, 59);
      params.write('&to=${Uri.encodeComponent(endOfDay.toUtc().toIso8601String())}');
    }
    return _api.getBytes('/api/reports/users/$userId/export$params');
  }
}
