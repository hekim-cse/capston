import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/theme/brand.dart';

class MapPlaceholder extends StatefulWidget {
  const MapPlaceholder({super.key});
  @override State<MapPlaceholder> createState() => _MapPlaceholderState();
}

class _MapPlaceholderState extends State<MapPlaceholder> with SingleTickerProviderStateMixin {
  late final AnimationController _a;
  @override void initState(){ super.initState(); _a = AnimationController(vsync:this, duration: const Duration(seconds: 3))..repeat(); }
  @override void dispose(){ _a.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _a,
      builder: (_, __) {
        return CustomPaint(
          painter: _GridPainter(t: _a.value),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text('지도 API 자리 (추후 색상/히트맵 시각화)', style: Theme.of(context).textTheme.bodyMedium),
            ),
          ),
        );
      },
    );
  }
}

class _GridPainter extends CustomPainter {
  final double t;
  _GridPainter({required this.t});

  @override
  void paint(Canvas c, Size s) {
    // 배경
    final bg = Paint()..color = Colors.white;
    c.drawRect(Offset.zero & s, bg);

    // 그리드
    final p = Paint()..color = Brand.line..strokeWidth = 1;
    const step = 28.0;
    for (double x=0; x<=s.width; x+=step) {
      c.drawLine(Offset(x,0), Offset(x,s.height), p);
    }
    for (double y=0; y<=s.height; y+=step) {
      c.drawLine(Offset(0,y), Offset(s.width,y), p);
    }

    // 은은한 펄스 (지도 영역 강조)
    final r = min(s.width, s.height)*.18;
    final cx = s.width*.5, cy = s.height*.5;
    final pulse = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Brand.ink.withOpacity(.06 + .06*(.5+sin(t*2*pi)*.5));
    c.drawCircle(Offset(cx,cy), r, pulse);
    c.drawCircle(Offset(cx,cy), r*1.35, pulse);
  }
  @override bool shouldRepaint(covariant _GridPainter old)=> old.t!=t;
}