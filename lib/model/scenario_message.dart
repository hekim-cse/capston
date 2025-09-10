// 📁 lib/model/scenario_message.dart
enum Sender { user, agent }

class ScenarioMessage {
  final Sender sender;
  final String text;
  final int? delay; // milliseconds (optional, future use)

  ScenarioMessage({required this.sender, required this.text, this.delay});

  factory ScenarioMessage.fromJson(Map<String, dynamic> json) {
    return ScenarioMessage(
      sender: json['role'] == 'system' ? Sender.agent : Sender.user,
      text: json['text'],
      delay: json['delay'],
    );
  }

  Map<String, dynamic> toJson() => {
    'role': sender == Sender.agent ? 'system' : 'user',
    'text': text,
    'delay': delay,
  };
}
