class Measurement {
  final double rh;
  final double temp;
  final double? tvoc;
  final double? pm25;
  final double? co2e;
  final String? ts;
  final String? roomId;

  Measurement({
    required this.rh,
    required this.temp,
    this.tvoc,
    this.pm25,
    this.co2e,
    this.ts,
    this.roomId,
  });

  factory Measurement.fromJson(Map<String, dynamic> j) => Measurement(
    rh: (j['rh'] ?? j['humidity_percent'])?.toDouble() ?? 0,
    temp: (j['temp'] ?? j['temperature_celsius'])?.toDouble() ?? 0,
    tvoc: (j['tvoc'] ?? 0).toDouble(),
    pm25: (j['pm25'] ?? 0).toDouble(),
    co2e: (j['co2e'] ?? 0).toDouble(),
    ts: j['timestamp']?.toString(),
    roomId: j['room_id']?.toString(),
  );
}