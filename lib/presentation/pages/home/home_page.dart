import 'package:flutter/material.dart';
import 'widgets/hero_section.dart';
import 'widgets/social_proof.dart';
import 'widgets/upcoming_exams.dart';
import 'widgets/why_choose_us.dart';
import 'widgets/department_section.dart';

class HomePage extends StatelessWidget {
  final VoidCallback onBrowsePressed;

  const HomePage({super.key, required this.onBrowsePressed});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        const SizedBox(height: 32),
        HeroSection(onBrowsePressed: onBrowsePressed),
        const SizedBox(height: 12),
        const SocialProof(),
        const SizedBox(height: 48),
        const UpcomingExams(),
        const SizedBox(height: 48),
        const WhyChooseUs(),
        const SizedBox(height: 48),
        const DepartmentSection(),
        const SizedBox(height: 60),
      ],
    );
  }
}
