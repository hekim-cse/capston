import 'package:flutter/material.dart';
import '../model/available_scenarios.dart';
import '../model/call_scenario.dart';
import '../view/call_chat_screen.dart';
import '../view/call_simulation_view.dart';

class ScenarioPreviewViewModel {
  final List<String> selectedTargets;

  // 대표 시나리오 갱신용 맵 (각 카테고리에서 대표 시나리오 하나 저장용)
  final Map<String, CallScenario> representativeMap = {};

  ScenarioPreviewViewModel(this.selectedTargets);

  // ✅ 선택된 category에 해당하는 시나리오들만 필터링
  List<CallScenario> getFilteredScenarios(List<ScenarioGroup> allGroups) {
    return allGroups
        .where((group) => selectedTargets.contains(group.category))
        .expand((group) => group.scenarios)
        .toList();
  }

  // ✅ 시나리오 클릭 시 CallSimulationView로 이동
  void goToCallScreen(BuildContext context, CallScenario scenario) {
    // 📌 시나리오를 포함하는 원본 그룹을 찾아냄
    final group = availableScenarioGroups.firstWhere(
          (g) => g.scenarios.contains(scenario),
      orElse: () => throw Exception('시나리오의 그룹을 찾을 수 없습니다.'),
    );

    // 대표 시나리오로 등록
    representativeMap[group.category] = scenario;

    // ✅ 화면 이동 (nickname 포함된 group과 함께)
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CallSimulationView(
          scenarioFile: scenario.jsonPath,
          title: scenario.title,
          group: group,
          scenario: scenario,
        ),
      ),
    );
  }
}