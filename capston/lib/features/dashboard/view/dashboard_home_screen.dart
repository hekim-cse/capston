// lib/features/dashboard/view/dashboard_home_screen.dart
import 'package:flutter/material.dart';
import '../viewmodel/dashboard_vm.dart';

class DashboardHomeScreen extends StatefulWidget {
  final DashboardVM engVm;
  final DashboardVM mmVm;
  final VoidCallback onOpenEng;
  final VoidCallback onOpenMm;

  const DashboardHomeScreen({
    super.key,
    required this.engVm,
    required this.mmVm,
    required this.onOpenEng,
    required this.onOpenMm,
  });

  @override
  State<DashboardHomeScreen> createState() => _DashboardHomeScreenState();
}

class _DashboardHomeScreenState extends State<DashboardHomeScreen> {
  @override
  void initState() {
    super.initState();
    widget.engVm.addListener(_refresh);
    widget.mmVm.addListener(_refresh);
    widget.engVm.init();
    widget.mmVm.init();
  }

  @override
  void dispose() {
    widget.engVm.removeListener(_refresh);
    widget.mmVm.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final eng = widget.engVm.latest;
    final mm  = widget.mmVm.latest;

    String fPct(double? v) => v == null ? '--' : '${v.toStringAsFixed(1)} %';
    String fC(double? v)   => v == null ? '--' : '${v.toStringAsFixed(1)} ℃';

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200), // 화면 꽉 채우지 않음
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
            children: [
              const Text('Dashboard', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
              const SizedBox(height: 18),

              // 상단 KPI
              Row(
                children: [
                  Expanded(child: _kpiTile('평균 습도', fPct(_avg([eng?.rh, mm?.rh])))),
                  const SizedBox(width: 16),
                  Expanded(child: _kpiTile('평균 온도', fC(_avg([eng?.temp, mm?.temp])))),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _kpiTile('3시간 내 위험 확률',
                      _pctAny(widget.engVm.r3hPercent, widget.mmVm.r3hPercent))),
                  const SizedBox(width: 16),
                  Expanded(child: _kpiTile('다음 위험까지',
                      _etaAny(widget.engVm.etaNextRiskHours, widget.mmVm.etaNextRiskHours))),
                ],
              ),
              const SizedBox(height: 18),

              // 건물 카드 2개
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildingCard(
                    title: '공학관',
                    mapPath: 'assets/images/map.png',
                    hum: eng?.rh, temp: eng?.temp,
                    onGo: widget.onOpenEng,
                    logs: widget.engVm.opsLogs,
                  )),
                  const SizedBox(width: 16),
                  Expanded(child: _buildingCard(
                    title: '멀티미디어관',
                    mapPath: 'assets/images/mul.png',
                    hum: mm?.rh, temp: mm?.temp,
                    onGo: widget.onOpenMm,
                    logs: widget.mmVm.opsLogs,
                  )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ───────────────── helpers ─────────────────
  Widget _kpiTile(String title, String value) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 14, offset: Offset(0, 6))],
    ),
    child: Row(
      children: [
        const Icon(Icons.water_drop_outlined, size: 18, color: Color(0xFF64748B)),
        const SizedBox(width: 8),
        Expanded(child: Text(title, style: const TextStyle(color: Color(0xFF64748B)))),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
      ],
    ),
  );

  Widget _buildingCard({
    required String title,
    required String mapPath,
    required double? hum,
    required double? temp,
    required VoidCallback onGo,
    required List<OpsLog> logs,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 18, offset: Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상단: 타이틀(좌) - 바로가기(우)
          Row(
            children: [
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: onGo,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF22A06B),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                  elevation: 0,
                ),
                icon: const Icon(Icons.open_in_new, size: 16, color: Colors.white),
                label: const Text('바로 가기', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 본문: 좌측 지도 / 우측 지표(세로 중앙정렬)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 지도
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(mapPath, height: 180, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 16),
              // 지표
              Expanded(
                flex: 2,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 220),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _metricRow('습도', hum, '%'),
                        const SizedBox(height: 10),
                        _metricRow('온도', temp, '℃'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // 최근 로그
          const Text('점검 로그', style: TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          _logsPanel(logs),
        ],
      ),
    );
  }

  Widget _metricRow(String label, double? v, String unit) {
    final value = v == null ? '--' : v.toStringAsFixed(1);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF64748B))),
          const Spacer(),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
          const SizedBox(width: 4),
          Text(unit, style: const TextStyle(color: Color(0xFF64748B))),
        ],
      ),
    );
  }

  Widget _logsPanel(List<OpsLog> logs) {
    if (logs.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: const Text('최근 점검 로그가 없습니다.',
            style: TextStyle(color: Color(0xFF64748B))),
      );
    }
    final show = logs.take(5).toList();
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: show.length,
        separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFE5E7EB)),
        itemBuilder: (_, i) {
          final e = show[i];
          return ListTile(
            dense: true,
            leading: Icon(
              e.success ? Icons.check_circle : Icons.remove_circle,
              size: 18,
              color: e.success ? const Color(0xFF10B981) : const Color(0xFF9CA3AF),
            ),
            title: Text(e.memo, maxLines: 1, overflow: TextOverflow.ellipsis),
            trailing: Text(e.timeHM, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
          );
        },
      ),
    );
  }

  double? _avg(List<double?> xs) {
    final v = xs.whereType<double>().toList();
    if (v.isEmpty) return null;
    return v.reduce((a, b) => a + b) / v.length;
  }

  String _pctAny(double? a, double? b) => (a ?? b) == null ? '—%' : '${(a ?? b)!.toStringAsFixed(1)} %';
  String _etaAny(double? a, double? b) => (a ?? b) == null ? '— h' : '${(a ?? b)!.toStringAsFixed(1)} h';
}