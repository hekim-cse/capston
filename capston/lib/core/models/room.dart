class Room {
  final String roomId;
  final String building;
  final int floor;
  final String name;
  Room({required this.roomId, required this.building, required this.floor, required this.name});

  factory Room.fromJson(Map<String, dynamic> j) => Room(
      roomId: j['room_id'], building: j['building'], floor: j['floor'], name: j['name']
  );
}