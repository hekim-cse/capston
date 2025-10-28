// lib/features/intro/intro_screen.dart
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class IntroScreen extends StatefulWidget {
  final String title;
  final String subtitle;
  final VoidCallback onFinish;

  const IntroScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onFinish,
  });

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _fade;
  bool _dismissing = false;

  void _dismiss() {
    if (_dismissing) return;
    setState(() => _dismissing = true);
    // 살짝 페이드/축소 후 종료
    Future.delayed(const Duration(milliseconds: 220), widget.onFinish);
  }

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fade = CurvedAnimation(parent: _c, curve: Curves.easeInOut);
    _c.forward();

    // ⛔️ 시간 기반 자동 전환 제거 (스크롤/드래그/탭으로만 종료)
    // Future.delayed(const Duration(seconds: 3), widget.onFinish);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<ScrollUpdateNotification>(
        onNotification: (_) {
          _dismiss(); // 어떤 스크롤 업데이트라도 오면 종료
          return false;
        },
        child: Listener(
          onPointerSignal: (PointerSignalEvent e) {
            if (e is PointerScrollEvent) _dismiss(); // 마우스 휠/트랙패드
          },
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onPanStart: (_) => _dismiss(), // 방향 무관 첫 드래그에서 종료
            onTap: _dismiss,                // 탭으로도 종료 원하면 유지
            child: FadeTransition(
              opacity: _fade,
              child: AnimatedScale(
                scale: _dismissing ? 0.94 : 1.0,
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeInOut,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset('assets/images/img.jpg', fit: BoxFit.cover),
                    Container(color: Colors.black.withOpacity(0.7)),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.5,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              widget.subtitle,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}