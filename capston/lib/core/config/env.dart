class Env {
  // 처음엔 목업 JSON(로컬)로 시작 → 나중에 FastAPI로 바꿔치기
  static const String baseUrl = 'http://localhost:8000';
  static const bool useMock = true; // false로 바꾸면 실서버 연동
}