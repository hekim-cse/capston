import 'package:flutter/physics.dart';
import 'package:flutter/widgets.dart';

/// 페이지 스크롤 전환을 부드럽게 만드는 Physics
class SoftPagePhysics extends PageScrollPhysics {
  const SoftPagePhysics({super.parent});

  // 탄성을 조금 말랑하게
  @override
  SpringDescription get spring =>
      const SpringDescription(mass: 1.0, stiffness: 90.0, damping: 20.0);

  // 플링 속도를 살짝 줄여 과도한 가속 방지
  @override
  Simulation? createBallisticSimulation(ScrollMetrics position, double velocity) {
    final v = velocity * 0.65; // 65%만 반영
    return super.createBallisticSimulation(position, v);
  }
}