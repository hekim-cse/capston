import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/theme/brand.dart';
import '../../../core/theme/brand.dart' show Motion;
import '../view/dashboard_home_screen.dart';
import '../view/measurement_screen.dart';
import '../view/predict_screen.dart';

// lib/features/dashboard/widgets/top_nav.dart
class TopNav extends StatelessWidget implements PreferredSizeWidget {
  final ScrollController? controller;
  const TopNav({super.key, this.controller});

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final shrink = (controller?.hasClients ?? false) && (controller!.offset > 24);
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: shrink ? 6 : 0, sigmaY: shrink ? 6 : 0),
        child: AnimatedContainer(
          duration: Motion.med,
          curve: Motion.curve,
          padding: Brand.page.copyWith(top: shrink ? 8 : 18, bottom: shrink ? 8 : 18),
          decoration: const BoxDecoration(
            color: Color(0xE6FFFFFF),
            border: Border(bottom: BorderSide(color: Brand.line)),
          ),
          child: Row(
            children: const [
              Text('Team Crius', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: -0.3)),
              SizedBox(width: 18), _Dot(), SizedBox(width: 18),
              _NavItem('Dashboard', '/dashboard'),
              _NavItem('Measurement', '/measurement'),
              _NavItem('Predict', '/predict'),
              Spacer(),
              Text('About', style: TextStyle(color: Brand.ink)),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String label;
  final String route;
  const _NavItem(this.label, this.route, {super.key});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 6),
    child: TextButton(
      onPressed: () => Navigator.pushNamed(context, route),
      style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
      child: Text(label, style: const TextStyle(color: Brand.ink, fontWeight: FontWeight.w700)),
    ),
  );
}



class _Dot extends StatelessWidget {
  const _Dot({super.key});
  @override
  Widget build(BuildContext context) => Container(
    width: 6,
    height: 6,
    decoration:
    const BoxDecoration(color: Brand.ink, shape: BoxShape.circle),
  );
}