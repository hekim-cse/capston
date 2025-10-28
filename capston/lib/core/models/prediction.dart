// core/models/prediction.dart
class Prediction {
  final DateTime ts;
  final double rh;     // humidity %
  final double temp;   // celsius

  // (화면 다른 요소에 쓰고 싶으면 아래들도 보관 가능)
  final double riskWithin3h;
  final double etaNextRiskHours;
  final double expectedRiskTime24h;

  const Prediction({
    required this.ts,
    required this.rh,
    required this.temp,
    required this.riskWithin3h,
    required this.etaNextRiskHours,
    required this.expectedRiskTime24h,
  });

  factory Prediction.fromJson(Map<String, dynamic> j) {
    return Prediction(
      ts: DateTime.parse(j['timestamp'] as String),
      rh: (j['humidity_percent'] as num).toDouble(),
      temp: (j['temperature_celsius'] as num).toDouble(),
      riskWithin3h: (j['risk_within_3h_percent'] as num).toDouble(),
      etaNextRiskHours: (j['eta_next_risk_hours'] as num).toDouble(),
      expectedRiskTime24h: (j['expected_risk_time_next_24h_hours'] as num).toDouble(),
    );
  }
}