import 'package:flutter/material.dart';
import '../data/selected_target_store.dart';
import 'scenario_select_screen.dart';
import 'scenario_preview_screen.dart';

class HomeTabNavigator extends StatelessWidget {
  const HomeTabNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    // 선택 상태가 바뀌면 자동으로 리빌드
    return ValueListenableBuilder<List<String>>(
      valueListenable: SelectedTargetStore.notifier,
      builder: (context, selected, _) {
        final hasSelection = selected.isNotEmpty;

        if (hasSelection) {
          // ✅ 파라미터 없이 사용 (ScenarioPreviewScreen이 내부에서 선택값을 구독)
          return const ScenarioPreviewScreen();
        } else {
          // 최초 진입: 선택 화면
          return ScenarioSelectScreen(
            onTargetsConfirmed: (targets) {
              // 저장만 하면 위의 ValueListenableBuilder가 갱신을 트리거함
              SelectedTargetStore.setTargets(targets);
            },
          );
        }
      },
    );
  }
}