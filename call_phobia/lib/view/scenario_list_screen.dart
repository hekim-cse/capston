import 'package:flutter/material.dart';
import '../model/available_scenarios.dart';
import '../model/call_scenario.dart';
import '../utils/icon_util.dart';
import 'call_simulation_view.dart';

class ScenarioListScreen extends StatelessWidget {
  final List<CallScenario> scenarios;
  final ScenarioGroup group;

  const ScenarioListScreen({
    super.key,
    required this.scenarios,
    required this.group,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Colors.black.withOpacity(0.15),
            height: 1,
          ),
        ),
        title: Row(
          children: [
            Icon(
              getIconForTarget(group.category),
              color: const Color(0xFFFF9149),
              size: 26,
            ),
            const SizedBox(width: 8),
            Text(
              group.category,
              style: const TextStyle(
                color: Color(0xFFFF9149),
                fontFamily: 'nanum_eb',
                fontSize: 23,
              ),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(top: 18),
        itemCount: scenarios.length,
        itemBuilder: (context, index) {
          final scenario = scenarios[index];

          // ✅ 여기서 시나리오의 원본 그룹을 가져옴
          final originalGroup = availableScenarioGroups.firstWhere(
                (g) => g.scenarios.contains(scenario),
            orElse: () => throw Exception('해당 시나리오의 그룹을 찾을 수 없습니다.'),
          );

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CallSimulationView(
                    group: originalGroup, // ✅ nickname 포함된 원본 객체!
                    title: scenario.title,
                    scenario: scenario,
                    scenarioFile: scenario.jsonPath,
                  ),
                ),
              );
            },
            child: Card(
              color: const Color(0xffE6F1FB),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              scenario.title,
                              style: const TextStyle(
                                color: Color(0xFF143D60),
                                fontFamily: 'nanum_eb',
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              scenario.description,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF27667B),
                                fontFamily: 'nanum_b',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}