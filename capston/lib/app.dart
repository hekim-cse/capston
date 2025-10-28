// lib/app.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/theme/brand.dart';
import 'features/dashboard/view/measurement_screen.dart';
import 'features/dashboard/view/predict_screen.dart';
import 'features/intro/intro_screen.dart';
import 'features/dashboard/viewmodel/dashboard_vm.dart';
import 'features/dashboard/view/dashboard_home_screen.dart';
import 'features/dashboard/view/eng_dashboard_screen.dart';
import 'features/dashboard/view/mm_dashboard_screen.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _introDone = false;

  late final DashboardVM engVm =
  DashboardVM(assetPath: 'assets/data/data.json', storeKey: 'eng');
  late final DashboardVM mmVm =
  DashboardVM(assetPath: 'assets/data/mul.json', storeKey: 'mm');

  @override
  Widget build(BuildContext context) {
    final base = ThemeData(useMaterial3: true);
    final theme = base.copyWith(
      scaffoldBackgroundColor: Brand.bg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Brand.accent,
        brightness: Brightness.light,
        background: Brand.bg,
      ),
      textTheme: GoogleFonts.notoSansKrTextTheme(base.textTheme),
    );

    // lib/app.dart
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      initialRoute: '/intro',
      routes: {
        '/intro': (ctx) => IntroScreen(
          title: 'Team Crius',
          subtitle: '캠퍼스내 습/온도 데이터 기반 공기질 분석 및 곰팡이 예방을 위한 환기 안내 웹 서비스',
          onFinish: () => Navigator.pushReplacementNamed(ctx, '/dashboard'),
        ),
        '/dashboard': (ctx) => DashboardHomeScreen(
          engVm: engVm,
          mmVm: mmVm,
          onOpenEng: () => Navigator.pushNamed(ctx, '/eng'),
          onOpenMm: () => Navigator.pushNamed(ctx, '/mm'),
        ),
        '/eng': (ctx) => EngDashboardScreen(vm: engVm),
        '/mm' : (ctx) => MmDashboardScreen(vm: mmVm),
        '/measurement': (ctx) => const MeasurementScreen(),
        '/predict'    : (ctx) => const PredictScreen(),
      },
    );
  }
}