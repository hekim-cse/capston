// 📁 lib/view/scenario_select_screen.dart
import 'package:flutter/material.dart';
import '../viewmodel/scenario_select_viewmodel.dart';
import '../utils/icon_util.dart'; // ✅ 아이콘 유틸 불러오기

class ScenarioSelectScreen extends StatefulWidget {
  final void Function(List<String> targets) onTargetsConfirmed;
  const ScenarioSelectScreen({super.key, required this.onTargetsConfirmed});

  @override
  State<ScenarioSelectScreen> createState() => _ScenarioSelectScreenState();
}

class _ScenarioSelectScreenState extends State<ScenarioSelectScreen> {
  final ScenarioSelectViewModel viewModel = ScenarioSelectViewModel();

  @override
  Widget build(BuildContext context) {
    final targets = viewModel.availableTargets;
    final selected = viewModel.selectedTargets;

    return Scaffold(
      backgroundColor: const Color(0xFF60B5FF),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 130),
            const Text(
              '어떤 상황에서\n용기가 필요하시나요?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontFamily: 'nanum_eb',
                color: Color(0xFFFFECDB),
              ),
            ),
            const SizedBox(height: 70),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              childAspectRatio: 1.3,
              children: targets.map((target) {
                final isSelected = selected.contains(target);
                return GestureDetector(
                  onTap: () => setState(() => viewModel.toggleTarget(target)),
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSelected ? Color(0xFFFF9149) : Color(0xFFFFECDB),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 3,
                          offset: Offset(2, 2),
                        )
                      ],
                    ),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            getIconForTarget(target),
                            size: 20,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            target,
                            style: TextStyle(
                              fontFamily: "nanum_eb",
                              fontSize: 20,
                              color: isSelected ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: selected.isNotEmpty
                  ? () => widget.onTargetsConfirmed(selected.toList())
                  : null,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                  if (states.contains(MaterialState.disabled)) {
                    return const Color(0xFFE0E0E0); // 비활성 배경
                  }
                  return Color(0xFFFF9149);; // 활성 배경
                }),
                foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                  if (states.contains(MaterialState.disabled)) {
                    return Colors.grey; // 비활성 글자색
                  }
                  return Colors.white; // 활성 글자색
                }),
                minimumSize: MaterialStateProperty.all(const Size(200, 48)),
              ),
              child: const Text(
                '완료',
                style: TextStyle(
                  fontFamily: 'nanum_eb',
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}