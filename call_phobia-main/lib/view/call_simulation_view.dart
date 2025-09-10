import 'package:flutter/material.dart';
import '../model/call_scenario.dart';
import 'call_chat_screen.dart';

class CallSimulationView extends StatelessWidget {
  final String scenarioFile;
  final ScenarioGroup group;
  final String title;
  final CallScenario scenario;

  const CallSimulationView({
    super.key,
    required this.scenarioFile,
    required this.title,
    required this.group,
    required this.scenario,
  });

  @override
  Widget build(BuildContext context) {
    final callerName = group.nickname?.isNotEmpty == true ? group.nickname! : '발신자';

    return Scaffold(
      backgroundColor: Colors.transparent, // ✅ Scaffold 자체 배경 없애기
      body: Container(
        width: double.infinity, // ✅ 전체 화면 너비
        height: double.infinity, // ✅ 전체 화면 높이
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.grey[800]!,
              Colors.black,
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 상단 발신자 이름
              Positioned(
                top: 120,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    callerName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'nanum_r',
                    ),
                  ),
                ),
              ),

              // 하단 거절/응답 버튼
              Positioned(
                bottom: 80,
                left: -60,
                right: -60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildCircleButton(
                      icon: Icons.call_end,
                      label: '거절',
                      color: Colors.red,
                      onTap: () => Navigator.pop(context),
                    ),
                    _buildCircleButton(
                      icon: Icons.call,
                      label: '응답',
                      color: Colors.green,
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CallChatScreen(
                              scenarioFile: scenarioFile,
                              scenario: scenario,
                              group: group,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: CircleAvatar(
            radius: 36,
            backgroundColor: color,
            child: Icon(icon, color: Colors.white, size: 28),
          ),
        ),
        const SizedBox(height: 10),
        Text(label, style: const TextStyle(
            color: Colors.white,
            fontFamily: 'nanum_b',
            fontSize: 16,
        )),
      ],
    );
  }
}