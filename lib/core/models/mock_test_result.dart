// lib/core/models/mock_test_result.dart

import 'mock_question.dart';
import 'mock_test_config.dart';

/// Model containing the results of a completed mock test session (Maps to AttemptResultDto).
class MockTestResult {
  final int attemptId;
  final String mockTestTitle;
  final double score;
  final int totalMarks;
  final double percentage;
  final int correct;
  final int wrong;
  final int unanswered;
  final bool isPassed;
  final List<AnswerReview> answerReviews;
  final MockTestConfig config; // Keeping config for UI context

  const MockTestResult({
    required this.attemptId,
    required this.mockTestTitle,
    required this.score,
    required this.totalMarks,
    required this.percentage,
    required this.correct,
    required this.wrong,
    required this.unanswered,
    required this.isPassed,
    required this.answerReviews,
    required this.config,
  });

  factory MockTestResult.fromJson(Map<String, dynamic> json, MockTestConfig config) {
    // Helper to safely get list
    List<AnswerReview> parseReviews(dynamic data) {
      if (data == null || data is! List) return [];
      return data.map((r) => AnswerReview.fromJson(r as Map<String, dynamic>)).toList();
    }

    return MockTestResult(
      attemptId: ((json['attemptId'] ?? json['AttemptId']) as num?)?.toInt() ?? 0,
      mockTestTitle: (json['mockTestTitle'] ?? json['MockTestTitle']) as String? ?? '',
      score: ((json['totalScore'] ?? json['TotalScore']) as num?)?.toDouble() ?? 0.0,
      totalMarks: ((json['totalMarks'] ?? json['TotalMarks']) as num?)?.toInt() ?? 0,
      percentage: ((json['percentage'] ?? json['Percentage']) as num?)?.toDouble() ?? 0.0,
      correct: ((json['correctCount'] ?? json['CorrectCount']) as num?)?.toInt() ?? 0,
      wrong: ((json['wrongCount'] ?? json['WrongCount']) as num?)?.toInt() ?? 0,
      unanswered: ((json['skippedCount'] ?? json['SkippedCount']) as num?)?.toInt() ?? 0,
      isPassed: (json['isPassed'] ?? json['IsPassed']) as bool? ?? false,
      config: config,
      answerReviews: parseReviews(json['answerReview'] ?? json['AnswerReview']),
    );
  }

  double get accuracyPercent => (correct + wrong) == 0 ? 0 : (correct / (correct + wrong)) * 100;
  String get formattedScore => score.toStringAsFixed(2);
  
  // These are now dynamic from backend but we can keep some UI logic
  String get performanceLabel => isPassed ? 'Passed' : 'Keep Practicing';
  String get performanceEmoji => isPassed ? '🎉' : '💪';
  String get formattedTimeTaken => ""; 
  
  // Backwards compatibility for UI code that might still use 'questions' or 'answers'
  List<MockQuestion> get questions => answerReviews.map((r) => MockQuestion(
    questionId: r.questionId,
    questionText: r.questionText,
    optionA: "", optionB: "", optionC: "", optionD: "", // Options aren't in AnswerReviewDto usually
    orderIndex: 0,
    correctOption: r.correctOption,
    explanation: r.explanation,
  )).toList();
}

class AnswerReview {
  final int questionId;
  final String questionText;
  final int? selectedOption; // 0=A, 1=B, 2=C, 3=D
  final int correctOption;
  final bool isCorrect;
  final String explanation;

  const AnswerReview({
    required this.questionId,
    required this.questionText,
    this.selectedOption,
    required this.correctOption,
    required this.isCorrect,
    required this.explanation,
  });

  factory AnswerReview.fromJson(Map<String, dynamic> json) {
    int? charToIdx(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      final s = value.toString();
      if (s.isEmpty) return null;
      try {
        // If it's a number string "0", "1"...
        final parsed = int.tryParse(s);
        if (parsed != null) return parsed;
        
        // If it's a char "A", "B"...
        return s.toUpperCase().codeUnitAt(0) - 'A'.codeUnitAt(0);
      } catch (e) {
        return null;
      }
    }

    return AnswerReview(
      questionId: ((json['questionId'] ?? json['QuestionId']) as num?)?.toInt() ?? 0,
      questionText: (json['questionText'] ?? json['QuestionText']) as String? ?? '',
      selectedOption: charToIdx(json['selectedOption'] ?? json['SelectedOption']),
      correctOption: charToIdx(json['correctOption'] ?? json['CorrectOption']) ?? 0,
      isCorrect: (json['isCorrect'] ?? json['IsCorrect']) as bool? ?? false,
      explanation: (json['explanation'] ?? json['Explanation']) as String? ?? 'No explanation available.',
    );
  }
}
