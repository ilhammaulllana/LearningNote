import 'package:edutrack/provider/log_provider.dart';
import 'package:edutrack/screens/learning_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/log_entry.dart';
import '../theme/app_theme.dart';
import '../widgets/history_card.dart';
import 'note_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _calculateStreak(List<LogEntry> logs) {
    if (logs.isEmpty) return 0;

    final sortedLogs = List<LogEntry>.from(logs)
      ..sort((a, b) => b.date.compareTo(a.date));

    final uniqueDates = sortedLogs
        .map((e) => DateTime(e.date.year, e.date.month, e.date.day))
        .toSet()
        .toList();

    int streak = 0;

    DateTime currentDate = DateTime.now();

    currentDate = DateTime(
      currentDate.year,
      currentDate.month,
      currentDate.day,
    );

    for (int i = 0; i < uniqueDates.length; i++) {
      if (i == 0 && uniqueDates[i].difference(currentDate).inDays.abs() > 1) {
        break;
      }

      if (i == 0 || uniqueDates[i - 1].difference(uniqueDates[i]).inDays == 1) {
        streak++;
      } else {
        break;
      }
    }

    return streak;
  }

  int _calculateWeeklyProgress(List<LogEntry> logs) {
    final now = DateTime.now();

    final weekAgo = now.subtract(const Duration(days: 7));

    return logs.where((e) => e.date.isAfter(weekAgo)).length;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LogProvider>(context);

    final logs = provider.logs;

    final streak = _calculateStreak(logs);

    final weeklyCount = _calculateWeeklyProgress(logs);

    const weeklyGoal = 3;

    final double progress = (weeklyCount / weeklyGoal).clamp(0.0, 1.0);

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

              child: const Icon(Icons.school, color: AppTheme.primary),
            ),

            const SizedBox(width: 12),

            Text(
              'EduTrack',

              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),

        actions: [
          IconButton(
            onPressed: () {},

            icon: const Icon(Icons.notifications_none_rounded),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              'Welcome back 👋',

              style: Theme.of(
                context,
              ).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(
              'Track your daily learning progress and stay consistent.',

              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: AppTheme.textSecondary),
            ),

            const SizedBox(height: 30),

            // STATS
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    title: 'Day Streak',
                    value: '$streak',
                    icon: Icons.local_fire_department,
                    iconColor: Colors.orange,
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: _buildStatCard(
                    title: 'Weekly Goal',
                    value: '$weeklyCount/$weeklyGoal',
                    icon: Icons.track_changes,
                    iconColor: AppTheme.primary,
                    progress: progress,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 34),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Text(
                  'Recent Activity',

                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                TextButton(
                  onPressed: () {},

                  child: const Text(
                    'See All',
                    style: TextStyle(color: AppTheme.secondary),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            if (logs.isEmpty)
              Container(
                width: double.infinity,

                padding: const EdgeInsets.all(32),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.circular(28),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 20,
                    ),
                  ],
                ),

                child: Column(
                  children: [
                    Icon(
                      Icons.menu_book_rounded,
                      size: 60,
                      color: AppTheme.primary.withOpacity(0.3),
                    ),

                    const SizedBox(height: 18),

                    Text(
                      'No learning logs yet',

                      style: Theme.of(context).textTheme.headlineMedium,
                    ),

                    const SizedBox(height: 10),

                    Text(
                      'Start tracking your learning journey today.',

                      textAlign: TextAlign.center,

                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              )
            else
              ...(logs..sort((a, b) => b.date.compareTo(a.date)))
                  .take(3)
                  .map(
                    (log) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),

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
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
    double? progress,
  }) {
    return Container(
      padding: const EdgeInsets.all(22),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(28),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Container(
            padding: const EdgeInsets.all(10),

            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),

              borderRadius: BorderRadius.circular(14),
            ),

            child: Icon(icon, color: iconColor),
          ),

          const SizedBox(height: 18),

          Text(
            value,

            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 34,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            title,

            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary),
          ),

          if (progress != null) ...[
            const SizedBox(height: 14),

            LinearProgressIndicator(
              value: progress,
              minHeight: 7,

              borderRadius: BorderRadius.circular(999),

              backgroundColor: AppTheme.surfaceContainer,

              color: AppTheme.secondary,
            ),
          ],
        ],
      ),
    );
  }
}
