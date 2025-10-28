// lib/core/repo/local_iaq_repository.dart
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/iaq_snapshot.dart';

class LocalIaqRepository {
  final String assetPath;
  const LocalIaqRepository({this.assetPath = 'assets/data/data.json'});

  Future<IaqSnapshot> loadOnce() async {
    final raw = await rootBundle.loadString(assetPath);
    final j = jsonDecode(raw) as Map<String, dynamic>;
    return IaqSnapshot.fromJson(j);
  }

  /// 간단한 더미 예측 시계열(24시간) 생성: 현재값 기준 완만히 변동
  List<IaqSnapshot> synth24h(IaqSnapshot base) {
    final out = <IaqSnapshot>[];
    for (int h = 0; h <= 24; h++) {
      out.add(IaqSnapshot(
        timestamp: base.timestamp.add(Duration(hours: h)),
        riskWithin3hPercent: (base.riskWithin3hPercent + 0.05 * (h/24) - 0.025).clamp(0.0, 1.0),
        etaNextRiskHours: (base.etaNextRiskHours - h).clamp(0.0, 72.0),
        expectedRiskTimeNext24hHours: base.expectedRiskTimeNext24hHours,
        temperatureCelsius: base.temperatureCelsius + (h-12) * 0.08, // 일중 약변동
        humidityPercent: (base.humidityPercent + (h-12) * 0.1).clamp(0.0, 100.0),
      ));
    }
    return out;
  }
}