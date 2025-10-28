import 'package:flutter/material.dart';
import '../viewmodel/dashboard_vm.dart';
import '../widgets/metric_strip.dart';
import '../widgets/soft_page_physics.dart';
import '../widgets/top_nav.dart';

class EngDashboardScreen extends StatefulWidget {
  final DashboardVM vm;
  const EngDashboardScreen({super.key, required this.vm});

  @override
  State<EngDashboardScreen> createState() => _EngDashboardScreenState();
}

class _EngDashboardScreenState extends State<EngDashboardScreen>
    with AutomaticKeepAliveClientMixin {
  final _page = PageController();
  int _selectedTab = 0;
  bool _opsOpen = false;

  static const _mapByTab = <int, String>{
    0: 'assets/images/map.png',
    1: 'assets/images/map1.png',
    2: 'assets/images/map2.png',
  };

  static const List<_OpsItem> _opsItems = [
    _OpsItem('창문 환기 10분 이상', Icons.air),
    _OpsItem('제습기 15분 가동', Icons.ac_unit),
    _OpsItem('결로/곰팡이 흔적 점검', Icons.clean_hands),
    _OpsItem('공기청정기 표준모드 15분', Icons.filter_alt),
    _OpsItem('누수/덕트 이상 여부 확인', Icons.build),
  ];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    widget.vm.addListener(_onVm);
    widget.vm.init();
  }

  void _onVm() => setState(() {});
  @override
  void dispose() {
    widget.vm.removeListener(_onVm);
    _page.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    const double kCardsHeight = 420;
    final vm = widget.vm;

    // 텍스트 스케일 고정
    final fixed = MediaQuery.of(context).copyWith(
      textScaler: const TextScaler.linear(1.0),
    );

    final pages = PageView(
      controller: _page,
      scrollDirection: Axis.vertical,
      physics: const SoftPagePhysics(parent: ClampingScrollPhysics()),
      allowImplicitScrolling: true,
      children: [
        // ── 페이지 1: 지표 + 지도/가이드
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: MediaQuery(
              data: fixed,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _card(
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 900),
                          child: vm.latest != null
                              ? MetricStrip(m: vm.latest!)
                              : const _MetricPlaceholder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _card(
                            height: kCardsHeight,
                            child: Column(
                              children: [
                                _tabBar(),
                                const SizedBox(height: 12),
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: const Color(0xFFE7E8EA)),
                                        color: Colors.white,
                                      ),
                                      child: _buildMapImage(_mapByTab[_selectedTab]),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: _card(
                            height: kCardsHeight,
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                              child: _guideBodyCentered(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // ── 페이지 2: 인사이트(검정 톤)
        Container(
          color: const Color(0xFF0F1112),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: MediaQuery(
                data: fixed,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: SizedBox(
                            height: kCardsHeight,
                            child: Image.asset('assets/images/img2.jpeg', fit: BoxFit.cover),
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: _card(
                          color: const Color(0xFF1A1C1E),
                          height: kCardsHeight,
                          child: _insightBody(vm),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );

    final opsPanel = _FloatingOpsPanel(
      open: _opsOpen,
      latestHum: vm.latest?.rh,
      latestTemp: vm.latest?.temp,
      items: _opsItems,
      checked: widget.vm.opsChecklist,
      logs: widget.vm.opsLogs,
      onToggleOpen: () => setState(() => _opsOpen = !_opsOpen),
      onCheckChanged: (i, v) {
        final cur = List<bool>.from(widget.vm.opsChecklist);
        if (i < cur.length) cur[i] = v;
        widget.vm.saveOpsChecklist(cur);
        widget.vm.addOpsLog(
          v ? '완료' : '해제',
          memo: v ? _opsItems[i].label : '${_opsItems[i].label} (해제)',
          success: v,
        );
      },
    );

    return Scaffold(
      appBar: const TopNav(),
      body: Stack(
        children: [
          pages,
          Positioned(right: 16, top: 24, bottom: 24, child: opsPanel),
        ],
      ),
    );
  }

  // ── helpers ────────────────────────────────

  Widget _tabBar() => Container(
    decoration: BoxDecoration(
      color: const Color(0xFFF6F7F8),
      borderRadius: BorderRadius.circular(10),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _HoverTab('통합', 0, _selectedTab, (i) => setState(() => _selectedTab = i)),
        _HoverTab('습도', 1, _selectedTab, (i) => setState(() => _selectedTab = i)),
        _HoverTab('온도', 2, _selectedTab, (i) => setState(() => _selectedTab = i)),
      ],
    ),
  );

  Widget _guideBodyCentered() => Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 520),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 2),
          Text('실내 환경 점검이 필요해요.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                height: 1.35,
                color: Colors.black,
                decoration: TextDecoration.none,
              )),
          SizedBox(height: 10),
          Text('💨 창문을 열고 10분 이상 환기하세요.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, height: 1.45, color: Colors.black87)),
          Text('🌀 제습기를 약 15분 가동해 습도를 낮춰요.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, height: 1.45, color: Colors.black87)),
          Text('🧽 결로나 곰팡이 흔적을 점검해 주세요.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, height: 1.45, color: Colors.black87)),
          Text('🌿 공기청정기 표준 모드 15분 권장.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, height: 1.45, color: Colors.black87)),
          Text('🔧 누수·환기 덕트 등 이상 여부 확인.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, height: 1.45, color: Colors.black87)),
          SizedBox(height: 2),
        ],
      ),
    ),
  );

  Widget _buildMapImage(String? path) => path == null
      ? const Center(child: Text('이미지 경로가 없습니다', style: TextStyle(color: Colors.grey)))
      : Image.asset(path, fit: BoxFit.cover);

  Widget _card({required Widget child, double? height, Color color = Colors.white}) =>
      Container(
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(color: Color(0x14000000), blurRadius: 18, offset: Offset(0, 8))
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: child,
      );
}

// ── 내부 위젯 ─────────────────────────────

class _HoverTab extends StatefulWidget {
  final String label;
  final int index;
  final int selectedIndex;
  final void Function(int) onTap;
  const _HoverTab(this.label, this.index, this.selectedIndex, this.onTap, {super.key});
  @override
  State<_HoverTab> createState() => _HoverTabState();
}

class _HoverTabState extends State<_HoverTab> {
  bool _hover = false;
  @override
  Widget build(BuildContext context) {
    final selected = widget.selectedIndex == widget.index;
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: () => widget.onTap(widget.index),
        child: AnimatedScale(
          scale: _hover ? 1.04 : 1.0,
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOut,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Text(
              widget.label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
                color: selected ? Colors.black : Colors.grey[600],
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _OpsItem {
  final String label;
  final IconData icon;
  const _OpsItem(this.label, this.icon);
}

/// MM과 동일: Stateful 패널(로컬 반영 + VM 저장)
class _FloatingOpsPanel extends StatefulWidget {
  final bool open;
  final double? latestHum, latestTemp;
  final List<_OpsItem> items;
  final List<bool> checked;
  final List<OpsLog> logs;
  final VoidCallback onToggleOpen;
  final void Function(int, bool) onCheckChanged;

  const _FloatingOpsPanel({
    required this.open,
    required this.latestHum,
    required this.latestTemp,
    required this.items,
    required this.checked,
    required this.logs,
    required this.onToggleOpen,
    required this.onCheckChanged,
  });

  @override
  State<_FloatingOpsPanel> createState() => _FloatingOpsPanelState();
}

class _FloatingOpsPanelState extends State<_FloatingOpsPanel> {
  late List<bool> _localChecked;

  @override
  void initState() {
    super.initState();
    _localChecked = List<bool>.from(widget.checked);
  }

  @override
  void didUpdateWidget(covariant _FloatingOpsPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.checked != widget.checked) {
      _localChecked = List<bool>.from(widget.checked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = widget.open ? 360.0 : 64.0;
    final fixed = MediaQuery.of(context).copyWith(
      textScaler: const TextScaler.linear(1.0),
    );

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      width: w,
      constraints: const BoxConstraints(minHeight: 360, maxWidth: 420),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Color(0x1A000000), blurRadius: 18, offset: Offset(0, 8))],
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: MediaQuery(
          data: fixed,
          child: Material(
            color: Colors.white,
            child: widget.open ? _expanded() : _collapsed(),
          ),
        ),
      ),
    );
  }

  Widget _expanded() => Column(
    children: [
      // 헤더
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        color: const Color(0xFFF6F7F8),
        child: Row(
          children: [
            const Text('🧭 운영 대시보드',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.black)),
            const Spacer(),
            IconButton(onPressed: widget.onToggleOpen, icon: const Icon(Icons.chevron_right)),
          ],
        ),
      ),
      // KPI
      Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
        child: Row(
          children: [
            Expanded(child: _miniKpi(title: '현재 습도', value: widget.latestHum, unit: '%')),
            const SizedBox(width: 8),
            Expanded(child: _miniKpi(title: '현재 온도', value: widget.latestTemp, unit: '℃')),
          ],
        ),
      ),
      const SizedBox(height: 8),
      // 체크리스트
      Expanded(
        flex: 10,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: ListView.separated(
            itemCount: widget.items.length,
            separatorBuilder: (_, __) => const Divider(height: 8),
            itemBuilder: (_, i) {
              final it = widget.items[i];
              final val = (i < _localChecked.length) ? _localChecked[i] : false;
              return CheckboxListTile(
                dense: true,
                controlAffinity: ListTileControlAffinity.leading,
                value: val,
                onChanged: (v) {
                  setState(() {
                    if (i >= _localChecked.length) _localChecked.length = i + 1;
                    _localChecked[i] = v ?? false;
                  });
                  widget.onCheckChanged(i, v ?? false);
                },
                title: Row(
                  children: [
                    Icon(it.icon, size: 18, color: const Color(0xFF111827)),
                    const SizedBox(width: 8),
                    Expanded(child: Text(it.label)),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      // 로그
      Expanded(
        flex: 9,
        child: Container(
          margin: const EdgeInsets.fromLTRB(8, 4, 8, 12),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: widget.logs.isEmpty
              ? const Center(child: Text('아직 기록 없음', style: TextStyle(color: Color(0xFF6B7280))))
              : ListView.separated(
            itemCount: widget.logs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, i) {
              final e = widget.logs[i];
              return Row(
                children: [
                  Icon(e.success ? Icons.check_circle : Icons.remove_circle,
                      size: 16,
                      color: e.success ? const Color(0xFF10B981) : const Color(0xFF9CA3AF)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(e.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 2),
                        Text(e.memo, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(e.timeHM, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
                ],
              );
            },
          ),
        ),
      ),
    ],
  );

  Widget _collapsed() => GestureDetector(
    onTap: widget.onToggleOpen,
    child: const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RotatedBox(quarterTurns: 2, child: Icon(Icons.chevron_left)),
        SizedBox(height: 8),
        Icon(Icons.rule, size: 20),
        SizedBox(height: 8),
        Icon(Icons.timeline, size: 20),
      ],
    ),
  );
}

Widget _miniKpi({required String title, double? value, required String unit}) => Container(
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: const [
      BoxShadow(color: Color(0x14000000), blurRadius: 16, offset: Offset(0, 8)),
    ],
    border: Border.all(color: Color(0xFFE5E7EB)),
  ),
  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  child: Row(
    children: [
      Expanded(child: Text(title, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12))),
      Text(
        value != null ? value.toStringAsFixed(1) : '--',
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.black),
      ),
      const SizedBox(width: 4),
      Text(unit, style: const TextStyle(color: Color(0xFF6B7280))),
    ],
  ),
);

// 자리 표시자
class _MetricPlaceholder extends StatelessWidget {
  const _MetricPlaceholder();
  @override
  Widget build(BuildContext context) {
    TextStyle v(double f) =>
        TextStyle(fontSize: f, fontWeight: FontWeight.w800, color: Colors.grey[500]);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('습도 RH', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          const SizedBox(height: 6),
          Text('--  %', style: v(24)),
          const SizedBox(height: 16),
          Text('온도', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          const SizedBox(height: 6),
          Text('--  ℃', style: v(24)),
        ],
      ),
    );
  }
}

// ── 인사이트 본문(공통) ─────────────────────────
Widget _insightBody(DashboardVM vm) {
  final r = vm.r3hPercent;
  final eta = vm.etaNextRiskHours;
  final n24 = vm.expectedRiskTimeNext24hHours;

  TextStyle s(double sz, [FontWeight w = FontWeight.w600]) =>
      TextStyle(fontSize: sz, fontWeight: w, color: Colors.white, height: 1.6);

  if (r == null && eta == null && n24 == null) {
    return const Center(
      child: Text('인사이트 데이터가 없어요.', style: TextStyle(color: Colors.white70)),
    );
  }

  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (r != null) Text('📊 3시간 내 위험 확률: ${r.toStringAsFixed(1)}%', style: s(18)),
        if (eta != null) ...[
          const SizedBox(height: 8),
          Text('🕒 다음 위험까지: ${eta.toStringAsFixed(1)}시간', style: s(18)),
        ],
        if (n24 != null) ...[
          const SizedBox(height: 8),
          Text('🌙 내일 예상 위험 시간: ${n24.toStringAsFixed(1)}시간', style: s(18)),
        ],
      ],
    ),
  );
}