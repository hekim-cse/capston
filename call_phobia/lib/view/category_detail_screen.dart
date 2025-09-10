// lib/view/category_detail_screen.dart
import 'package:flutter/material.dart';
import '../data/session_memory_store.dart';
import '../model/call_session_record.dart';
import 'call_result_screen.dart';
import '../model/call_scenario.dart'; // ScenarioGroup 정의된 곳
import '../model/available_scenarios.dart'; // availableScenarioGroups 리스트

class CategoryDetailScreen extends StatefulWidget {
  final String category;
  const CategoryDetailScreen({super.key, required this.category});

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  final Map<int, bool> expanded = {}; // 세션별 펼침 상태

  @override
  Widget build(BuildContext context) {
    final records = SessionMemoryStore.records
        .where((r) => r.category == widget.category && r.analysis != null)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    return Scaffold(
      appBar: AppBar(title: Text(widget.category)),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: records.length,
        itemBuilder: (context, index) {
          final r = records[index];
          final isExpanded = expanded[index] ?? false;

          // ✅ category에 맞는 ScenarioGroup 찾기
          final group = availableScenarioGroups.firstWhere(
                (g) => g.category == r.category,
            orElse: () => ScenarioGroup(
              category: r.category,
              nickname: r.category,
              scenarios: [],
            ),
          );

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                ListTile(
                  title: Text(r.title,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("${r.duration.inSeconds}초"),
                  trailing: IconButton(
                    icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
                    onPressed: () {
                      setState(() {
                        expanded[index] = !isExpanded;
                      });
                    },
                  ),
                ),

                if (isExpanded)
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("📊 ${r.analysis!.pitch.comment}"),
                        Text("🔹 ${r.analysis!.jitter.comment}"),
                        Text("🔸 ${r.analysis!.shimmer.comment}"),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CallResultScreen(
                                  group: group, // ✅ null 대신 group 전달
                                  title: r.title,
                                  duration: r.duration,
                                  messages: r.messages.map((m) => {
                                    'role': m.sender.name,
                                    'text': m.text,
                                  }).toList(),
                                  analysis: r.analysis,
                                ),
                              ),
                            );
                          },
                          child: const Text("자세히 보기"),
                        )
                      ],
                    ),
                  )
              ],
            ),
          );
        },
      ),
    );
  }
}