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

  const ReportResult({
    required this.userId,
    required this.pairs,
    required this.symptomFrequency,
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
      );
}

class ReportApi {
  final ApiService _api;

  ReportApi(this._api);

  Future<ReportResult> getReport({
    required String userId,
    int windowHours = 8,
  }) async {
    final body = await _api.get(
      '/api/reports/users/$userId?windowHours=$windowHours',
    );
    return ReportResult.fromJson(body as Map<String, dynamic>);
  }
}
