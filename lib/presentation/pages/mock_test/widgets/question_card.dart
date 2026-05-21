// lib/presentation/pages/mock_test/widgets/question_card.dart

import 'package:flutter/material.dart';
import '../../../../core/models/mock_question.dart';
import '../../../../core/theme/app_colors.dart';
import 'option_tile.dart';

/// A StatelessWidget that displays a single question and its 4 option tiles.
class QuestionCard extends StatelessWidget {
  final MockQuestion question;
  final int questionIndex;
  final int? selectedOption;
  final bool isSubmitted;
  final bool isFlagged;
  final ValueChanged<int> onOptionSelected;
  final VoidCallback onFlag;
  final VoidCallback onClearAnswer;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final VoidCallback? onSubmit;

  const QuestionCard({
    super.key,
    required this.question,
    required this.questionIndex,
    this.selectedOption,
    required this.isSubmitted,
    required this.isFlagged,
    required this.onOptionSelected,
    required this.onFlag,
    required this.onClearAnswer,
    this.onPrevious,
    this.onNext,
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Question number + flag row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.blueTint,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Q.$questionIndex',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
            GestureDetector(
              onTap: onFlag,
              child: Icon(
                isFlagged ? Icons.flag_rounded : Icons.flag_outlined,
                color: isFlagged ? const Color(0xFFF59E0B) : AppColors.bodyText,
                size: 22,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // 3. Question text
        Text(
          question.questionText,
          style: const TextStyle(
            color: AppColors.headingText,
            fontSize: 15,
            fontWeight: FontWeight.w600,
            height: 1.55,
          ),
        ),

        // 4. Question image
        if (question.imageUrl != null) ...[
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(question.imageUrl!, fit: BoxFit.contain),
          ),
        ],

        const SizedBox(height: 20),

        // 6. Four OptionTile widgets
        OptionTile(
          letter: 'A',
          text: question.optionA,
          optionIndex: 0,
          selectedOption: selectedOption,
          correctOption: question.correctOption,
          isSubmitted: isSubmitted,
          onTap: () => onOptionSelected(0),
        ),
        const SizedBox(height: 10),
        OptionTile(
          letter: 'B',
          text: question.optionB,
          optionIndex: 1,
          selectedOption: selectedOption,
          correctOption: question.correctOption,
          isSubmitted: isSubmitted,
          onTap: () => onOptionSelected(1),
        ),
        const SizedBox(height: 10),
        OptionTile(
          letter: 'C',
          text: question.optionC,
          optionIndex: 2,
          selectedOption: selectedOption,
          correctOption: question.correctOption,
          isSubmitted: isSubmitted,
          onTap: () => onOptionSelected(2),
        ),
        const SizedBox(height: 10),
        OptionTile(
          letter: 'D',
          text: question.optionD,
          optionIndex: 3,
          selectedOption: selectedOption,
          correctOption: question.correctOption,
          isSubmitted: isSubmitted,
          onTap: () => onOptionSelected(3),
        ),

        const SizedBox(height: 16),

        // 8. "Clear Response" row
        if (selectedOption != null && !isSubmitted)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: onClearAnswer,
              child: const Text('Clear Response', style: TextStyle(color: AppColors.bodyText, fontSize: 12)),
            ),
          ),

        const SizedBox(height: 16),

        // 10. Navigation row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Previous button
            if (onPrevious != null)
              OutlinedButton.icon(
                onPressed: onPrevious,
                icon: const Icon(Icons.arrow_back_ios_new, size: 14),
                label: const Text('Previous'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.headingText,
                  side: const BorderSide(color: AppColors.border),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
              )
            else
              const SizedBox.shrink(),

            // Next / Submit button
            if (onSubmit != null)
              ElevatedButton(
                onPressed: onSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEF4444),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: const Text('Submit Test', style: TextStyle(fontWeight: FontWeight.bold)),
              )
            else if (onNext != null)
              ElevatedButton.icon(
                onPressed: onNext,
                icon: const Text('Next'),
                label: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
              )
            else
              const SizedBox.shrink(),
          ],
        ),
      ],
    );
  }
}
