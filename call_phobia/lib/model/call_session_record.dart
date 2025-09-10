// 📁 lib/model/call_session_record.dart
import 'scenario_message.dart';
import 'voice_analysis.dart';  // 🔥 음성 분석 결과 모델 import

class CallSessionRecord {
  final String category;
  final String title;
  final Duration duration;
  final List<ScenarioMessage> messages;
  final DateTime date; // 🔥 저장 시각
  final VoiceAnalysis? analysis; // 🔥 음성 분석 결과

  CallSessionRecord({
    required this.category,
    required this.title,
    required this.duration,
    required this.messages,
    required this.date,
    this.analysis,
  });

  Map<String, dynamic> toJson() => {
    'category': category,
    'title': title,
    'duration': duration.inMilliseconds,
    'messages': messages.map((m) => m.toJson()).toList(),
    'date': date.toIso8601String(), // 🔥 날짜 저장
    'analysis': analysis?.toJson(), // 🔥 분석 결과 저장
  };

  factory CallSessionRecord.fromJson(Map<String, dynamic> json) {
    return CallSessionRecord(
      category: json['category'],
      title: json['title'],
      duration: Duration(milliseconds: json['duration']),
      messages: (json['messages'] as List)
          .map((e) => ScenarioMessage.fromJson(e))
          .toList(),
      date: DateTime.parse(json['date']), // 🔥 날짜 복원
      analysis: json['analysis'] != null
          ? VoiceAnalysis.fromJson(json['analysis'])
          : null, // 🔥 분석 결과 복원
    );
  }
}