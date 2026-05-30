// lib/core/models/mock_question.dart

/// Model representing a single question in a Mock Test (Maps to QuestionDto in Backend).
class MockQuestion {
  final int questionId;
  final String questionText;
  final String? imageUrl;
  final String optionA;
  final String optionB;
  final String optionC;
  final String optionD;
  final int orderIndex;
  
  // These might be null during the test if the API follows security best practices
  final int? correctOption; // 0=A, 1=B, 2=C, 3=D
  final String? explanation;

  const MockQuestion({
    required this.questionId,
    required this.questionText,
    this.imageUrl,
    required this.optionA,
    required this.optionB,
    required this.optionC,
    required this.optionD,
    required this.orderIndex,
    this.correctOption,
    this.explanation,
  });

  factory MockQuestion.fromJson(Map<String, dynamic> json) {
    return MockQuestion(
      questionId: (json['questionId'] ?? json['QuestionId']) as int,
      questionText: (json['questionText'] ?? json['QuestionText']) as String? ?? '',
      imageUrl: (json['imageUrl'] ?? json['ImageUrl']) as String?,
      optionA: (json['optionA'] ?? json['OptionA']) as String? ?? '',
      optionB: (json['optionB'] ?? json['OptionB']) as String? ?? '',
      optionC: (json['optionC'] ?? json['OptionC']) as String? ?? '',
      optionD: (json['optionD'] ?? json['OptionD']) as String? ?? '',
      orderIndex: (json['orderIndex'] ?? json['OrderIndex']) as int? ?? 0,
    );
  }

  static List<MockQuestion> dummyList(int count) => [];
}

/// Model representing a section in a Mock Test (Maps to SectionWithQuestionsDto).
class MockSection {
  final int sectionId;
  final String sectionName;
  final double marksPerQuestion;
  final double negativeMarks;
  final List<MockQuestion> questions;

  const MockSection({
    required this.sectionId,
    required this.sectionName,
    required this.marksPerQuestion,
    required this.negativeMarks,
    required this.questions,
  });

  factory MockSection.fromJson(Map<String, dynamic> json) {
    return MockSection(
      sectionId: (json['sectionId'] ?? json['SectionId']) as int,
      sectionName: (json['sectionName'] ?? json['SectionName']) as String? ?? '',
      marksPerQuestion: ((json['marksPerQuestion'] ?? json['MarksPerQuestion']) as num?)?.toDouble() ?? 1.0,
      negativeMarks: ((json['negativeMarks'] ?? json['NegativeMarks']) as num?)?.toDouble() ?? 0.25,
      questions: ((json['questions'] ?? json['Questions']) as List? ?? [])
          .map((q) => MockQuestion.fromJson(q))
          .toList(),
    );
  }
}
