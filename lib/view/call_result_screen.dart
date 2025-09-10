import 'package:flutter/material.dart';
import '../model/call_scenario.dart';
import '../model/voice_analysis.dart';

class CallResultScreen extends StatelessWidget {
  final ScenarioGroup group;
  final String title;
  final Duration duration;
  final List<Map<String, String>> messages;
  final VoiceAnalysis? analysis;

  const CallResultScreen({
    super.key,
    required this.group,
    required this.title,
    required this.duration,
    required this.messages,
    this.analysis,
  });

  @override
  Widget build(BuildContext context) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    final formattedTime =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '시뮬레이션 결과',
          style: TextStyle(fontFamily: 'nanum_eb'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${group.category} • $title',
                style: const TextStyle(
                  fontFamily: 'nanum_eb',
                  fontSize: 20,
                )),
            const SizedBox(height: 8),
            Text(
              '총 소요 시간: $formattedTime',
              style: const TextStyle(fontFamily: 'nanum_b', fontSize: 14),
            ),
            const Divider(height: 24),

            // 📊 음성 분석 결과
            if (analysis != null) ...[
              const Text('📊 음성 분석 결과',
                  style: TextStyle(fontSize: 18, fontFamily: 'nanum_eb')),
              const SizedBox(height: 12),

              _buildSummaryCard(context, analysis!),

              _buildCommentCard(
                context: context,
                icon: Icons.graphic_eq,
                title: "음 높이 (Pitch)",
                comment: analysis!.pitch.comment,
                value: analysis!.pitch.mean / 300,
                color: Colors.deepPurple,
              ),
              _buildCommentCard(
                context: context,
                icon: Icons.multiline_chart,
                title: "목소리 떨림 (Jitter)",
                comment: analysis!.jitter.comment,
                value: analysis!.jitter.value * 100,
                color: Colors.teal,
              ),
              _buildCommentCard(
                context: context,
                icon: Icons.blur_on,
                title: "목소리 강도 (Shimmer)",
                comment: analysis!.shimmer.comment,
                value: analysis!.shimmer.value * 100,
                color: Colors.orange,
              ),

              const Divider(height: 32),
            ],

            // 🧾 대화 내용
            const Text('🧾 대화 내용',
                style: TextStyle(fontSize: 18, fontFamily: 'nanum_eb')),
            const SizedBox(height: 8),

            Container(
              height: 320,
              padding: const EdgeInsets.all(8),
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];
                  final isUser = msg['role'] == 'user';
                  return Align(
                    alignment: isUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.blue[100] : Colors.grey[300],
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(12),
                          topRight: const Radius.circular(12),
                          bottomLeft: isUser
                              ? const Radius.circular(12)
                              : const Radius.circular(0),
                          bottomRight: isUser
                              ? const Radius.circular(0)
                              : const Radius.circular(12),
                        ),
                      ),
                      child: Text(
                        msg['text'] ?? '',
                        style: const TextStyle(fontFamily: 'nanum_b'),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // 버튼 (원래 색상)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.refresh),
                  label: const Text('다시 연습하기',
                      style: TextStyle(fontFamily: 'nanum_b')),
                ),
                ElevatedButton.icon(
                  onPressed: () =>
                      Navigator.popUntil(context, (route) => route.isFirst),
                  icon: const Icon(Icons.home),
                  label: const Text('홈으로',
                      style: TextStyle(fontFamily: 'nanum_b')),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  /// ✅ 종합 요약 멘트 (체크 아이콘 유지)
  Widget _buildSummaryCard(BuildContext context, VoiceAnalysis analysis) {
    List<String> comments = [];

    if (analysis.pitch.mean < 100) {
      comments.add("오늘은 목소리가 다소 낮아 소극적으로 들릴 수 있어요.");
    } else if (analysis.pitch.mean > 250) {
      comments.add("오늘은 목소리가 조금 높아 불안하게 느껴질 수 있어요.");
    }

    if (analysis.jitter.value > 0.01) {
      comments.add("조금 떨림이 감지되었어요.");
    }

    if (analysis.shimmer.value > 0.03) {
      comments.add("목소리 강도 변화가 커서 긴장한 것처럼 보일 수 있어요.");
    }

    if (comments.isEmpty) {
      comments.add("오늘 목소리에서는 특이사항이 발견되지 않았어요. 👍");
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: comments
              .map((c) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.check_circle,
                    size: 18, color: Colors.blueGrey),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    c,
                    style: const TextStyle(
                        fontSize: 15, fontFamily: 'nanum_b'),
                  ),
                )
              ],
            ),
          ))
              .toList(),
        ),
      ),
    );
  }

  /// 🎨 개별 분석 카드 (막대 게이지 + 코멘트 유지)
  Widget _buildCommentCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String comment,
    required double value,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'nanum_eb',
                          color: color)),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: value.clamp(0, 1),
                    color: color,
                    backgroundColor: color.withOpacity(0.2),
                    minHeight: 6,
                  ),
                  const SizedBox(height: 8),
                  Text(comment,
                      style: const TextStyle(
                          fontSize: 14, fontFamily: 'nanum_b')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}