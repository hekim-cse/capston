// lib/core/models/iaq_snapshot.dart
class IaqSnapshot {
  final DateTime timestamp;
  final double riskWithin3hPercent;         // 0.0 ~ 1.0
  final double etaNextRiskHours;            // 시간
  final double expectedRiskTimeNext24hHours;// 시간
  final double temperatureCelsius;          // ℃
  final double humidityPercent;             // %

  IaqSnapshot({
    required this.timestamp,
    required this.riskWithin3hPercent,
    required this.etaNextRiskHours,
    required this.expectedRiskTimeNext24hHours,
    required this.temperatureCelsius,
    required this.humidityPercent,
  });

  factory IaqSnapshot.fromJson(Map<String, dynamic> j) {
    return IaqSnapshot(
      timestamp: DateTime.parse(j['timestamp'] as String),
      riskWithin3hPercent: (j['risk_within_3h_percent'] as num).toDouble(),
      etaNextRiskHours: (j['eta_next_risk_hours'] as num).toDouble(),
      expectedRiskTimeNext24hHours: (j['expected_risk_time_next_24h_hours'] as num).toDouble(),
      temperatureCelsius: (j['temperature_celsius'] as num).toDouble(),
      humidityPercent: (j['humidity_percent'] as num).toDouble(),
    );
  }
}