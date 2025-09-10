import 'package:flutter/material.dart';
import '../view/scenario_preview_screen.dart';
import '../data/selected_target_store.dart';

class ScenarioSelectViewModel {
  // 선택 가능한 대상 목록 (availableScenarioGroups와 일치하도록 유지)
  final List<String> availableTargets = const [
    '가족', '친구', '연인', '회사', '마트', '병원',
    '학교', '교수님', '식당',
  ];

  // 선택된 대상
  final Set<String> selectedTargets = {};

  // 토글 선택
  void toggleTarget(String target) {
    if (selectedTargets.contains(target)) {
      selectedTargets.remove(target);
    } else {
      selectedTargets.add(target);
    }
  }

  // 다음 화면으로 이동
  void goToNextScreen(BuildContext context) {
    // ✅ 전역 스토어에 선택값 반영 (ValueNotifier가 listeners에게 알림)
    SelectedTargetStore.setTargets(selectedTargets.toList());

    // ✅ 파라미터 없이 전환 (미리보기 화면은 스토어를 구독)
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const ScenarioPreviewScreen()),
    );
  }
}