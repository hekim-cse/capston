import 'package:flutter/material.dart';
import '../data/user_profile_store.dart';

class UserGreetingBar extends StatelessWidget {
  const UserGreetingBar({super.key});

  @override
  Widget build(BuildContext context) {
    // 닉네임/프로필 (없을 때의 안전한 기본값)
    final nickname = UserProfileStore.I.nickname ?? '사용자';
    final profileAsset = UserProfileStore.I.selectedAsset ?? 'assets/profile/p1.png';

    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundImage: AssetImage(profileAsset),
        ),
        const SizedBox(width: 10),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: nickname,
                style: const TextStyle(
                  fontFamily: 'nanum_eb',
                  fontSize: 18,
                  color: Color(0xFFFF9149), // 이름 파란색
                ),
              ),
              const TextSpan(
                text: ' 님 반갑습니다',
                style: TextStyle(
                  fontFamily: 'nanum_b',
                  fontSize: 15,
                  color: Color(0xFF60B5FF),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}