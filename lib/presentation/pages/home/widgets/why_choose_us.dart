import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class WhyChooseUs extends StatelessWidget {
  const WhyChooseUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const Text(
            'Why choose our Portal?',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.headingText,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Dynamic learning tools for Sikkim PSC.',
            style: TextStyle(color: AppColors.bodyText),
          ),
          const SizedBox(height: 24),
          _featureTile(Icons.filter_list_rounded, 'Easy Filtering',
              'Find papers by year and stage instantly.'),
          const SizedBox(height: 12),
          _featureTile(Icons.picture_as_pdf_outlined, 'In-App PDF Viewer',
              'No more storage worries. Read online.'),
          const SizedBox(height: 12),
          _featureTile(Icons.quiz_outlined, 'Mock Test Conversion',
              'Practice questions as interactive tests.'),
        ],
      ),
    );
  }

  Widget _featureTile(IconData icon, String title, String desc) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: AppColors.headingText,
                  ),
                ),
                Text(
                  desc,
                  style: const TextStyle(fontSize: 12, color: AppColors.bodyText),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
