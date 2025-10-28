import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/env.dart';

class IaqApi {
  final http.Client _c;
  IaqApi(this._c);

  Future<List<Map<String, dynamic>>> getRooms() async {
    if (Env.useMock) {
      await Future.delayed(const Duration(milliseconds: 300));
      return [
        {"room_id":"R101","building":"A","floor":1,"name":"101"},
        {"room_id":"R202","building":"A","floor":2,"name":"202"},
      ];
    }
    final r = await _c.get(Uri.parse('${Env.baseUrl}/rooms'));
    return (jsonDecode(r.body) as List).cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> getLatest(String roomId) async {
    if (Env.useMock) {
      await Future.delayed(const Duration(milliseconds: 200));
      return {
        "room_id": roomId,
        "ts": DateTime.now().toIso8601String(),
        "metrics": {"rh": 62.3, "tvoc": 420, "pm25": 18, "co2e": 980, "temp": 25.4}
      };
    }
    final r = await _c.get(Uri.parse('${Env.baseUrl}/latest?room_id=$roomId'));
    return jsonDecode(r.body);
  }

  Future<List<Map<String, dynamic>>> getHistory(String roomId) async {
    if (Env.useMock) {
      final now = DateTime.now();
      final list = List.generate(24, (i) {
        final t = now.subtract(Duration(hours: 23 - i));
        return {
          "room_id": roomId,
          "ts": t.toIso8601String(),
          "metrics": {
            "rh": 48 + (i % 6) * 2,
            "tvoc": 250 + (i % 8) * 40,
            "pm25": 10 + (i % 5) * 3,
            "co2e": 800 + (i % 7) * 50,
            "temp": 24 + (i % 4) * 0.5
          }
        };
      });
      await Future.delayed(const Duration(milliseconds: 220));
      return list;
    }
    final r = await _c.get(Uri.parse('${Env.baseUrl}/history?room_id=$roomId&hours=24'));
    return (jsonDecode(r.body) as List).cast<Map<String, dynamic>>();
  }
}