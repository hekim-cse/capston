class AppConfig {
  // ngrok 바뀌면 여기 한 줄만 수정
  static const String base = 'https://nonlevel-tamelessly-lovetta.ngrok-free.dev';
  static String wsUrl(String room) => base.replaceFirst('https', 'wss') + '/ws?room=$room';
  static String historyUrl(String room, {int limit = 200}) => '$base/history?room=$room&limit=$limit';
}