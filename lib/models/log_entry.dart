import 'package:hive/hive.dart';

part 'log_entry.g.dart';

@HiveType(typeId: 0)
class LogEntry extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String content;

  @HiveField(2)
  final DateTime date;

  @HiveField(3)
  final String? aiResponse;

  @HiveField(4)
  final String takeaway;

  @HiveField(5)
  final String duration;

  @HiveField(6)
  final List<String> categories;

  LogEntry({
    required this.id,
    required this.content,
    required this.date,
    this.aiResponse,
    required this.takeaway,
    required this.duration,
    required this.categories,
  });
}
