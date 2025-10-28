import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/foundation.dart';
import '../../../core/models/measurement.dart';

class DashboardVM extends ChangeNotifier {
  final String assetPath;
  final String storeKey;
  DashboardVM({required this.assetPath, required this.storeKey});

  Measurement? latest;

  // insight
  double? r3hPercent;
  double? etaNextRiskHours;
  double? expectedRiskTimeNext24hHours;

  final List<bool> opsChecklist = List<bool>.filled(5, false);

  // 외부 접근 가능한 로그 리스트
  final List<OpsLog> _opsLogs = [];
  List<OpsLog> get opsLogs => List.unmodifiable(_opsLogs);

  void addOpsLog(String title, {String memo = '', bool success = true, DateTime? at}) {
    final t = at ?? DateTime.now();
    _opsLogs.insert(
      0,
      OpsLog(
        title: title,
        memo: memo,
        timeHM: '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}',
        success: success,
      ),
    );
    notifyListeners();
  }

  Future<void> init() async {
    final raw = await rootBundle.loadString(assetPath);
    final Map<String, dynamic> j = json.decode(raw);

    r3hPercent                   = _num(j['risk_within_3h_percent']);
    etaNextRiskHours             = _num(j['eta_next_risk_hours']);
    expectedRiskTimeNext24hHours = _num(j['expected_risk_time_next_24h_hours']);

    final Map<String, dynamic>? last = (j['latest'] ?? j['last']) as Map<String, dynamic>?;
    if (last != null) {
      latest = Measurement.fromJson(last);
    } else {
      final h = _num(j['humidity_percent']);
      final t = _num(j['temperature_celsius']);
      if (h != null || t != null) {
        latest = Measurement(rh: h ?? 0, temp: t ?? 0);
      }
    }
    notifyListeners();
  }

  void saveOpsChecklist(List<bool> xs) {
    for (var i = 0; i < opsChecklist.length && i < xs.length; i++) {
      opsChecklist[i] = xs[i];
    }
    notifyListeners();
  }

  List<bool> getOpsChecklist() => List<bool>.from(opsChecklist);

  double? _num(dynamic v) => (v is num) ? v.toDouble() : null;
}

// 로그 데이터 모델
class OpsLog {
  final String title, memo, timeHM;
  final bool success;
  OpsLog({
    required this.title,
    required this.memo,
    required this.timeHM,
    required this.success,
  });
}