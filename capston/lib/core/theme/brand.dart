import 'package:flutter/material.dart';

class Brand {
  // Monochrome
  static const Color bg    = Color(0xFFF8F8F8);
  static const Color card  = Colors.white;
  static const Color ink   = Color(0xFF111111);
  static const Color sub   = Color(0xFF6B6B6B);
  static const Color line  = Color(0xFFEAEAEA);
  static const Color accent= Color(0xFF111111); // 단색 포인트

  static const double r = 18;
  static const EdgeInsets page = EdgeInsets.symmetric(horizontal: 28, vertical: 22);
  static const EdgeInsets cardPad = EdgeInsets.all(18);

  static BoxDecoration cardDeco([Color? c]) => BoxDecoration(
    color: c ?? card,
    borderRadius: BorderRadius.circular(r),
    border: Border.all(color: line),
    boxShadow: const [BoxShadow(color: Color(0x0F000000), blurRadius: 18, offset: Offset(0, 10))],
  );
}

class Motion {
  static const Curve curve = Curves.easeInOutCubic;
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration med  = Duration(milliseconds: 420);
  static const Duration slow = Duration(milliseconds: 800);
}