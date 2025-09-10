// 📁 lib/main.dart
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'view/intro_flow_screen.dart';        // ✅ 인트로+로그인 3단계 화면
import 'view/main_tab_scaffold.dart';        // 메인 탭
import 'view/scenario_select_screen.dart';   // 상황 선택
import 'utils/permission_util.dart';
import 'data/selected_target_store.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SelectedTargetStore.load(); // ✅ 이전 선택 복구

  // 🟡 Kakao SDK 초기화 (네이티브 앱 키로 교체)
  KakaoSdk.init(nativeAppKey: '1adbe559619162bc6e45f46c0fd2cd1d');

  // 🎤 권한
  await requestMicAndSpeechPermissions();

  // ▶️ 인트로 플로우부터 시작 (로고→카피→카카오 로그인)
  runApp(const AppRoot());
}

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(                 // ⛔ const 빼기!
      debugShowCheckedModeBanner: false,
      home: const IntroFlowScreen(),    // ✅ 클래스 이름/경로 정확히
    );
  }
}

/// 로그인 성공 후 진입: 상황 선택 화면
class PreEntryApp extends StatelessWidget {
  const PreEntryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ScenarioSelectScreen(
        onTargetsConfirmed: (targets) {
          SelectedTargetStore.setTargets(targets);
          runApp(const MyMainApp()); // ✅ 메인 앱으로
        },
      ),
    );
  }
}

/// 상황 선택 완료 후: 메인 탭
class MyMainApp extends StatelessWidget {
  const MyMainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainTabScreen(),
    );
  }
}