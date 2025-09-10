import '../model/call_session_record.dart';

class SessionMemoryStore {
  static final List<CallSessionRecord> _records = [];

  static List<CallSessionRecord> get records => List.unmodifiable(_records);

  static void addRecord(CallSessionRecord record) {
    _records.add(record);
  }

  static void clear() {
    _records.clear();
  }
}