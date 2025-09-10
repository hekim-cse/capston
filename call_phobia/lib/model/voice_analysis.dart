class VoiceAnalysis {
  final Pitch pitch;
  final ValueComment jitter;
  final ValueComment shimmer;

  VoiceAnalysis({
    required this.pitch,
    required this.jitter,
    required this.shimmer,
  });

  factory VoiceAnalysis.fromJson(Map<String, dynamic> json) {
    return VoiceAnalysis(
      pitch: Pitch.fromJson(json['pitch']),
      jitter: ValueComment.fromJson(json['jitter']),
      shimmer: ValueComment.fromJson(json['shimmer']),
    );
  }

  /// ✅ 추가: JSON 변환
  Map<String, dynamic> toJson() => {
    'pitch': pitch.toJson(),
    'jitter': jitter.toJson(),
    'shimmer': shimmer.toJson(),
  };
}

class Pitch {
  final double mean;
  final String comment;

  Pitch({required this.mean, required this.comment});

  factory Pitch.fromJson(Map<String, dynamic> json) {
    return Pitch(
      mean: (json['mean'] as num?)?.toDouble() ?? 0.0,
      comment: _decodeString(json['comment']),
    );
  }

  /// ✅ 추가
  Map<String, dynamic> toJson() => {
    'mean': mean,
    'comment': comment,
  };
}

class ValueComment {
  final double value;
  final String comment;

  ValueComment({required this.value, required this.comment});

  factory ValueComment.fromJson(Map<String, dynamic> json) {
    return ValueComment(
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
      comment: _decodeString(json['comment']),
    );
  }

  /// ✅ 추가
  Map<String, dynamic> toJson() => {
    'value': value,
    'comment': comment,
  };
}

/// ✅ UTF-8 안전 문자열 디코딩 함수
String _decodeString(dynamic value) {
  if (value == null) return "";
  try {
    return value.toString();
  } catch (_) {
    return "";
  }
}