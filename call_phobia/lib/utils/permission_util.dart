// permission_util.dart
import 'package:permission_handler/permission_handler.dart';

Future<bool> requestMicAndSpeechPermissions() async {
  final micStatus = await Permission.microphone.request();
  final speechStatus = await Permission.speech.request();

  final isGranted = micStatus.isGranted && speechStatus.isGranted;

  print('🎤 마이크 권한: $micStatus');
  print('🗣️ 음성 권한: $speechStatus');

  if (!isGranted) {
    print('🔒 권한 거부됨');
  }

  return isGranted;
}