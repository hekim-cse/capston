// 📁 lib/data/selected_target_store.dart
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectedTargetStore {
  // 기존 정적 리스트는 유지(하위 호환), 그러나 Notifier가 진짜 소스
  static List<String> targets = [];

  // ✅ 화면들이 구독할 수 있는 Notifier
  static final ValueNotifier<List<String>> notifier =
  ValueNotifier<List<String>>(<String>[]);

  static Future<void> load() async {
    final sp = await SharedPreferences.getInstance();
    final list = sp.getStringList('selected_targets') ?? <String>[];
    targets = List.from(list);
    notifier.value = List.from(list);
  }

  static Future<void> setTargets(List<String> list) async {
    targets = List.from(list);
    notifier.value = List.from(list); // ✅ 구독자들에게 알림
    final sp = await SharedPreferences.getInstance();
    await sp.setStringList('selected_targets', targets);
  }
}