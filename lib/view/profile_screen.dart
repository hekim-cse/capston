// 📁 lib/view/profile_screen.dart
import 'package:flutter/material.dart';
import '../data/user_profile_store.dart';
import 'profile_pick_screen.dart';
import '../data/selected_target_store.dart';
import '../model/available_scenarios.dart';
import '../utils/icon_util.dart';

class ProfileScreen extends StatelessWidget {
  final List<String> selectedTargets;

  const ProfileScreen({super.key, required this.selectedTargets});

  static const _sky   = Color(0xFFE6F1FB);
  static const _line  = Color(0xFFB7D5F3);
  static const _blue  = Color(0xFF60B5FF);
  static const _titleBlue = Color(0xFF4BA2F0);
  static const _orange = Color(0xFFFF9149);

  @override
  Widget build(BuildContext context) {
    final nick = UserProfileStore.I.nickname ?? '사용자';
    final asset = UserProfileStore.I.selectedAsset ?? 'assets/profile/p1.png';

    return Scaffold(
      backgroundColor: Colors.white,

      // 기존처럼 전체 블록을 약간 아래로 내리고 싶으면 margin 유지
      body: Container(
        margin: const EdgeInsets.only(top: 120, right: 1),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ================== 프로필 카드만 가로 중앙 정렬 ==================
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 380),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          padding: const EdgeInsets.fromLTRB(60, 28, 60, 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: _line, width: 2),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                offset: Offset(2, 3),
                              )
                            ],
                          ),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 46,
                                backgroundColor: _sky,
                                backgroundImage: AssetImage(asset),
                              ),
                              const SizedBox(height: 18),
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: nick,
                                      style: const TextStyle(
                                        fontSize: 23,
                                        fontFamily: 'nanum_eb',
                                        color: _orange,
                                      ),
                                    ),
                                    const TextSpan(
                                      text: ' 님 반갑습니다.',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontFamily: 'nanum_eb',
                                        color: _titleBlue,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // ‘프로필 수정’ 배지
                        Positioned(
                          top: -10,
                          left: 12,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const ProfilePickScreen(),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: _sky,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: _line, width: 1.5),
                              ),
                              child: const Text(
                                '프로필 수정',
                                style: TextStyle(
                                  fontFamily: 'nanum_b',
                                  color: _blue,
                                  fontSize: 12.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // ===========================================================

              const SizedBox(height: 24),

              // ===== 내가 선택한 대화 상황 (이하는 그대로 유지) =====
              // 📦 프로필 화면의 '내가 선택한 대화 상황' 부분 교체
              const Text('🙋‍♀️ 내가 선택한 대화 상황',
                  style: TextStyle(fontSize: 18, fontFamily: 'nanum_eb')),
              const SizedBox(height: 14),

              ValueListenableBuilder<List<String>>(
                valueListenable: SelectedTargetStore.notifier,
                builder: (context, selected, _) {
                  if (selected.isEmpty) {
                    return const Text('선택된 상황이 없습니다.',
                        style: TextStyle(fontSize: 16, color: Colors.grey, fontFamily: 'nanum_b'));
                  }
                  return Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: selected.map((t) => Chip(
                      label: Text(t, style: const TextStyle(fontFamily: 'nanum_b')),
                      backgroundColor: _sky,
                      side: const BorderSide(color: _line),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    )).toList(),
                  );
                },
              ),

              const SizedBox(height: 24),
              // ===== 설정 타일 (AI/전화 제거하고 ‘상황 재설정’만) =====
              _ScenarioResetTile(
                onSaved: () {
                  // 저장 이후 화면에 알림만 주고 끝 (필요하면 setState 있는 부모라면 새로고침 로직 추가)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('상황이 업데이트되었습니다')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _SettingTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  static const _tileBg = Color(0xFFE6F1FB);
  static const _tileText = Color(0xFF27667B);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: _tileBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: _tileText, size: 26),
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'nanum_eb',
            fontSize: 16,
            color: _tileText,
          ),
        ),
        trailing: const Icon(Icons.expand_more_rounded, color: _tileText),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}

class _ScenarioResetTile extends StatefulWidget {
  final VoidCallback? onSaved;
  const _ScenarioResetTile({this.onSaved});

  @override
  State<_ScenarioResetTile> createState() => _ScenarioResetTileState();
}

class _ScenarioResetTileState extends State<_ScenarioResetTile> {
  // 색상
  static const _tileBg   = Color(0xFFE6F1FB);
  static const _tileText = Color(0xFF27667B);
  static const _orange   = Color(0xFFFF9149);
  static const _beige    = Color(0xFFFFF1E6); // 부드러운 베이지

  bool _expanded = true;

  late final List<String> _allCategories;     // 전체 카테고리
  late Set<String> _working;                  // 현재 편집 중 선택값
  late Set<String> _original;                 // 원본(비교용)

  @override
  void initState() {
    super.initState();
    // availableScenarioGroups에서 카테고리 추출
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

          // 컨텐츠
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
                  // 카테고리 버튼들 (3열 그리드 느낌의 Wrap)
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

                  // 하단 액션
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
    // 저장
    SelectedTargetStore.setTargets(_working.toList());
    // 원본 갱신
    setState(() => _original = Set<String>.from(_working));
    // 알림/콜백
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

// 한 개의 둥근 알약 버튼
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