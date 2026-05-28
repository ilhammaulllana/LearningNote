import 'package:hive/hive.dart';
import '../models/log_entry.dart';

class HiveService {
  static final Box<LogEntry> _box = Hive.box<LogEntry>('logs');

  static List<LogEntry> getLogs() {
    return _box.values.toList();
  }

  static Future<void> saveLog(LogEntry log) async {
    await _box.put(log.id, log);
  }

  static Future<void> deleteLog(String id) async {
    await _box.delete(id);
  }
}
