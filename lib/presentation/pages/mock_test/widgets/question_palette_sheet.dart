// lib/presentation/pages/mock_test/widgets/question_palette_sheet.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// A StatelessWidget that is shown inside showModalBottomSheet to allow quick navigation between questions.
class QuestionPaletteSheet extends StatelessWidget {
  final int totalQuestions;
  final int currentIndex;
  final Map<int, int> answers;
  final Set<int> flagged;
  final ValueChanged<int> onTapQuestion;
  final VoidCallback onSubmit;
  final bool isSubmitted;

  const QuestionPaletteSheet({
    super.key,
    required this.totalQuestions,
    required this.currentIndex,
    required this.answers,
    required this.flagged,
    required this.onTapQuestion,
    required this.onSubmit,
    required this.isSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Handle bar
        Center(
          child: Container(
            width: 40,
            height: 4,
            color: AppColors.border,
            margin: const EdgeInsets.only(top: 12, bottom: 16),
          ),
        ),

        // Title row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Question Palette',
                style: TextStyle(color: AppColors.headingText, fontWeight: FontWeight.w700, fontSize: 16),
              ),
              IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
            ],
          ),
        ),

        // Legend row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Wrap(
            spacing: 16,
            runSpacing: 8,
            children: const [
              _LegendChip(color: AppColors.primary, label: 'Answered'),
              _LegendChip(color: Color(0xFFF59E0B), label: 'Flagged'),
              _LegendChip(color: Color(0xFF94A3B8), label: 'Not Visited'),
              _LegendChip(color: AppColors.border, label: 'Unanswered'),
            ],
          ),
        ),

        const Divider(color: AppColors.border),

        // Grid
        Flexible(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 10,
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
                childAspectRatio: 1,
              ),
              itemCount: totalQuestions,
              itemBuilder: (context, i) {
                bool isAnswered = answers.containsKey(i);
                bool isFlagged  = flagged.contains(i);
                bool isCurrent  = i == currentIndex;

                Color bgColor = isFlagged
                    ? const Color(0xFFFEF3C7)           // amber-100
                    : isAnswered
                        ? AppColors.blueTint
                        : const Color(0xFFF1F5F9);      // slate-100

                Color borderColor = isFlagged
                    ? const Color(0xFFF59E0B)
                    : isAnswered
                        ? AppColors.primary
                        : AppColors.border;

                Color textColor = isFlagged
                    ? const Color(0xFFB45309)
                    : isAnswered
                        ? AppColors.primary
                        : AppColors.bodyText;

                return GestureDetector(
                  onTap: () {
                    onTapQuestion(i);
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: bgColor,
                      border: Border.all(
                        color: isCurrent ? AppColors.headingText : borderColor,
                        width: isCurrent ? 2.5 : 1,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    alignment: Alignment.center,
                    child: Text('${i + 1}',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textColor)),
                  ),
                );
              },
            ),
          ),
        ),

        // Submit button
        if (!isSubmitted)
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () { Navigator.pop(context); onSubmit(); },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Submit Test', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        const SizedBox(height: 10),
      ],
    );
  }
}

class _LegendChip extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendChip({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(color: AppColors.bodyText, fontSize: 11)),
      ],
    );
  }
}
