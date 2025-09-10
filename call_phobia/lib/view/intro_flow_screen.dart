import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import '../view/profile_pick_screen.dart';
import '../data/user_profile_store.dart';

enum _IntroStep { logo, slogan, login }

class IntroFlowScreen extends StatefulWidget {
  const IntroFlowScreen({super.key});

  @override
  State<IntroFlowScreen> createState() => _IntroFlowScreenState();
}

class _IntroFlowScreenState extends State<IntroFlowScreen>
    with SingleTickerProviderStateMixin {
  _IntroStep step = _IntroStep.logo;

  late final AnimationController _ctrl;
  late final Animation<Offset> _logoSlide; // 로고 위로 슬라이드
  late final Animation<double> _textFade;  // 텍스트 페이드 인

  bool isLoggingIn = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _logoSlide = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -0.20),
    ).animate(CurvedAnimation(
      parent: _ctrl,
      curve: Curves.easeOutCubic,
    ));

    _textFade = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
    );

    _runIntro();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _runIntro() async {
    await Future.delayed(const Duration(milliseconds: 16));
    await Future.delayed(const Duration(milliseconds: 2000)); // 로고만
    if (!mounted) return;

    setState(() => step = _IntroStep.slogan);
    _ctrl.forward();
    await Future.delayed(const Duration(milliseconds: 2000)); // 슬로건
    if (!mounted) return;

    setState(() => step = _IntroStep.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF60B5FF),
      body: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: _buildByStep(step),
        ),
      ),
    );
  }

  Widget _buildByStep(_IntroStep s) {
    switch (s) {
      case _IntroStep.logo:
        return const _Logo(key: ValueKey('logo'), size: 110);

      case _IntroStep.slogan:
        return LayoutBuilder(
          key: const ValueKey('slogan'),
          builder: (context, constraints) {
            return SizedBox(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SlideTransition(
                    position: _logoSlide,
                    child: const _Logo(size: 110),
                  ),
                  const SizedBox(height: 30),
                  FadeTransition(
                    opacity: _textFade,
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '목소리를 꺼내는 용기,',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 29,
                            fontFamily: 'nanum_eb',
                            color: Color(0xFFFFECDB),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '마음콜과 함께',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontFamily: 'nanum_eb',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );

      case _IntroStep.login:
        return _buildLogin();
    }
  }

  Widget _buildLogin() {
    return Column(
      key: const ValueKey('login'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          '로그인을 통하여\n같이 용기를 키워봐요',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 25,
            fontFamily: 'nanum_eb',
            color: Color(0xFFFFECDB),
          ),
        ),
        const SizedBox(height: 70),
        if (isLoggingIn)
          const CircularProgressIndicator(color: Colors.white)
        else
          GestureDetector(
            onTap: _handleLogin,
            child: Image.asset(
              'assets/img/kakao_login_large_wide.png',
              width: 240,
            ),
          ),
        if (errorMessage != null) ...[
          const SizedBox(height: 14),
          Text(errorMessage!, style: const TextStyle(color: Colors.red)),
        ],
      ],
    );
  }

  // ✅ 이 함수는 '클래스 내부'에만 존재해야 합니다 (중복 정의 금지)
  Future<void> _handleLogin() async {
    setState(() {
      isLoggingIn = true;
      errorMessage = null;
    });

    try {
      if (await isKakaoTalkInstalled()) {
        await UserApi.instance.loginWithKakaoTalk();
      } else {
        await UserApi.instance.loginWithKakaoAccount();
      }
      final user = await UserApi.instance.me();

      // ✅ 카카오 닉네임만 저장
      final nickname = user.kakaoAccount?.profile?.nickname ?? '사용자';
      UserProfileStore.I.nickname = nickname;
      await UserProfileStore.I.save();

      if (!mounted) return;
      // ✅ 프로필 이미지 선택 화면으로
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const ProfilePickScreen(fromProfile: false)),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = '로그인에 실패했습니다. 다시 시도해주세요.';
        isLoggingIn = false;
      });
    }
  }
}

class _Logo extends StatelessWidget {
  final double size;
  const _Logo({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Image.asset(
        'assets/img/logo.png',
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
        alignment: Alignment.center,
      ),
    );
  }
}