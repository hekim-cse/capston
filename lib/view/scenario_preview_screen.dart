import 'package:flutter/material.dart';
import '../model/call_scenario.dart';
import '../model/available_scenarios.dart';
import '../utils/icon_util.dart';
import '../widgets/user_greeting_bar.dart';
import '../data/selected_target_store.dart';
import 'scenario_list_screen.dart';
import 'call_simulation_view.dart';

class ScenarioPreviewScreen extends StatelessWidget {
  const ScenarioPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        titleSpacing: 20,
        elevation: 0,
        toolbarHeight: 70,
        title: const UserGreetingBar(),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: Colors.black.withOpacity(0.15)),
        ),
      ),
      backgroundColor: Colors.white,

      // ✅ 선택된 카테고리 변경에 자동 반응
      body: ValueListenableBuilder<List<String>>(
        valueListenable: SelectedTargetStore.notifier,
        builder: (context, selected, _) {
          // 선택된 카테고리 중, 시나리오가 있는 그룹만 대표 시나리오(첫 항목) 뽑기
          final Map<String, CallScenario> representatives = {};
          final Map<String, ScenarioGroup> groupMap = {};

          for (final group in availableScenarioGroups) {
            if (selected.contains(group.category) && group.scenarios.isNotEmpty) {
              representatives[group.category] = group.scenarios.first;
              groupMap[group.category] = group;
            }
          }

          if (representatives.isEmpty) {
            return const Center(
              child: Text(
                '선택된 상황이 없습니다.',
                style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'nanum_b',
                  fontSize: 16,
                ),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 30),
            children: representatives.entries.map((entry) {
              final category = entry.key;
              final scenario  = entry.value;
              final group     = groupMap[category]!;

              return Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        margin: const EdgeInsets.only(top: 24),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE6F1FB),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(2, 2),
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 28),
                            Text(
                              scenario.title,
                              style: const TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'nanum_eb',
                                color: Color(0xFF143D60),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              scenario.description,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF27667B),
                                fontFamily: 'nanum_b',
                              ),
                            ),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.center,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => CallSimulationView(
                                        group: group,
                                        title: scenario.title,
                                        scenario: scenario,
                                        scenarioFile: scenario.jsonPath,
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF7BC1FE),
                                  minimumSize: const Size(155, 35),
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  '시작하기',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'nanum_eb',
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // 🔶 카테고리 배지
                    Positioned(
                      top: 0,
                      left: 24,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ScenarioListScreen(
                                group: group,
                                scenarios: group.scenarios,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF9149),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 4,
                                offset: const Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(getIconForTarget(category), color: Colors.white, size: 20),
                              const SizedBox(width: 6),
                              Text(
                                category,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'nanum_eb',
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(Icons.chevron_right, color: Colors.white, size: 18),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}