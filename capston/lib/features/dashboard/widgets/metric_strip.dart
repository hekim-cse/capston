// lib/features/dashboard/widgets/metric_strip.dart
import 'package:flutter/material.dart';
import '../../../core/models/measurement.dart';
import '../../../core/theme/brand.dart';
import '../../../core/theme/brand.dart' show Motion;

/// 상단 지표 스트립: 각 값(습도/온도) 아래에 해당 멘트가 붙는다.
class MetricStrip extends StatelessWidget {
  final Measurement m;
  const MetricStrip({super.key, required this.m});

  @override
  Widget build(BuildContext context) {
    final humAdvice = _humidityAdvice(m.rh);
    final tempAdvice = _temperatureAdvice(m.temp);

    return AnimatedContainer(
      duration: Motion.med,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _vcell(label: '습도 RH', value: m.rh.toStringAsFixed(1), unit: '%', notes: humAdvice),
          const SizedBox(height: 16),
          _vcell(label: '온도', value: m.temp.toStringAsFixed(1), unit: '℃', notes: tempAdvice),
        ],
      ),
    );
  }

  // ── 멘트 로직(임계치 원하면 조정 가능) ───────────────────────────
  List<String> _humidityAdvice(double rh) {
    if (rh < 40) return ['습도가 낮아요. 가습 또는 젖은 수건 활용을 권장합니다.'];
    if (rh > 60) return ['습도가 높아요. 제습 및 환기를 권장합니다.'];
    return ['습도는 40~60%로 양호합니다.'];
    // 필요하면 추가 라인으로 더 넣기 가능
  }

  List<String> _temperatureAdvice(double t) {
    if (t < 18) return ['실내 온도가 낮아요. 난방 가동을 고려하세요.'];
    if (t > 27) return ['실내 온도가 높아요. 냉방 또는 환기를 권장합니다.'];
    return ['실내 온도는 적정 범위예요.'];
  }

  // ── 단일 지표 셀(라벨/값/단위 + 멘트 리스트) ──────────────────────
  Widget _vcell({
    required String label,
    required String value,
    String? unit,
    List<String> notes = const [],
  }) {
    return _HoverScale(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: const TextStyle(color: Brand.sub, fontSize: 12)),
          const SizedBox(height: 6),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
              if (unit != null) ...[
                const SizedBox(width: 6),
                Text(unit, style: const TextStyle(color: Brand.sub, fontWeight: FontWeight.w600)),
              ],
            ],
          ),
          if (notes.isNotEmpty) ...[
            const SizedBox(height: 8),
            Column(
              children: notes
                  .map((t) => Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text('• $t',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Brand.sub, fontSize: 13, height: 1.35)),
              ))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _HoverScale extends StatefulWidget {
  final Widget child;
  const _HoverScale({required this.child});
  @override
  State<_HoverScale> createState() => _HoverScaleState();
}

class _HoverScaleState extends State<_HoverScale> {
  bool hover = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => hover = true),
      onExit: (_) => setState(() => hover = false),
      child: AnimatedScale(
        scale: hover ? 1.02 : 1.0,
        duration: Motion.fast,
        child: widget.child,
      ),
    );
  }
}