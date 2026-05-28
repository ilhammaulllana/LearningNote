import 'package:edutrack/service/hive_service.dart';
import 'package:flutter/material.dart';

import '../models/log_entry.dart';

class LogProvider extends ChangeNotifier {
  List<LogEntry> _logs = [];

  List<LogEntry> get logs => _logs;

  void loadLogs() {
    _logs = HiveService.getLogs();

    _logs.sort((a, b) => b.date.compareTo(a.date));

    notifyListeners();
  }

  // CREATE
  Future<void> addLog(LogEntry log) async {
    await HiveService.saveLog(log);

    loadLogs();
  }

  // UPDATE
  Future<void> updateLog(LogEntry log) async {
    await HiveService.saveLog(log);

    loadLogs();
  }

  // DELETE
  Future<void> deleteLog(String id) async {
    await HiveService.deleteLog(id);

    loadLogs();
  }

  // READ BY ID (optional)
  LogEntry? getLogById(String id) {
    try {
      return _logs.firstWhere((log) => log.id == id);
    } catch (e) {
      return null;
    }
  }
}
