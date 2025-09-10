// 📁 lib/view/main_tab_screen.dart
import 'home_tab_navigator.dart';
import 'package:flutter/material.dart';
import 'stats_screen.dart';
import 'profile_screen.dart';
import '../data/selected_target_store.dart';

class MainTabScreen extends StatefulWidget {
  const MainTabScreen({super.key});

  @override
  State<MainTabScreen> createState() => _MainTabScreenState();
}

class _MainTabScreenState extends State<MainTabScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          const StatsScreen(),
          const HomeTabNavigator(),
          ProfileScreen(selectedTargets: const []), // 쓰지 않음, 내부에서 Store를 참조
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white, // ← 흰색 배경
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFF60B5FF),      // 🔥 선택된 아이템 색상 (보라색 대신 파란색 예시)
        unselectedItemColor: Color(0xFFBFBFBF),   // 🔥 선택되지 않은 아이템 색상
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