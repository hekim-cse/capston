import 'package:flutter/material.dart';
import '../data/user_profile_store.dart';
import '../main.dart'; // PreEntryApp

class ProfilePickScreen extends StatefulWidget {
  const ProfilePickScreen({super.key});

  @override
  State<ProfilePickScreen> createState() => _ProfilePickScreenState();
}

class _ProfilePickScreenState extends State<ProfilePickScreen> {
  final List<String> _assets = const [
    'assets/profile/p1.png',
    'assets/profile/p2.png',
    'assets/profile/p3.png',
    'assets/profile/p4.png',
    'assets/profile/p5.png',
  ];

  static const _orange = Color(0xFFFF9149);
  static const _beige  = Color(0xFFFFECDB);
  static const _bgBlue = Color(0xFF60B5FF);

  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    final selected = UserProfileStore.I.selectedAsset;
    _currentIndex = selected != null ? _assets.indexOf(selected) : 0;
    if (_currentIndex < 0) _currentIndex = 0;

    _pageController = PageController(
      viewportFraction: 0.4,
      initialPage: _currentIndex,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    UserProfileStore.I.selectedAsset = _assets[_currentIndex];
    await UserProfileStore.I.save();
    runApp(const PreEntryApp());
  }

  @override
  Widget build(BuildContext context) {
    final nick = UserProfileStore.I.nickname ?? '사용자';

    return Scaffold(
      backgroundColor: _bgBlue,
      body: SafeArea(
        child: Column(
          children: [
            // 중앙 정렬 영역
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ✅ 닉네임(주황) + 문구(베이지)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: nick,
                              style: const TextStyle(
                                color: Color(0xFFFFECDB),
                                fontFamily: 'nanum_eb',
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const TextSpan(
                              text: ' 님, 환영합니다\n',
                              style: TextStyle(
                                color: Color(0xFFFFECDB),
                                fontFamily: 'nanum_eb',
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            // const TextSpan(
                            //   text: '프로필을 선택하세요',
                            //   style: TextStyle(
                            //     color: Color(0xFFFFECDB),
                            //     fontFamily: 'nanum_eb',
                            //     fontSize: 22,
                            //     fontWeight: FontWeight.w700,
                            //   ),
                            // ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // 크게 미리보기
                    CircleAvatar(
                      radius: 52,
                      backgroundColor: const Color(0xFFE9EEF5),
                      backgroundImage: AssetImage(_assets[_currentIndex]),
                    ),
                    const SizedBox(height: 18),

                    // ✅ 캐러셀 (부드러운 확대)
                    SizedBox(
                      height: 150,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: _assets.length,
                        onPageChanged: (i) => setState(() => _currentIndex = i),
                        itemBuilder: (context, i) {
                          final selected = i == _currentIndex;
                          return Center(
                            child: AnimatedScale(
                              scale: selected ? 1.12 : 0.9,
                              duration: const Duration(milliseconds: 220),
                              curve: Curves.easeOut,
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: selected ? _orange : Colors.transparent,
                                    width: 3,
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 46,
                                  backgroundColor: Colors.transparent,
                                  backgroundImage: AssetImage(_assets[i]),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 하단 버튼
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 50),
              child: SizedBox(
                width: 250,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _orange,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontWeight: FontWeight.w700),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    shadowColor: Colors.black26,
                    elevation: 2,
                  ),
                  onPressed: _submit,
                  child: const Text(
                      '이 프로필로 시작하기',
                    style: TextStyle(
                      fontFamily: 'nanum_eb',
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}