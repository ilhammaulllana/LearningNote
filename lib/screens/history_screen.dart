import 'package:edutrack/main.dart';
import 'package:edutrack/provider/log_provider.dart';
import 'package:edutrack/screens/learning_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/log_entry.dart';
import '../theme/app_theme.dart';
import '../widgets/history_card.dart';
import 'note_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LogProvider>(context);

    final logs = List<LogEntry>.from(provider.logs)
      ..sort((a, b) => b.date.compareTo(a.date));

    return Scaffold(
      backgroundColor: AppTheme.background,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppTheme.background,

        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),

              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.1),

                borderRadius: BorderRadius.circular(14),
              ),

              child: const Icon(Icons.history, color: AppTheme.primary),
            ),

            const SizedBox(width: 12),

            Text(
              'Learning History',

              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),

      body: logs.isEmpty
          ? _buildEmptyState(context)
          : ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),

              children: [
                Text(
                  'Your Learning Journey',

                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Review all your learning progress and challenges.',

                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),

                const SizedBox(height: 28),

                ...logs.map(
                  (log) => Padding(
                    padding: const EdgeInsets.only(bottom: 18),

                    child: Dismissible(
                      key: Key(log.id),

                      direction: DismissDirection.endToStart,

                      background: Container(
                        alignment: Alignment.centerRight,

                        padding: const EdgeInsets.only(right: 24),

                        decoration: BoxDecoration(
                          color: Colors.red.shade400,

                          borderRadius: BorderRadius.circular(20),
                        ),

                        child: const Icon(Icons.delete, color: Colors.white),
                      ),

                      onDismissed: (direction) async {
                        await provider.deleteLog(log.id);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Learning log deleted')),
                        );
                      },

                      child: HistoryCard(
                        entry: log,

                        onTap: () async {
                          await Navigator.push(
                            context,

                            MaterialPageRoute(
                              builder: (context) =>
                                  LearningDetailScreen(entry: log),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Container(
              padding: const EdgeInsets.all(24),

              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.08),

                shape: BoxShape.circle,
              ),

              child: Icon(
                Icons.menu_book_rounded,
                size: 60,
                color: AppTheme.primary.withOpacity(0.6),
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'No Learning History Yet',

              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Text(
              'Start tracking your learning journey and build consistency every day.',

              textAlign: TextAlign.center,

              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: AppTheme.textSecondary),
            ),

            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,

                    MaterialPageRoute(builder: (context) => const NoteScreen()),
                  );
                },

                icon: const Icon(Icons.add),

                label: const Text('Start Learning'),

                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
