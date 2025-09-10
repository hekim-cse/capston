import 'package:flutter/material.dart';
import 'package:your_app_name/utils/icon_util.dart';
import 'package:your_app_name/view/scenario_select_screen.dart';
import '../data/selected_target_store.dart';
import '../data/user_profile_store.dart';
import '../model/available_scenarios.dart';
import '../utils/icon_util.dart';
import 'main_tab_scaffold.dart';

class ProfilePickScreen extends StatefulWidget {
  /// 프로필 탭에서 수정하러 들어온 경우: true(기본) → 저장 후 pop
  /// 온보딩 플로우에서 처음 진입한 경우: false → 여기서 다음 화면으로 네비게이션(원하면 추가)
  final bool fromProfile;

  const ProfilePickScreen({super.key, this.fromProfile = true});

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

    if (widget.fromProfile) {
      // ✅ 프로필 탭에서 온 경우: 저장만 하고 돌아가기
      if (mounted) Navigator.pop(context, true);
    } else {
      // ✅ 온보딩에서 온 경우: 프로필 저장 후 '상황 선택' 화면으로 이동
      if (!mounted) return;

      // 핵심: 현재 NavigatorState를 미리 캡처해 두고, 이후 콜백에서 이것을 사용
      // (ProfilePickScreen은 pushReplacement로 대체되기 때문에 자신의 context는 unmounted가 됨)
      final nav = Navigator.of(context);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ScenarioSelectScreen(
            onTargetsConfirmed: (targets) {
              // 선택 저장
              SelectedTargetStore.setTargets(targets);

              // ✅ 캡처한 NavigatorState(nav)를 사용해서 메인으로 이동 (context 언마운트 에러 방지)
              nav.pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const MainTabScreen()),
                (route) => false,
              );
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final nick = UserProfileStore.I.nickname ?? '사용자';

    return Scaffold(
      backgroundColor: _bgBlue,
      body: SafeArea(
        child: Column(
          children: [
            // 중앙
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 10),
                    CircleAvatar(
                      radius: 52,
                      backgroundColor: const Color(0xFFE9EEF5),
                      backgroundImage: AssetImage(_assets[_currentIndex]),
                    ),
                    const SizedBox(height: 18),
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

// ------------------------------
// Scenario reset tile (inline)
// ------------------------------
class ScenarioResetTile extends StatefulWidget {
  final VoidCallback? onSaved;
  const ScenarioResetTile({super.key, this.onSaved});

  @override
  State<ScenarioResetTile> createState() => _ScenarioResetTileState();
}

class _ScenarioResetTileState extends State<ScenarioResetTile> {
  // 색상
  static const _tileBg   = Color(0xFFE6F1FB);
  static const _tileText = Color(0xFF27667B);
  static const _orange   = Color(0xFFFF9149);
  static const _beige    = Color(0xFFFFF1E6);

  bool _expanded = true;

  late final List<String> _allCategories; // 전체 카테고리
  late Set<String> _working;              // 현재 편집 중 선택값
  late Set<String> _original;             // 원본(비교용)

  @override
  void initState() {
    super.initState();
    _allCategories = availableScenarioGroups.map((g) => g.category).toList();
    _original = Set<String>.from(SelectedTargetStore.targets);
    _working  = Set<String>.from(_original);
  }

  bool get _hasChanges => !_setEquals(_original, _working);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: _tileBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          // 헤더
          ListTile(
            onTap: () => setState(() => _expanded = !_expanded),
            leading: const Icon(Icons.settings_suggest_rounded, color: _tileText, size: 26),
            title: const Text(
              '상황 재설정',
              style: TextStyle(fontFamily: 'nanum_eb', fontSize: 18, color: _tileText),
            ),
            trailing: Icon(
              _expanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
              color: _tileText,
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),

          if (_expanded)
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(14)),
              ),
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 카테고리 선택
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _allCategories.map((c) {
                      final selected = _working.contains(c);
                      return _ScenarioPill(
                        label: c,
                        icon: getIconForTarget(c),
                        selected: selected,
                        onTap: () {
                          setState(() {
                            if (selected) {
                              _working.remove(c);
                            } else {
                              _working.add(c);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 16),

                  // 액션 버튼
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _hasChanges ? _resetToOriginal : null,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: _tileText),
                          ),
                          child: const Text('취소', style: TextStyle(color: _tileText)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _hasChanges ? _save : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _orange,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('수정 완료'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _resetToOriginal() {
    setState(() {
      _working = Set<String>.from(_original);
    });
  }

  Future<void> _save() async {
    SelectedTargetStore.setTargets(_working.toList());
    setState(() => _original = Set<String>.from(_working));
    widget.onSaved?.call();
  }

  bool _setEquals(Set<String> a, Set<String> b) {
    if (a.length != b.length) return false;
    for (final e in a) {
      if (!b.contains(e)) return false;
    }
    return true;
  }
}

class _ScenarioPill extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _ScenarioPill({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  static const _orange = Color(0xFFFF9149);
  static const _beige  = Color(0xFFFFF1E6);
  static const _text   = Color(0xFF1F2D3A);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? _orange : _beige,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: selected ? Colors.white : _text),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'nanum_eb',
                  fontSize: 15,
                  color: selected ? Colors.white : _text,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}