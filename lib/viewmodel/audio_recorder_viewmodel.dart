import 'dart:io';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';

class AudioRecorderViewModel {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool isRecording = false;
  String? recordedFilePath;

  Future<void> initRecorder() async {
    await _recorder.openRecorder();
  }

  Future<File?> startRecording() async {
    final dir = await getApplicationDocumentsDirectory();
    final filePath = '${dir.path}/user_voice.wav';

    await _recorder.startRecorder(
      toFile: filePath,
      codec: Codec.pcm16WAV,
    );

    recordedFilePath = filePath;
    isRecording = true;

    return File(filePath);
  }

  Future<File?> stopRecording() async {
    await _recorder.stopRecorder();
    isRecording = false;
    return recordedFilePath != null ? File(recordedFilePath!) : null;
  }



  void dispose() {
    _recorder.closeRecorder();
  }
}