// lib/presentation/pages/mock_test/mock_test_subject_selection_page.dart

import 'package:flutter/material.dart';
import '../../../core/models/mock_test_config.dart';
import '../../../core/theme/app_colors.dart';
import 'mock_test_instructions_page.dart';

class MockTestSubjectSelectionPage extends StatefulWidget {
  final MockExamCategory category;

  const MockTestSubjectSelectionPage({super.key, required this.category});

  @override
  State<MockTestSubjectSelectionPage> createState() => _MockTestSubjectSelectionPageState();
}

class _MockTestSubjectSelectionPageState extends State<MockTestSubjectSelectionPage> {
  bool _isLoading = false;
  List<MockTestConfig> _subjects = [];

  @override
  void initState() {
    super.initState();
    _loadSubjects();
  }

  Future<void> _loadSubjects() async {
    setState(() => _isLoading = true);
    // Simulating API call filtered by category
    await Future.delayed(const Duration(milliseconds: 600));
    setState(() {
      _subjects = MockTestConfig.dummyList()
          .where((test) => test.categoryName == widget.category.name)
          .toList();
      _isLoading = false;
    });
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
          widget.category.name,
          style: const TextStyle(
            color: AppColors.headingText,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select Subject',
                  style: TextStyle(
                    color: AppColors.headingText,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Choose a subject to start your practice for ${widget.category.name}',
                  style: const TextStyle(
                    color: AppColors.bodyText,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                : _subjects.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        itemCount: _subjects.length,
                        itemBuilder: (context, index) {
                          final subject = _subjects[index];
                          return _SubjectCard(config: subject);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.subject_rounded, size: 64, color: AppColors.border),
          SizedBox(height: 16),
          Text(
            'No subjects available yet',
            style: TextStyle(color: AppColors.bodyText, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class _SubjectCard extends StatelessWidget {
  final MockTestConfig config;

  const _SubjectCard({required this.config});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MockTestInstructionsPage(config: config),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.blueTint,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.menu_book_rounded, color: AppColors.primary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      config.examName,
                      style: const TextStyle(
                        color: AppColors.headingText,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${config.questionCount} Questions • ${config.durationMinutes} Mins',
                      style: const TextStyle(
                        color: AppColors.bodyText,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.border),
            ],
          ),
        ),
      ),
    );
  }
}
