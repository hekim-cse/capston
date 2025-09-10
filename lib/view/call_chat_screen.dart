import 'package:flutter/material.dart';
import '../viewmodel/call_chat_viewmodel.dart';
import '../viewmodel/audio_recorder_viewmodel.dart';
import '../viewmodel/voice_analysis_viewmodel.dart';
import '../model/scenario_message.dart';
import '../model/call_scenario.dart';
import '../model/call_session_record.dart';
import '../data/session_memory_store.dart';
import '../model/voice_analysis.dart';
import 'call_result_screen.dart';

class CallChatScreen extends StatefulWidget {
  final String scenarioFile;
  final CallScenario scenario;
  final ScenarioGroup group;

  const CallChatScreen({
    super.key,
    required this.scenarioFile,
    required this.scenario,
    required this.group,
  });

  @override
  State<CallChatScreen> createState() => _CallChatScreenState();
}

class _CallChatScreenState extends State<CallChatScreen> {
  late final CallChatViewModel viewModel;
  late final AudioRecorderViewModel recorderViewModel;
  late final VoiceAnalysisViewModel analysisViewModel;
  late final Stopwatch stopwatch;

  @override
  void initState() {
    super.initState();
    stopwatch = Stopwatch()..start();

    viewModel = CallChatViewModel(
      scenarioFile: widget.scenarioFile,
      scenario: widget.scenario,
      group: widget.group,
    );

    recorderViewModel = AudioRecorderViewModel();
    analysisViewModel = VoiceAnalysisViewModel();

    viewModel.onMessageUpdated = () => setState(() {});
    viewModel.onFinished = () {};

    initRecorderAndLoad();
  }

  Future<void> initRecorderAndLoad() async {
    await recorderViewModel.initRecorder();
    await viewModel.loadScenario();
  }

  @override
  void dispose() {
    viewModel.dispose();
    recorderViewModel.dispose();
    stopwatch.stop();
    super.dispose();
  }

  Future<void> handleEndCall() async {
    final recordedFile = await recorderViewModel.stopRecording();
    if (recordedFile == null) {
      print("⚠️ 녹음 파일 없음");
      return;
    }

    final analysis = await analysisViewModel.analyze(recordedFile);

    if (!mounted) return;

    stopwatch.stop();
    SessionMemoryStore.addRecord(CallSessionRecord(
      category: widget.group.category,
      title: widget.scenario.title,
      duration: stopwatch.elapsed,
      messages: viewModel.messages,
      date: DateTime.now(),      // ✅ 저장 시점 날짜
      analysis: analysis,        // ✅ 음성 분석 결과 같이 저장
    ));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => CallResultScreen(
          group: widget.group,
          title: widget.scenario.title,
          duration: stopwatch.elapsed,
          messages: viewModel.messages.map((m) => {
            'role': m.sender == Sender.user ? 'user' : 'system',
            'text': m.text,
          }).toList(),
          analysis: analysis,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "통화 시뮬레이션",
          style: TextStyle(
            color: Colors.black54,
            fontFamily: 'nanum_eb',
            fontSize: 20,
          ),
        ),
      ),
      body: Column(
        children: [
          // 메시지 리스트
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: viewModel.messages.length,
              itemBuilder: (context, index) {
                final msg = viewModel.messages[index];
                return Align(
                  alignment: msg.sender == Sender.user
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: msg.sender == Sender.user
                          ? Colors.blue[100]
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      msg.text,
                      style: const TextStyle(
                        fontFamily: 'nanum_b',
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          // 🔴 하단 버튼 2개: 마이크 & 통화 종료
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  if (viewModel.isListening) {
                    // 듣고 있던 상태 → 멈춤
                    await viewModel.toggleListening();
                    await recorderViewModel.stopRecording();
                  } else {
                    // 안 듣고 있던 상태 → 시작
                    await recorderViewModel.startRecording();
                    await viewModel.toggleListening();
                  }
                  setState(() {});
                },
                child: Icon(
                  viewModel.isListening ? Icons.stop_circle : Icons.mic,
                  color: Colors.blue,
                  size: 64,
                ),
              ),
              const SizedBox(width: 24),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[400],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                onPressed: handleEndCall,
                icon: const Icon(Icons.call_end),
                label: const Text(
                  "통화 종료",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}