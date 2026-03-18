import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class MockTestPage extends StatelessWidget {
  const MockTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.quiz_rounded, size: 64, color: AppColors.primary),
          SizedBox(height: 16),
          Text(
            'Mock Test Section',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.headingText,
            ),
          ),
          Text(
            'Coming Soon!',
            style: TextStyle(color: AppColors.bodyText),
          ),
        ],
      ),
    );
  }
}
