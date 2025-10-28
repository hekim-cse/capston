import 'package:flutter/widgets.dart';

class Break {
  static const double md = 840;
  static const double lg = 1120;
  static const double xl = 1440;
}

extension LayoutX on BoxConstraints {
  bool get isMd => maxWidth >= Break.md && maxWidth < Break.lg;
  bool get isLg => maxWidth >= Break.lg && maxWidth < Break.xl;
  bool get isXl => maxWidth >= Break.xl;
}