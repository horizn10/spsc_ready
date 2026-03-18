import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class HeroSection extends StatelessWidget {
  final VoidCallback onBrowsePressed;

  const HeroSection({super.key, required this.onBrowsePressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w900,
                height: 1.2,
                fontFamily: 'Inter',
              ),
              children: [
                TextSpan(
                  text: 'Prepare Smart for\n',
                  style: TextStyle(color: AppColors.headingText),
                ),
                TextSpan(
                  text: 'SPSC Exams.',
                  style: TextStyle(color: AppColors.primary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Stop searching through messy PDF lists. Access organized question banks, advanced filters, and interactive practice tools designed specifically for SPSC aspirants.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.bodyText,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 32),
          // Primary Action
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 56),
              elevation: 8,
              shadowColor: AppColors.primary.withOpacity(0.3),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: onBrowsePressed,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Browse Question Bank', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(width: 8),
                Icon(Icons.arrow_forward_rounded, size: 20),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Secondary Action
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {},
            child: const Text('Take Free Mock Test', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
