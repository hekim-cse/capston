import 'package:flutter/material.dart';
import '../../../core/theme/brand.dart';
import '../../../core/layout/responsive.dart';

class TwoPanel extends StatelessWidget {
  final Widget left;   // 지도
  final Widget right;  // 제안
  const TwoPanel({super.key, required this.left, required this.right});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final wide = c.maxWidth >= Break.lg;
      // 뷰포트 비율 기반 높이(최소 보장)
      final h = wide ? (c.maxHeight > 0 ? (c.maxHeight*0.48).clamp(360, 520) : 420) : 520.0;

      return Flex(
        direction: wide ? Axis.horizontal : Axis.vertical,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              height: h.toDouble(),
              decoration: Brand.cardDeco(),
              clipBehavior: Clip.antiAlias,
              child: left,
            ),
          ),
          SizedBox(width: wide ? 16 : 0, height: wide ? 0 : 16),
          Expanded(
            flex: 2,
            child: Container(
              height: h.toDouble(),
              decoration: Brand.cardDeco(),
              padding: Brand.cardPad,
              child: right,
            ),
          ),
        ],
      );
    });
  }
}