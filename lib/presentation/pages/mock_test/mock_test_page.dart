// lib/presentation/pages/mock_test/mock_test_page.dart

import 'package:flutter/material.dart';
import 'package:spsc_ready/core/models/mock_test_config.dart';
import 'package:spsc_ready/core/theme/app_colors.dart';
import 'package:spsc_ready/presentation/pages/mock_test/mock_test_instructions_page.dart';
import 'package:spsc_ready/presentation/widgets/spsc_app_bar.dart';

/// Local success color for scores and positive indicators.
const Color _successGreen = Color(0xFF10B981);

/// Page displaying a list of available mock tests with filtering.
class MockTestPage extends StatefulWidget {
  const MockTestPage({super.key});

  @override
  State<MockTestPage> createState() => _MockTestPageState();
}

class _MockTestPageState extends State<MockTestPage> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Sub Inspector', 'Paper I', 'Paper II'];
  
  bool _isLoading = false;
  List<MockTestConfig> _tests = [];

  @override
  void initState() {
    super.initState();
    _loadTests();
  }

  Future<void> _loadTests() async {
    setState(() => _isLoading = true);
    // Simulating API call
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() {
      _tests = MockTestConfig.dummyList();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildFilterRow(),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  )
                : _tests.isEmpty
                    ? _buildEmptyState()
                    : _buildTestList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.blueTint,
              borderRadius: BorderRadius.circular(100),
            ),
            child: const Text(
              '🎯 Mock Tests',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Choose Your Mock Test',
            style: TextStyle(
              color: AppColors.headingText,
              fontSize: 24,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Practice with real SPSC exam papers',
            style: TextStyle(
              color: AppColors.bodyText,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: _filters.map((filter) {
          final isSelected = _selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (val) => setState(() => _selectedFilter = filter),
              showCheckmark: false,
              backgroundColor: AppColors.blueTint,
              selectedColor: AppColors.primary,
              checkmarkColor: Colors.white,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide.none,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTestList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      itemCount: _tests.length,
      itemBuilder: (context, index) {
        return MockTestCard(config: _tests[index]);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.quiz_rounded, size: 64, color: AppColors.primary),
          SizedBox(height: 16),
          Text(
            'No tests found',
            style: TextStyle(
              color: AppColors.headingText,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/// A card displaying summary information about a [MockTestConfig].
class MockTestCard extends StatelessWidget {
  final MockTestConfig config;

  const MockTestCard({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 4,
              color: AppColors.primary,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      config.examName,
                      style: const TextStyle(
                        color: AppColors.headingText,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.blueTint,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        config.paperType,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _infoItem(Icons.help_outline_rounded, '${config.questionCount} Questions'),
                        const SizedBox(width: 16),
                        _infoItem(Icons.timer_outlined, '${config.durationMinutes} Minutes'),
                      ],
                    ),
                    if (config.isAttempted && config.bestScore != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        'Best: ${config.bestScore!.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: _successGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MockTestInstructionsPage(config: config),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'Start Test',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward_rounded, size: 16),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.bodyText),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            color: AppColors.bodyText,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
