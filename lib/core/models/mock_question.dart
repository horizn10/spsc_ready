// lib/core/models/mock_question.dart

/// Model representing a single question in a Mock Test.
class MockQuestion {
  final int questionId;
  final String questionText;
  final String? imageUrl;
  final String optionA;
  final String optionB;
  final String optionC;
  final String optionD;
  final int correctOption; // 0=A, 1=B, 2=C, 3=D
  final String explanation;
  final double marks;
  final double negativeMarks;

  const MockQuestion({
    required this.questionId,
    required this.questionText,
    this.imageUrl,
    required this.optionA,
    required this.optionB,
    required this.optionC,
    required this.optionD,
    required this.correctOption,
    required this.explanation,
    this.marks = 1.0,
    this.negativeMarks = 0.25,
  });

  /// Creates a [MockQuestion] from a JSON map.
  factory MockQuestion.fromJson(Map<String, dynamic> json) {
    return MockQuestion(
      questionId: json['questionId'] as int,
      questionText: json['questionText'] as String,
      imageUrl: json['imageUrl'] as String?,
      optionA: json['optionA'] as String,
      optionB: json['optionB'] as String,
      optionC: json['optionC'] as String,
      optionD: json['optionD'] as String,
      correctOption: json['correctOption'] as int,
      explanation: json['explanation'] as String,
      marks: (json['marks'] as num?)?.toDouble() ?? 1.0,
      negativeMarks: (json['negativeMarks'] as num?)?.toDouble() ?? 0.25,
    );
  }
}
