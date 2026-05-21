// lib/presentation/pages/mock_test/mock_test_instructions_page.dart

import 'package:flutter/material.dart';
import 'package:spsc_ready/core/models/mock_test_config.dart';
import 'package:spsc_ready/core/theme/app_colors.dart';

/// Page displaying instructions and exam summary before starting a mock test.
class MockTestInstructionsPage extends StatefulWidget {
  final MockTestConfig config;

  const MockTestInstructionsPage({super.key, required this.config});

  @override
  State<MockTestInstructionsPage> createState() => _MockTestInstructionsPageState();
}

class _MockTestInstructionsPageState extends State<MockTestInstructionsPage> {
  bool _acknowledged = false;

  void _startTest(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Active Test')),
          body: const Center(child: Text('Active Test — Coming in Phase 2')),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.headingText, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.config.examName,
          style: const TextStyle(
            color: AppColors.headingText,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildHeroArea(),
            const SizedBox(height: 32),
            _buildSummaryChips(),
            const SizedBox(height: 32),
            _buildInstructionsCard(),
            const SizedBox(height: 24),
            _buildAcknowledgementRow(),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildHeroArea() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.blueTint,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(Icons.quiz_rounded, size: 48, color: AppColors.primary),
        ),
        const SizedBox(height: 16),
        const Text(
          'General Instructions',
          style: TextStyle(
            color: AppColors.headingText,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Read carefully before starting',
          style: TextStyle(
            color: AppColors.bodyText,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: [
        _infoChip(Icons.help_outline_rounded, '${widget.config.questionCount} Questions'),
        _infoChip(Icons.timer_outlined, '${widget.config.durationMinutes} Minutes'),
        _infoChip(Icons.add_circle_outline_rounded, '+${widget.config.marksPerQuestion} Correct'),
        _infoChip(Icons.remove_circle_outline_rounded, '−${widget.config.negativeMarks} Wrong'),
      ],
    );
  }

  Widget _infoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.blueTint,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.headingText,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionsCard() {
    final rules = [
      'This test consists of ${widget.config.questionCount} multiple-choice questions.',
      'Total duration is ${widget.config.durationMinutes} minutes. Timer starts on "Start Test".',
      'Each correct answer: +${widget.config.marksPerQuestion} mark. Wrong answer: −${widget.config.negativeMarks} marks.',
      'Unanswered questions carry no marks and no penalty.',
      'Navigate freely between questions using the Question Palette.',
      'Flag questions for later review using the flag button.',
      'At 00:00, the test auto-submits with your current answers.',
      'Do not close or background the app during the test.',
      'Answer explanations are shown ONLY after submission on the Review screen.',
      'Ensure a stable internet connection before starting.',
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.info_outline, color: AppColors.primary, size: 18),
              SizedBox(width: 8),
              Text(
                'Instructions',
                style: TextStyle(
                  color: AppColors.headingText,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...List.generate(rules.length, (index) => _buildRuleRow(index + 1, rules[index])),
        ],
      ),
    );
  }

  Widget _buildRuleRow(int number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 16,
            height: 16,
            margin: const EdgeInsets.only(top: 2),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$number',
                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: AppColors.bodyText,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAcknowledgementRow() {
    return GestureDetector(
      onTap: () => setState(() => _acknowledged = !_acknowledged),
      child: Row(
        children: [
          SizedBox(
            height: 24,
            width: 24,
            child: Checkbox(
              value: _acknowledged,
              onChanged: (val) => setState(() => _acknowledged = val ?? false),
              activeColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'I have read and understood all the instructions above.',
              style: TextStyle(
                color: AppColors.bodyText,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: ElevatedButton(
          onPressed: _acknowledged ? () => _startTest(context) : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            disabledBackgroundColor: Colors.grey.shade300,
            elevation: 0,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'Start Test',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward_rounded),
            ],
          ),
        ),
      ),
    );
  }
}
