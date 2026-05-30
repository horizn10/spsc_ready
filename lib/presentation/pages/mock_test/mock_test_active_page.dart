// lib/presentation/pages/mock_test/mock_test_active_page.dart

import 'package:flutter/material.dart';
import '../../../controllers/mock_test_controller.dart';
import '../../../core/models/mock_test_config.dart';
import '../../../core/theme/app_colors.dart';
import 'mock_test_result_page.dart';
import 'widgets/question_card.dart';
import 'widgets/question_palette_sheet.dart';

/// The main exam screen where the user answers questions.
class MockTestActivePage extends StatefulWidget {
  final MockTestConfig config;

  const MockTestActivePage({super.key, required this.config});

  @override
  State<MockTestActivePage> createState() => _MockTestActivePageState();
}

class _MockTestActivePageState extends State<MockTestActivePage> {
  late MockTestController _controller;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _controller = MockTestController(config: widget.config);
    _pageController = PageController();
    _controller.addListener(_onControllerUpdate);
    _controller.loadAndStart();
  }

  void _onControllerUpdate() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerUpdate);
    _controller.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _showPalette(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => QuestionPaletteSheet(
        totalQuestions: _controller.totalQuestions,
        currentIndex: _controller.currentIndex,
        answers: _controller.answers,
        flagged: _controller.flagged,
        onTapQuestion: (i) {
          _controller.goToQuestion(i);
          _pageController.jumpToPage(i);
        },
        onSubmit: () => _confirmAndSubmit(context),
        isSubmitted: _controller.isSubmitted,
      ),
    );
  }

  void _confirmAndSubmit(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Submit Test?'),
        content: Text('You have answered ${_controller.answeredCount} of ${_controller.totalQuestions} questions.\nUnanswered: ${_controller.unansweredCount}.\n\nThis action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              setState(() => _controller.isLoading = true);
              
              final result = await _controller.submitTest();
              
              if (mounted) {
                if (result != null) {
                  Navigator.pushReplacement(
                    context, 
                    MaterialPageRoute(builder: (_) => MockTestResultPage(result: result!))
                  );
                } else {
                  setState(() => _controller.isLoading = false);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to submit test. Please try again.'), backgroundColor: Colors.redAccent)
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444), foregroundColor: Colors.white),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  void _handleBackPress() {
    if (_controller.isSubmitted) {
      Navigator.pop(context);
      return;
    }
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Exit Test?'),
        content: const Text('Your progress will be lost. Are you sure you want to exit?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Stay')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: const Color(0xFFEF4444)),
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) { if (!didPop) _handleBackPress(); },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              // --- CUSTOM TOP BAR ---
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: const BoxDecoration(color: Colors.white, border: Border(bottom: BorderSide(color: AppColors.border))),
                child: Row(
                  children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('Question', style: TextStyle(color: AppColors.bodyText, fontSize: 11)),
                      Text('${_controller.currentIndex + 1} / ${_controller.totalQuestions}',
                           style: const TextStyle(color: AppColors.headingText, fontWeight: FontWeight.w800, fontSize: 16))
                    ]),
                    const Spacer(),
                    // --- TIMER ---
                    Builder(builder: (_) {
                      Color timerColor; Color timerBg;
                      switch (_controller.timerState) {
                        case 'danger': timerColor = const Color(0xFFEF4444); timerBg = const Color(0xFFFEE2E2); break;
                        case 'warning': timerColor = const Color(0xFFF59E0B); timerBg = const Color(0xFFFEF3C7); break;
                        default: timerColor = AppColors.primary; timerBg = AppColors.blueTint;
                      }
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(color: timerBg, borderRadius: BorderRadius.circular(20)),
                        child: Row(children: [
                          Icon(Icons.timer_outlined, color: timerColor, size: 16),
                          const SizedBox(width: 6),
                          Text(_controller.timerDisplay, style: TextStyle(color: timerColor, fontWeight: FontWeight.w800, fontSize: 16, letterSpacing: 1.5))
                        ]),
                      );
                    }),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => _showPalette(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: AppColors.blueTint, borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.grid_view_rounded, color: AppColors.primary, size: 22)
                      )
                    )
                  ],
                ),
              ),
              LinearProgressIndicator(
                value: _controller.totalQuestions > 0 ? _controller.answeredCount / _controller.totalQuestions : 0,
                backgroundColor: AppColors.border,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                minHeight: 3,
              ),
              // --- MAIN CONTENT ---
              Expanded(
                child: _controller.isLoading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                  : _controller.errorMessage != null
                    ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        const Icon(Icons.error_outline, color: Color(0xFFEF4444), size: 48),
                        const SizedBox(height: 12),
                        Text(_controller.errorMessage!, style: const TextStyle(color: AppColors.bodyText)),
                        const SizedBox(height: 16),
                        ElevatedButton(onPressed: () => _controller.loadAndStart(), style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white), child: const Text('Retry'))
                      ]))
                    : PageView.builder(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _controller.totalQuestions,
                        itemBuilder: (context, index) {
                          final q = _controller.questions[index];
                          return SingleChildScrollView(
                            padding: const EdgeInsets.all(16),
                            child: QuestionCard(
                              question: q,
                              questionIndex: index + 1,
                              selectedOption: _controller.answers[index],
                              isSubmitted: _controller.isSubmitted,
                              isFlagged: _controller.flagged.contains(index),
                              onOptionSelected: (opt) => _controller.selectAnswer(index, opt),
                              onFlag: () => _controller.toggleFlag(index),
                              onClearAnswer: () => _controller.clearAnswer(index),
                              onPrevious: index > 0 ? () {
                                _controller.previousQuestion();
                                _pageController.previousPage(duration: const Duration(milliseconds: 250), curve: Curves.easeInOut);
                              } : null,
                              onNext: index < _controller.totalQuestions - 1 ? () {
                                _controller.nextQuestion();
                                _pageController.nextPage(duration: const Duration(milliseconds: 250), curve: Curves.easeInOut);
                              } : null,
                              onSubmit: index == _controller.totalQuestions - 1 ? () => _confirmAndSubmit(context) : null,
                            ),
                          );
                        },
                      )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
