// lib/features/dashboard/widgets/trend_chart.dart
import 'package:flutter/material.dart';
import '../../../core/theme/brand.dart';

class TrendChart extends StatelessWidget {
  final String title;
  final List<double>? series; // 추가

  const TrendChart({super.key, required this.title, this.series});

  @override
  Widget build(BuildContext context) {
    final last = (series?.isNotEmpty ?? false) ? series!.last : null;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(12),
        height: 180,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            if (last != null)
              Text(
                last.toStringAsFixed(1),
                style: Theme.of(context).textTheme.displaySmall,
              ),
            const SizedBox(height: 8),
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.03),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(child: Text('Chart Placeholder')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}