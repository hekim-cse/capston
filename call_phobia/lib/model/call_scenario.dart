import 'package:flutter/cupertino.dart';

class ScenarioGroup {
  final String category;
  final String? nickname;
  final List<CallScenario> scenarios;

  ScenarioGroup({
    required this.category,
    this.nickname,
    required this.scenarios,
  });
}

// 📁 lib/model/call_scenario.dart

class CallScenario {
  final String title;
  final String description;
  final String jsonPath;
  final IconData icon;

  CallScenario({
    required this.title,
    required this.description,
    required this.jsonPath,
    required this.icon,
  });
}