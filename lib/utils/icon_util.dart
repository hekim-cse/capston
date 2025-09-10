import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

IconData getIconForTarget(String category) {
  switch (category) {
    case '친구':
      return Icons.group;
    case '식당':
      return Icons.restaurant;
    case '교수님':
      return Icons.school;
    case '병원':
      return Icons.local_hospital;
    case '회사':
      return Icons.business;
    case '연인':
      return Icons.favorite;
    case '마트':
      return Icons.shopping_cart;
    case '가족':
      return Icons.home;
    case '학교':
      return Icons.apartment;
    default:
      return Icons.question_mark;
  }
}