import 'package:edutrack/provider/log_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/log_entry.dart';
import '../theme/app_theme.dart';

class NoteScreen extends StatefulWidget {
  final LogEntry? entry;

  const NoteScreen({super.key, this.entry});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  late TextEditingController _learningController;
  late TextEditingController _takeawayController;
  late TextEditingController _durationController;

  bool _isSaved = false;

  final List<String> _categories = [
    'Technology',
    'Design',
    'Flutter',
    'Programming',
  ];

  late List<String> _selectedCategories;

  @override
  void initState() {
    super.initState();

    _learningController = TextEditingController(
      text: widget.entry?.content ?? '',
    );

    _takeawayController = TextEditingController(
      text: widget.entry?.takeaway ?? '',
    );

    _durationController = TextEditingController(
      text: widget.entry?.duration ?? '',
    );

    _selectedCategories = widget.entry?.categories ?? [];

    if (widget.entry != null) {
      _isSaved = true;
    }
  }

  @override
  void dispose() {
    _learningController.dispose();
    _takeawayController.dispose();
    _durationController.dispose();

    super.dispose();
  }

  Future<void> _saveNote() async {
    if (_learningController.text.trim().isEmpty) {
      return;
    }

    final entry = LogEntry(
      id: widget.entry?.id ?? const Uuid().v4(),
      content: _learningController.text,
      takeaway: _takeawayController.text,
      duration: _durationController.text,
      categories: _selectedCategories,
      date: widget.entry?.date ?? DateTime.now(),
    );

    final provider = Provider.of<LogProvider>(context, listen: false);

    await provider.addLog(entry);

    setState(() {
      _isSaved = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.entry == null
              ? 'Learning log saved!'
              : 'Learning log updated!',
        ),
      ),
    );
  }

  Widget _buildInputTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    bool isNumber = false,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,

      keyboardType: isNumber ? TextInputType.number : TextInputType.text,

      inputFormatters: isNumber ? [FilteringTextInputFormatter.digitsOnly] : [],

      style: Theme.of(context).textTheme.bodyMedium,

      decoration: InputDecoration(
        hintText: hint,

        prefixIcon: Icon(icon, color: AppTheme.outline),

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label) {
    final isSelected = _selectedCategories.contains(label);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedCategories.remove(label);
          } else {
            _selectedCategories.add(label);
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8, bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primary.withOpacity(0.12)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: isSelected ? AppTheme.primary : Colors.transparent,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppTheme.background,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        actions: [
          if (widget.entry != null)
            IconButton(
              onPressed: () async {
                final provider = Provider.of<LogProvider>(
                  context,
                  listen: false,
                );

                await provider.deleteLog(widget.entry!.id);

                if (mounted) {
                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Learning log deleted')),
                  );
                }
              },
              icon: const Icon(Icons.delete_outline, color: Colors.red),
            ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              'Log Your Learning',
              style: Theme.of(
                context,
              ).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(
              "Capture today's insights to maintain your momentum.",
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: AppTheme.textSecondary),
            ),

            const SizedBox(height: 28),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),

                border: const Border(
                  left: BorderSide(color: AppTheme.secondary, width: 4),
                ),

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
                  _buildInputTitle('What did you learn today?'),

                  _buildTextField(
                    controller: _learningController,
                    hint: 'e.g., Fundamental Flutter',
                    icon: Icons.menu_book_outlined,
                  ),

                  const SizedBox(height: 28),

                  _buildInputTitle('Key Takeaways'),

                  _buildTextField(
                    controller: _takeawayController,
                    hint: "Summarize the main concepts or 'aha!' moments...",
                    icon: Icons.lightbulb_outline,
                    maxLines: 4,
                  ),

                  const SizedBox(height: 28),

                  _buildInputTitle('Duration'),

                  _buildTextField(
                    controller: _durationController,
                    hint: 'e.g., 45',
                    icon: Icons.timer_outlined,
                    isNumber: true,
                  ),

                  const SizedBox(height: 28),

                  _buildInputTitle('Category Focus'),

                  Wrap(
                    children: [
                      ..._categories.map((e) => _buildCategoryChip(e)),
                    ],
                  ),

                  const SizedBox(height: 40),

                  SizedBox(
                    width: double.infinity,

                    child: ElevatedButton.icon(
                      onPressed: _saveNote,

                      icon: const Icon(Icons.save),

                      label: Text(
                        widget.entry == null ? 'Save Note' : 'Update Note',
                      ),

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

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
