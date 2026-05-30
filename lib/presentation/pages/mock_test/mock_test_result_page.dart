// lib/presentation/pages/mock_test/mock_test_result_page.dart

import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/models/mock_test_result.dart';
import '../../../core/theme/app_colors.dart';

const _successColor = Color(0xFF22C55E);
const _dangerColor  = Color(0xFFEF4444);

/// Page showing the results and analytics of a completed mock test.
class MockTestResultPage extends StatefulWidget {
  final MockTestResult result;

  const MockTestResultPage({super.key, required this.result});

  @override
  State<MockTestResultPage> createState() => _MockTestResultPageState();
}

class _MockTestResultPageState extends State<MockTestResultPage> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scoreAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(duration: const Duration(seconds: 2), vsync: this);
    
    final double endValue = widget.result.totalMarks > 0 
        ? (widget.result.score / widget.result.totalMarks).clamp(0.0, 1.0)
        : 0.0;

    _scoreAnimation = Tween<double>(begin: 0, end: endValue)
        .animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Test Result', style: TextStyle(color: AppColors.headingText, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          // --- HERO SCORE CARD ---
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, Color(0xFF1D4ED8)],
                begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.3),
                                    blurRadius: 20, offset: const Offset(0,8))]
            ),
            child: Column(children: [
              AnimatedBuilder(
                animation: _scoreAnimation,
                builder: (context, _) {
                  return SizedBox(
                    width: 120, height: 120,
                    child: CustomPaint(
                      painter: _ScoreRingPainter(progress: _scoreAnimation.value),
                      child: Center(
                        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Text(widget.result.formattedScore,
                               style: const TextStyle(color: Colors.white, fontSize: 26,
                                                fontWeight: FontWeight.w900)),
                          Text('/ ${widget.result.totalMarks}',
                               style: const TextStyle(color: Colors.white70, fontSize: 12)),
                        ])
                      )
                    )
                  );
                }
              ),
              const SizedBox(height: 16),
              Text('${widget.result.performanceEmoji} ${widget.result.performanceLabel}',
                   style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(widget.result.config.examName,
                   style: const TextStyle(color: Colors.white70, fontSize: 13),
                   textAlign: TextAlign.center),
            ])
          ),

          const SizedBox(height: 20),

          // --- STATS GRID ---
          _buildStatsRow(
            _StatCard(label: 'Correct',  value: '${widget.result.correct}',
                      icon: Icons.check_circle_rounded, color: _successColor),
            _StatCard(label: 'Wrong',    value: '${widget.result.wrong}',
                      icon: Icons.cancel_rounded, color: _dangerColor),
          ),
          const SizedBox(height: 10),
          _buildStatsRow(
            _StatCard(label: 'Unanswered', value: '${widget.result.unanswered}',
                      icon: Icons.remove_circle_outline, color: const Color(0xFF94A3B8)),
            _StatCard(label: 'Marks Lost',
                      value: (widget.result.wrong * 0.25).toStringAsFixed(2),
                      icon: Icons.trending_down_rounded, color: _dangerColor),
          ),
          const SizedBox(height: 10),
          _buildStatsRow(
            _StatCard(label: 'Accuracy',
                      value: '${widget.result.accuracyPercent.toStringAsFixed(1)}%',
                      icon: Icons.analytics_rounded, color: AppColors.primary),
            _StatCard(label: 'Time Taken', value: widget.result.formattedTimeTaken,
                      icon: Icons.access_time_rounded, color: const Color(0xFF8B5CF6)),
          ),

          const SizedBox(height: 24),

          // --- ACTION BUTTONS ---
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (_) => MockTestReviewPage(result: widget.result)));
            },
            icon: const Icon(Icons.rate_review_rounded),
            label: const Text('Review Answers & Explanations',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            )
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () => Navigator.of(context)
                .popUntil((route) => route.isFirst),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 52),
              side: const BorderSide(color: AppColors.border),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Back to Home', style: TextStyle(color: AppColors.headingText))
          ),
        ])
      )
    );
  }

  Widget _buildStatsRow(Widget left, Widget right) {
    return Row(children: [
      Expanded(child: left),
      const SizedBox(width: 10),
      Expanded(child: right),
    ]);
  }
}

class _StatCard extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;

  const _StatCard({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(color: AppColors.bodyText, fontSize: 12)),
        ]),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(color: AppColors.headingText, fontWeight: FontWeight.w800, fontSize: 22)),
      ])
    );
  }
}

class _ScoreRingPainter extends CustomPainter {
  final double progress;
  _ScoreRingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (math.min(size.width, size.height) / 2) - 5;
    
    final bgPaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke;

    final fgPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -math.pi / 2, 2 * math.pi * progress, false, fgPaint);
  }

  @override
  bool shouldRepaint(_ScoreRingPainter oldDelegate) => oldDelegate.progress != progress;
}

class MockTestReviewPage extends StatelessWidget {
  final MockTestResult result;
  const MockTestReviewPage({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Review Answers', style: TextStyle(color: AppColors.headingText, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.headingText, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: result.answerReviews.length,
        itemBuilder: (context, index) {
          final review = result.answerReviews[index];
          
          return Container(
            margin: const EdgeInsets.only(bottom: 24),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Question ${index + 1}', 
                      style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13)),
                    if (review.selectedOption == null)
                      const Text('Unanswered', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12, fontWeight: FontWeight.w600))
                    else if (review.isCorrect)
                      const Text('Correct', style: TextStyle(color: _successColor, fontSize: 12, fontWeight: FontWeight.w600))
                    else
                      const Text('Incorrect', style: TextStyle(color: _dangerColor, fontSize: 12, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 12),
                Text(review.questionText, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.headingText)),
                const SizedBox(height: 20),
                // Note: The backend AnswerReviewDto doesn't return all option texts, only the labels.
                // If we want the full text here, we'd need to keep the original questions or have backend return them.
                // For now, let's show what we have.
                _ReviewSummary(review: review),
                
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.blueTint,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.lightbulb_outline, size: 16, color: AppColors.primary),
                          SizedBox(width: 8),
                          Text('Explanation', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(review.explanation, style: const TextStyle(color: AppColors.bodyText, fontSize: 13, height: 1.5)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ReviewSummary extends StatelessWidget {
  final AnswerReview review;
  const _ReviewSummary({required this.review});

  @override
  Widget build(BuildContext context) {
    String getLabel(int? idx) => idx == null ? 'None' : String.fromCharCode('A'.codeUnitAt(0) + idx);

    return Column(
      children: [
        _miniTile(
          label: 'Your Answer', 
          value: getLabel(review.selectedOption), 
          color: review.selectedOption == null ? Colors.grey : (review.isCorrect ? _successColor : _dangerColor)
        ),
        const SizedBox(height: 8),
        _miniTile(
          label: 'Correct Answer', 
          value: getLabel(review.correctOption), 
          color: _successColor
        ),
      ],
    );
  }

  Widget _miniTile({required String label, required String value, required Color color}) {
    return Row(
      children: [
        Text('$label: ', style: const TextStyle(color: AppColors.bodyText, fontSize: 13)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
          child: Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13)),
        ),
      ],
    );
  }
}
