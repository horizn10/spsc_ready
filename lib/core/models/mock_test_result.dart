// lib/core/models/mock_test_result.dart

import 'mock_question.dart';
import 'mock_test_config.dart';

/// Model containing the results of a completed mock test session.
class MockTestResult {
  final MockTestConfig config;
  final List<MockQuestion> questions;
  final Map<int, int> answers; // questionIndex -> selectedOptionIndex
  final int correct;
  final int wrong;
  final int unanswered;
  final double score;
  final double maxScore;
  final int timeTakenSeconds;
  final bool autoSubmitted;

  const MockTestResult({
    required this.config,
    required this.questions,
    required this.answers,
    required this.correct,
    required this.wrong,
    required this.unanswered,
    required this.score,
    required this.maxScore,
    required this.timeTakenSeconds,
    required this.autoSubmitted,
  });

  /// Accuracy percentage calculated from answered questions.
  double get accuracyPercent =>
      (correct + wrong) == 0 ? 0 : (correct / (correct + wrong)) * 100;

  /// Formatted score string.
  String get formattedScore => score.toStringAsFixed(2);

  /// Formatted time taken string (e.g., 5m 30s).
  String get formattedTimeTaken {
    final m = timeTakenSeconds ~/ 60;
    final s = timeTakenSeconds % 60;
    return '${m}m ${s}s';
  }

  /// Label describing the user's performance.
  String get performanceLabel {
    final pct = (score / maxScore) * 100;
    if (pct >= 80) return 'Excellent';
    if (pct >= 60) return 'Good';
    if (pct >= 40) return 'Average';
    return 'Keep Practicing';
  }

  /// Emoji representing the user's performance.
  String get performanceEmoji {
    final pct = (score / maxScore) * 100;
    if (pct >= 80) return '🎉';
    if (pct >= 60) return '👍';
    if (pct >= 40) return '📚';
    return '💪';
  }
}
