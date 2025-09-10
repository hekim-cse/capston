import 'package:flutter/material.dart';
import 'call_scenario.dart';

final List<ScenarioGroup> availableScenarioGroups = [
  ScenarioGroup(
    category: '가족',
    nickname: '엄마',
    scenarios: [
      CallScenario(
        title: '🗣️ 안부인사',
        description: '서로의 안부를 묻는 상황입니다.',
        jsonPath: 'assets/scenario/family_day report.json',
        icon: Icons.group, // ✅ 아이콘 직접 할당
      ),
    ],
  ),
  ScenarioGroup(
    category: '친구',
    nickname: '똥칼라파워',
    scenarios: [
      CallScenario(
        title: '🎉 생일 축하 전화',
        description: '친구에게 생일 축하 전화를 거는 상황입니다.',
        jsonPath: 'assets/scenario/friends_birthday.json',
        icon: Icons.group, // ✅ 아이콘 직접 할당
      ),
      CallScenario(
        title: '🗣 심심해서 거는 전화',
        description: '할 말은 없지만 그냥 통화하고 싶은 상황입니다.',
        jsonPath: 'assets/scenario/bored_call.json',
        icon: Icons.group, // ✅ 아이콘 직접 할당
      ),
      CallScenario(
        title: '📅 약속 잡는 전화',
        description: '친구와 만나기로 약속하는 상황입니다.',
        jsonPath: 'assets/scenario/make_plan.json',
        icon: Icons.group, // ✅ 아이콘 직접 할당
      ),
    ],
  ),
  ScenarioGroup(
    category: '연인',
    nickname: '❤️',
    scenarios: [
      CallScenario(
        title: '🗣️ 안부인사',
        description: '연인과 안부인사를 묻는 상황입니다.',
        jsonPath: 'assets/scenario/couple_day report.json',
        icon: Icons.group, // ✅ 아이콘 직접 할당
      ),
    ],
  ),
  ScenarioGroup(
    category: '회사',
    nickname: '김부장님',
    scenarios: [
      CallScenario(
        title: '🖥️ 보고서 제출',
        description: '보고서 제출에 관해 문의 오는 상황입니다.',
        jsonPath: 'assets/scenario/company_report.json',
        icon: Icons.group, // ✅ 아이콘 직접 할당
      ),
    ],
  ),
  ScenarioGroup(
    category: '마트',
    nickname: '신창마트',
    scenarios: [
      CallScenario(
        title: '🛒 마트 재고 확인',
        description: '마트 재고 확인을 위해 전화를 거는 상황입니다.',
        jsonPath: 'assets/scenario/mart_stack.json',
        icon: Icons.group, // ✅ 아이콘 직접 할당
      ),
    ],
  ),
  ScenarioGroup(
    category: '병원',
    nickname: '신창이비인후과',
    scenarios: [
      CallScenario(
        title: '🏥 병원 예약 전화',
        description: '병원 진료 예약으로 전화를 거는 상황입니다.',
        jsonPath: 'assets/scenario/hospital_reservation.json',
        icon: Icons.group, // ✅ 아이콘 직접 할당
      ),
    ],
  ),
  ScenarioGroup(
    category: '학교',
    nickname: '순천향대학교',
    scenarios: [
      CallScenario(
        title: '🍽 식당 예약 전화',
        description: '레스토랑에 예약 전화를 거는 상황입니다.',
        jsonPath: 'assets/scenario/restaurant_reservation.json',
        icon: Icons.group, // ✅ 아이콘 직접 할당
      ),
    ],
  ),
  ScenarioGroup(
    category: '교수님',
    nickname: '민교수님',
    scenarios: [
      CallScenario(
        title: '📞 교수님께 전화드리기',
        description: '교수님께 과제 문의 전화를 거는 상황입니다.',
        jsonPath: 'assets/scenario/professor_assignment.json',
        icon: Icons.group, // ✅ 아이콘 직접 할당
      ),
    ],
  ),
  ScenarioGroup(
    category: '식당',
    nickname: '신창족발',
    scenarios: [
      CallScenario(
        title: '🍽 식당 예약 전화',
        description: '레스토랑에 예약 전화를 거는 상황입니다.',
        jsonPath: 'assets/scenario/restaurant_reservation.json',
        icon: Icons.group, // ✅ 아이콘 직접 할당
      ),
    ],
  ),
];