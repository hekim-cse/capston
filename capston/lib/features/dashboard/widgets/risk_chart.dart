// lib/features/dashboard/widgets/risk_chart.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../core/models/iaq_snapshot.dart';

class RiskChart extends StatelessWidget {
  final List<IaqSnapshot> series; // 0~24h
  const RiskChart({super.key, required this.series});

  @override
  Widget build(BuildContext context) {
    if (series.isEmpty) return const SizedBox.shrink();
    final spots = <FlSpot>[];
    final t0 = series.first.timestamp;
    for (final p in series) {
      final dx = p.timestamp.difference(t0).inMinutes / 60.0; // 시간
      final dy = (p.riskWithin3hPercent * 100.0).clamp(0.0, 100.0);
      spots.add(FlSpot(dx, dy));
    }

    return Container(
      height: 260,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12, offset: const Offset(0,6))],
      ),
      child: LineChart(
        LineChartData(
          minX: 0, maxX: 24, minY: 0, maxY: 100,
          gridData: FlGridData(show: true, horizontalInterval: 20, verticalInterval: 6),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, interval: 20, reservedSize: 36)),
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, interval: 6)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              barWidth: 3,
              color: Colors.orangeAccent,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(show: true, color: Colors.orangeAccent.withOpacity(0.18)),
            ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => Colors.black87,
              getTooltipItems: (touchedSpots) => touchedSpots.map((s) {
                return LineTooltipItem(
                  '${s.x.toStringAsFixed(1)}h\n${s.y.toStringAsFixed(0)}%',
                  const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}