import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';
import '../../model/voice_analysis.dart';

class VoiceAnalysisApi {
  static Future<VoiceAnalysis> analyzeVoice(File file) async {
    final uri = Uri.parse('http://192.168.10.105:8001/analyze'); // ✅ 서버 IP
    final request = http.MultipartRequest('POST', uri);

    request.files.add(await http.MultipartFile.fromPath(
      'audio',
      file.path,
      filename: basename(file.path),
      contentType: MediaType('audio', 'wav'),
    ));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      // ✅ UTF-8 강제 디코딩 (깨짐 방지)
      final decoded = utf8.decode(response.bodyBytes);
      final jsonData = json.decode(decoded);

      return VoiceAnalysis.fromJson(jsonData);
    } else {
      throw Exception('음성 분석 실패: ${response.statusCode} / ${response.body}');
    }
  }
}