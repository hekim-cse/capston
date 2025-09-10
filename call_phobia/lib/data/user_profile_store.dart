import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class UserProfileStore {
  UserProfileStore._();
  static final UserProfileStore I = UserProfileStore._();

  String? nickname;              // 카카오에서 받은 닉네임
  String? selectedAsset;         // 앱 내 프로필 이미지 asset 경로

  Future<void> load() async {
    final p = await SharedPreferences.getInstance();
    nickname = p.getString('profile.nickname');
    selectedAsset = p.getString('profile.asset');
  }

  Future<void> save() async {
    final p = await SharedPreferences.getInstance();
    await p.setString('profile.nickname', nickname ?? '');
    await p.setString('profile.asset', selectedAsset ?? '');
  }

  ImageProvider? get avatar {
    if (selectedAsset != null && selectedAsset!.isNotEmpty) {
      return AssetImage(selectedAsset!);
    }
    return null;
  }
}