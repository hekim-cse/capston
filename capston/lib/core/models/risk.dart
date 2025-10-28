enum RiskLevel { ok, caution, danger }

class Risk {
  final RiskLevel level;
  final int score; // 0~100
  final List<String> advice;
  Risk({required this.level, required this.score, required this.advice});
}