// 📁 lib/viewmodel/call_chat_viewmodel.dart
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../model/scenario_message.dart';
import 'package:http/http.dart' as http;
import '../model/call_scenario.dart';

class CallChatViewModel {
  final String scenarioFile;
  final CallScenario scenario;
  final List<ScenarioMessage> _scenario = [];
  final List<ScenarioMessage> messages = [];
  final ScenarioGroup group;

  final stt.SpeechToText _speech = stt.SpeechToText();
  bool isListening = false;

  int _currentIndex = 0;
  void Function()? onMessageUpdated;
  void Function()? onFinished;

  CallChatViewModel({
    required this.scenarioFile,
    required this.scenario,
    required this.group,
  });

  Future<void> loadScenario() async {
    final jsonString = await rootBundle.loadString(scenarioFile);
    final List<dynamic> jsonData = json.decode(jsonString);
    _scenario.clear();
    _scenario.addAll(jsonData.map((e) => ScenarioMessage.fromJson(e)));

    _showNextSystemMessage();
  }

  Future<String> getAIResponse(String userMessage) async {
    final url = Uri.parse("http://192.168.10.105:8001/chat");

    print("📨 AI 서버에 보낼 메시지: $userMessage");

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "category": group.category,
        "nickname": group.nickname, // ✅ 누락되었던 nickname 추가
        "title": scenario.title,
        "description": scenario.description,
        "userMessage": userMessage,
      }),
    );

    print("📥 서버 응답 상태: ${response.statusCode}");
    print("📥 서버 응답 본문: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['response'];
    } else {
      return '서버 오류: ${response.statusCode}';
    }
  }

  Future<String> translateToKorean(String englishText) async {
    final url = Uri.parse("https://libretranslate.com/translate");

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "q": englishText,
        "source": "en",
        "target": "ko",
        "format": "text"
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['translatedText'];
    } else {
      return '⚠️ 번역 실패: ${response.statusCode}';
    }
  }

  void _handleUserResponse(String userText) async {
    messages.add(ScenarioMessage(sender: Sender.user, text: userText));
    onMessageUpdated?.call();

    messages.add(ScenarioMessage(sender: Sender.agent, text: '...'));
    onMessageUpdated?.call();
    final aiResponse = await getAIResponse(userText);

// 🔒 응답이 비어있는 경우도 대비
    if (aiResponse.startsWith("서버 오류") || aiResponse.trim().isEmpty) {
      messages.removeLast();
      messages.add(ScenarioMessage(sender: Sender.agent, text: aiResponse));
      onMessageUpdated?.call();
      return;
    }

    final translated = await translateToKorean(aiResponse);

// 🔒 번역 실패 시 fallback 처리
    if (translated.startsWith("⚠️ 번역 실패")) {
      messages.removeLast();
      messages.add(ScenarioMessage(sender: Sender.agent, text: aiResponse)); // 영어 그대로 출력
      onMessageUpdated?.call();
      return;
    }

// 🔁 정상 처리
    messages.removeLast();
    messages.add(ScenarioMessage(sender: Sender.agent, text: translated));
    onMessageUpdated?.call();

    messages.removeLast();
    messages.add(ScenarioMessage(sender: Sender.agent, text: translated));
    onMessageUpdated?.call();
  }

  void _showNextSystemMessage() {
    if (_currentIndex >= _scenario.length) {
      onFinished?.call();
      return;
    }

    final msg = _scenario[_currentIndex];
    if (msg.sender == Sender.agent) {
      messages.add(msg);
      _currentIndex++;
      onMessageUpdated?.call();
    }
  }

  Future<void> toggleListening() async {
    if (!isListening) {
      final available = await _speech.initialize(
        onStatus: (status) {
          if (status == 'done') {
            isListening = false;
            onMessageUpdated?.call();
          }
        },
        onError: (error) {
          print('❌ 오류: ${error.errorMsg}');
        },
      );

      if (available) {
        isListening = true;
        onMessageUpdated?.call();
        _speech.listen(
          onResult: (result) {
            if (result.finalResult && result.recognizedWords.isNotEmpty) {
              print("🎤 Recognized: ${result.recognizedWords}");
              _handleUserResponse(result.recognizedWords.trim());
              isListening = false;
              onMessageUpdated?.call();
            }
          },
          localeId: 'ko_KR',
          listenMode: stt.ListenMode.dictation,
          partialResults: false,
          pauseFor: const Duration(milliseconds: 2000),
          cancelOnError: true,
        );
      }
    } else {
      _speech.stop();
      isListening = false;
      onMessageUpdated?.call();
    }
  }

  void dispose() {
    _speech.stop();
  }
}
