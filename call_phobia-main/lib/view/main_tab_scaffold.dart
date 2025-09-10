// 📁 lib/view/main_tab_screen.dart
import 'package:flutter/material.dart';

import 'home_tab_navigator.dart';
import 'stats_screen.dart';
// ⬇️ 별칭으로 임포트
import 'profile_screen.dart';

class MainTabScreen extends StatefulWidget {
  const MainTabScreen({super.key});

  @override
  State<MainTabScreen> createState() => _MainTabScreenState();
}

class _MainTabScreenState extends State<MainTabScreen> {
  int _selectedIndex = 1; // 홈 탭을 기본으로 보고 싶다면 1

  List<Widget> get _pages => const [
    StatsScreen(),
    HomeTabNavigator(),
    // ⬆️ 두 개는 const 생성자 가능
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        // ⬇️ 세 번째 페이지는 selectedTargets를 전달해야 하므로 별도로 빌드
        children: [
          _pages[0],
          _pages[1],
          // 별칭으로 명시 + 파라미터 전달
          ProfileScreen(selectedTargets: const []),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF60B5FF),
        unselectedItemColor: const Color(0xFFBFBFBF),
        onTap: (i) => setState(() => _selectedIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: '통계'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '프로필'),
        ],
      ),
    );
  }
}