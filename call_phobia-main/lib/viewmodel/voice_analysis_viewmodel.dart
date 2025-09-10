import 'dart:io';
import '../data/remote/voice_analysis_api.dart';
import '../model/voice_analysis.dart';

class VoiceAnalysisViewModel {
  VoiceAnalysis? result;

  Future<VoiceAnalysis?> analyze(File file) async {
    try {
      result = await VoiceAnalysisApi.analyzeVoice(file);
      return result;
    } catch (e) {
      print("❌ 분석 실패: $e");
      return null;
    }
  }
}