import 'package:edutrack/provider/log_provider.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'theme/app_theme.dart';
import 'screens/main_screen.dart';
import 'models/log_entry.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(LogEntryAdapter());

  await Hive.openBox<LogEntry>('logs');

  runApp(
    ChangeNotifierProvider(
      create: (_) => LogProvider()..loadLogs(),
      child: const LearningTrackerApp(),
    ),
  );
}

class LearningTrackerApp extends StatelessWidget {
  const LearningTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Learning Tracker MVP',
      theme: AppTheme.lightTheme,
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
