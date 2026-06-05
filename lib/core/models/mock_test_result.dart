// lib/core/models/mock_test_result.dart

import 'package:flutter/foundation.dart';
import 'mock_question.dart';
import 'mock_test_config.dart';

class _Parser {
  static double toDouble(dynamic val) {
    if (val is num) return val.toDouble();
    if (val is String) return double.tryParse(val) ?? 0.0;
    return 0.0;
  }

  static int toInt(dynamic val) {
    if (val is num) return val.toInt();
    if (val is String) return int.tryParse(val) ?? 0;
    return 0;
  }

  static bool toBool(dynamic val) {
    if (val is bool) return val;
    if (val is num) return val == 1;
    if (val is String) return val.toLowerCase() == 'true';
    return false;
  }
}

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
  final MockTestConfig config;
  final int timeTakenSeconds; // Added this

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
    this.timeTakenSeconds = 0, // Default to 0
  });

  factory MockTestResult.fromJson(Map<String, dynamic> json, MockTestConfig config, {int timeTakenSeconds = 0}) {
    List<AnswerReview> parseReviews(dynamic data) {
      if (data == null || data is! List) return [];
      return data.map((r) {
        try {
          return AnswerReview.fromJson(r as Map<String, dynamic>);
        } catch (e) {
          debugPrint('Error parsing Review Item: $e');
          return null;
        }
      }).whereType<AnswerReview>().toList();
    }

    return MockTestResult(
      attemptId: _Parser.toInt(json['attemptId'] ?? json['AttemptId']),
      mockTestTitle: (json['mockTestTitle'] ?? json['MockTestTitle'])?.toString() ?? '',
      score: _Parser.toDouble(json['totalScore'] ?? json['TotalScore']),
      totalMarks: _Parser.toInt(json['totalMarks'] ?? json['TotalMarks']),
      percentage: _Parser.toDouble(json['percentage'] ?? json['Percentage']),
      correct: _Parser.toInt(json['correctCount'] ?? json['CorrectCount']),
      wrong: _Parser.toInt(json['wrongCount'] ?? json['WrongCount']),
      unanswered: _Parser.toInt(json['skippedCount'] ?? json['SkippedCount']),
      isPassed: _Parser.toBool(json['isPassed'] ?? json['IsPassed']),
      config: config,
      answerReviews: parseReviews(json['answerReview'] ?? json['AnswerReview']),
      timeTakenSeconds: timeTakenSeconds,
    );
  }

  double get accuracyPercent => (correct + wrong) == 0 ? 0 : (correct / (correct + wrong)) * 100;
  String get formattedScore => score.toStringAsFixed(2);
  String get performanceLabel => isPassed ? 'Passed' : 'Keep Practicing';
  String get performanceEmoji => isPassed ? '🎉' : '💪';
  
  String get formattedTimeTaken {
    final m = timeTakenSeconds ~/ 60;
    final s = timeTakenSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  List<MockQuestion> get questions => answerReviews.map((r) => MockQuestion(
    questionId: r.questionId,
    questionText: r.questionText,
    optionA: "", optionB: "", optionC: "", optionD: "",
    orderIndex: 0,
    correctOption: r.correctOption,
    explanation: r.explanation,
  )).toList();
}

class AnswerReview {
  final int questionId;
  final String questionText;
  final int? selectedOption;
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
      final s = value.toString().trim();
      if (s.isEmpty) return null;
      final parsed = int.tryParse(s);
      if (parsed != null) return parsed;
      if (s.length == 1) {
        final code = s.toUpperCase().codeUnitAt(0);
        if (code >= 65 && code <= 90) return code - 65;
      }
      return null;
    }

    return AnswerReview(
      questionId: _Parser.toInt(json['questionId'] ?? json['QuestionId']),
      questionText: (json['questionText'] ?? json['QuestionText'])?.toString() ?? '',
      selectedOption: charToIdx(json['selectedOption'] ?? json['SelectedOption']),
      correctOption: charToIdx(json['correctOption'] ?? json['CorrectOption']) ?? 0,
      isCorrect: _Parser.toBool(json['isCorrect'] ?? json['IsCorrect']),
      explanation: (json['explanation'] ?? json['Explanation'])?.toString() ?? 'No explanation available.',
    );
  }
}
