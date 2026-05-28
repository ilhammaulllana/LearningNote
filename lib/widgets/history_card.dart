import 'package:flutter/material.dart';
import '../models/log_entry.dart';
import '../theme/app_theme.dart';
import 'package:intl/intl.dart';

class HistoryCard extends StatelessWidget {
  final LogEntry entry;
  final VoidCallback onTap;

  static const List<Color> accents = [
    AppTheme.secondary,
    AppTheme.primary,
    Color(0xFF10b981),
    Color(0xFFf59e0b),
  ];

  const HistoryCard({super.key, required this.entry, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final accentColor = accents[entry.id.hashCode % accents.length];

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,

        borderRadius: BorderRadius.circular(24),

        border: Border.all(
          color: AppTheme.surfaceContainerHigh.withOpacity(0.5),
        ),

        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Material(
        color: Colors.transparent,

        child: InkWell(
          onTap: onTap,

          borderRadius: BorderRadius.circular(24),

          child: Stack(
            children: [
              // LEFT ACCENT
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,

                child: Container(
                  width: 5,

                  decoration: BoxDecoration(
                    color: accentColor,

                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(999),
                      bottomRight: Radius.circular(999),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(24),

                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    // CONTENT
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          // TITLE
                          Text(
                            entry.content,

                            maxLines: 1,

                            overflow: TextOverflow.ellipsis,

                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),

                          const SizedBox(height: 10),

                          // TAKEAWAYS
                          Text(
                            entry.takeaway,

                            maxLines: 2,

                            overflow: TextOverflow.ellipsis,

                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: AppTheme.textSecondary,
                                  height: 1.5,
                                ),
                          ),

                          const SizedBox(height: 18),

                          // CATEGORY CHIPS
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,

                            children: entry.categories.map((category) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 7,
                                ),

                                decoration: BoxDecoration(
                                  color: accentColor.withOpacity(0.12),

                                  borderRadius: BorderRadius.circular(999),
                                ),

                                child: Text(
                                  category,

                                  style: Theme.of(context).textTheme.labelMedium
                                      ?.copyWith(
                                        color: accentColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              );
                            }).toList(),
                          ),

                          const SizedBox(height: 18),

                          // BOTTOM INFO
                          Wrap(
                            spacing: 16,
                            runSpacing: 10,

                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,

                                children: [
                                  const Icon(
                                    Icons.schedule,
                                    size: 16,
                                    color: AppTheme.textSecondary,
                                  ),

                                  const SizedBox(width: 6),

                                  Text(
                                    entry.duration,

                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                ],
                              ),

                              Row(
                                mainAxisSize: MainAxisSize.min,

                                children: [
                                  const Icon(
                                    Icons.calendar_today,
                                    size: 16,
                                    color: AppTheme.textSecondary,
                                  ),

                                  const SizedBox(width: 6),

                                  Text(
                                    DateFormat(
                                      'dd MMM yyyy',
                                    ).format(entry.date),

                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 14),

                    // AI BADGE
                    if (entry.aiResponse != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),

                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppTheme.primary, AppTheme.secondary],
                          ),

                          borderRadius: BorderRadius.circular(999),

                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.secondary.withOpacity(0.3),

                              blurRadius: 12,
                            ),
                          ],
                        ),

                        child: Row(
                          mainAxisSize: MainAxisSize.min,

                          children: [
                            const Icon(
                              Icons.auto_awesome,
                              color: Colors.white,
                              size: 14,
                            ),

                            const SizedBox(width: 5),

                            Text(
                              'AI',

                              style: Theme.of(context).textTheme.labelMedium
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
