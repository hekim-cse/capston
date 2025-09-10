// lib/view/stats_screen.dart
import 'package:flutter/material.dart';
import '../data/session_memory_store.dart';
import '../model/call_session_record.dart';
import '../utils/icon_util.dart';
import '../widgets/user_greeting_bar.dart';
import 'category_detail_screen.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final records = SessionMemoryStore.records
        .where((r) => r.analysis != null)
        .toList();

    // ✅ 카테고리별 최신 기록(가장 최근 1개) 맵으로 만들기
    final categories = records.fold<Map<String, CallSessionRecord>>({}, (map, r) {
      if (!map.containsKey(r.category) || r.date.isAfter(map[r.category]!.date)) {
        map[r.category] = r;
      }
      return map;
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        titleSpacing: 20,
        elevation: 0,
        toolbarHeight: 70, // AppBar 높이 키움
        title: const UserGreetingBar(),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: Colors.black.withOpacity(0.15)),
        ),
      ),
      backgroundColor: Colors.white,

      // ✅ 통계가 없으면 안내 문구
      body: records.isEmpty
          ? const Center(
        child: Text(
          '통계 결과가 없습니다.',
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'nanum_b',
            color: Colors.grey,
          ),
        ),
      )
          : ListView(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        children: categories.entries.map((entry) {
          final category = entry.key;
          final latest = entry.value;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              // 카드 본체
              Container(
                margin: const EdgeInsets.only(top: 24, bottom: 32),
                padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F1FB),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(2, 2),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 📊 텍스트 분석 요약
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              "${(latest.duration.inSeconds / latest.messages.length).toStringAsFixed(1)} 초",
                              style: const TextStyle(
                                fontFamily: 'nanum_eb',
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              "평균 응답 시간",
                              style: TextStyle(fontFamily: 'nanum_b'),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "${(latest.messages.map((m) => m.text.split(' ').length).reduce((a, b) => a + b) / latest.messages.length).toStringAsFixed(1)} 단어",
                              style: const TextStyle(
                                fontFamily: 'nanum_eb',
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              "평균 문장 길이",
                              style: TextStyle(fontFamily: 'nanum_b'),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // 🔊 음성 분석
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                          child: _voiceIndicator(
                            title: "Pitch",
                            comment: latest.analysis!.pitch.comment,
                            icon: Icons.graphic_eq,
                          ),
                        ),
                        Flexible(
                          child: _voiceIndicator(
                            title: "Jitter",
                            comment: latest.analysis!.jitter.comment,
                            icon: Icons.multiline_chart,
                          ),
                        ),
                        Flexible(
                          child: _voiceIndicator(
                            title: "Shimmer",
                            comment: latest.analysis!.shimmer.comment,
                            icon: Icons.blur_on,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 🔶 카테고리 헤더 (포지셔닝)
              Positioned(
                top: 0,
                left: 4,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CategoryDetailScreen(category: category),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF9149),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 4,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(getIconForTarget(category), color: Colors.white, size: 20),
                        const SizedBox(width: 6),
                        Text(
                          category,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'nanum_eb',
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.chevron_right, color: Colors.white, size: 18),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _voiceIndicator({
    required String title,
    required String comment,
    required IconData icon,
  }) {
    return Column(
      children: [
        Icon(icon, size: 28, color: Colors.orange),
        const SizedBox(height: 6),
        Text(
          title,
          style: const TextStyle(fontFamily: 'nanum_b'),
        ),
        Text(
          comment,
          style: const TextStyle(
            fontSize: 11,
            fontFamily: 'nanum_b',
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}