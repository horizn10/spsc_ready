// lib/presentation/pages/mock_test/widgets/option_tile.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

const _successBg     = Color(0xFFDCFCE7);
const _successBorder = Color(0xFF22C55E);
const _successText   = Color(0xFF15803D);
const _dangerBg      = Color(0xFFFEE2E2);
const _dangerBorder  = Color(0xFFEF4444);
const _dangerText    = Color(0xFFB91C1C);

/// A StatelessWidget that represents a single option in a multiple-choice question.
class OptionTile extends StatelessWidget {
  final String letter;
  final String text;
  final int optionIndex;
  final int? selectedOption;
  final int? correctOption;
  final bool isSubmitted;
  final VoidCallback onTap;

  const OptionTile({
    super.key,
    required this.letter,
    required this.text,
    required this.optionIndex,
    this.selectedOption,
    this.correctOption,
    required this.isSubmitted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = selectedOption == optionIndex;
    final bool isCorrect  = optionIndex == correctOption;

    // Determine visual state
    Color bgColor, borderColor, textColor, letterBg;
    IconData? trailingIcon;

    if (!isSubmitted) {
      if (isSelected) {
        bgColor = AppColors.blueTint;
        borderColor = AppColors.primary;
        textColor = AppColors.primary;
        letterBg = AppColors.primary;
      } else {
        bgColor = Colors.white;
        borderColor = AppColors.border;
        textColor = AppColors.bodyText;
        letterBg = AppColors.border;
      }
      trailingIcon = null;
    } else {
      if (isSelected && isCorrect) {
        bgColor = _successBg; borderColor = _successBorder;
        textColor = _successText; letterBg = _successBorder;
        trailingIcon = Icons.check_circle_rounded;
      } else if (isSelected && !isCorrect) {
        bgColor = _dangerBg; borderColor = _dangerBorder;
        textColor = _dangerText; letterBg = _dangerBorder;
        trailingIcon = Icons.cancel_rounded;
      } else if (!isSelected && isCorrect) {
        bgColor = _successBg; borderColor = _successBorder;
        textColor = _successText; letterBg = _successBorder;
        trailingIcon = Icons.check_circle_outline_rounded;
      } else {
        bgColor = Colors.white; borderColor = AppColors.border;
        textColor = AppColors.bodyText; letterBg = AppColors.border;
        trailingIcon = null;
      }
    }

    return GestureDetector(
      onTap: isSubmitted ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(
            color: borderColor, 
            width: isSelected || (isSubmitted && isCorrect) ? 2 : 1
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 28, height: 28,
              decoration: BoxDecoration(color: letterBg, borderRadius: BorderRadius.circular(6)),
              alignment: Alignment.center,
              child: Text(letter, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(text, style: TextStyle(color: textColor, fontSize: 14, height: 1.4))),
            if (trailingIcon != null) ...[
              const SizedBox(width: 8),
              Icon(trailingIcon, color: isCorrect ? _successBorder : _dangerBorder, size: 20),
            ]
          ],
        ),
      ),
    );
  }
}
