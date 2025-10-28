import 'package:flutter/material.dart';
import '../../../core/theme/brand.dart';
import '../../../core/theme/brand.dart' show Motion;

class AdvicePanel extends StatelessWidget {
  final String title;
  final List<String> bullets;
  const AdvicePanel({super.key, required this.title, required this.bullets});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1), duration: Motion.slow, curve: Motion.curve,
      builder: (_, t, child) => Transform.translate(
        offset: Offset(0, (1-t)*12),
        child: Opacity(opacity: t, child: child),
      ),
      child: Container(
        decoration: Brand.cardDeco(),
        padding: Brand.cardPad,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 10),
          ...bullets.map((b)=>Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('• ', style: TextStyle(fontWeight: FontWeight.w900, color: Brand.ink)),
              Expanded(child: Text(b, style: Theme.of(context).textTheme.bodyMedium)),
            ]),
          )),
        ]),
      ),
    );
  }
}