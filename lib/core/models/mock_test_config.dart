// lib/core/models/mock_test_config.dart

/// Configuration model for a Mock Test (Maps to MockTestDto in Backend).
class MockTestConfig {
  final int testId;
  final String categoryName; // Maps to ExamName from ExamDto
  final int examId; // Added to match backend
  final String examName; // Maps to Title in MockTestDto
  final String paperType;
  final int questionCount;
  final int durationMinutes;
  final int totalMarks;
  final double? passingMarks;
  final bool isAttempted; // We'll keep this for UI logic

  const MockTestConfig({
    required this.testId,
    required this.categoryName,
    required this.examId,
    required this.examName,
    required this.paperType,
    required this.questionCount,
    required this.durationMinutes,
    required this.totalMarks,
    this.passingMarks,
    this.isAttempted = false,
  });

  factory MockTestConfig.fromJson(Map<String, dynamic> json, {String categoryName = '', int examId = 0}) {
    return MockTestConfig(
      testId: (json['mockTestId'] ?? json['MockTestId']) as int,
      categoryName: categoryName,
      examId: examId,
      examName: (json['title'] ?? json['Title']) as String? ?? 'Unnamed Test',
      paperType: (json['paperType'] ?? json['PaperType']) as String? ?? 'MCQ',
      questionCount: ((json['totalQuestions'] ?? json['TotalQuestions']) as num?)?.toInt() ?? 0,
      durationMinutes: (json['durationMinutes'] ?? json['DurationMinutes']) as int? ?? 0,
      totalMarks: ((json['totalMarks'] ?? json['TotalMarks']) as num?)?.toInt() ?? 0,
      passingMarks: ((json['passingMarks'] ?? json['PassingMarks']) as num?)?.toDouble(),
      isAttempted: false, // Updated by service if needed
    );
  }

  static List<MockTestConfig> dummyList() {
    return [];
  }
}

/// Simple model for Tier 1 Categories (Maps to ExamDto in Backend)
class MockExamCategory {
  final int id;
  final String name;
  final String code;
  final int year;
  final String description;
  final int availableTests; // Calculated or from another source

  const MockExamCategory({
    required this.id,
    required this.name,
    required this.code,
    required this.year,
    required this.description,
    this.availableTests = 0,
  });

  factory MockExamCategory.fromJson(Map<String, dynamic> json) {
    return MockExamCategory(
      id: (json['examId'] ?? json['ExamId']) as int,
      name: (json['examName'] ?? json['ExamName']) as String? ?? '',
      code: (json['examCode'] ?? json['ExamCode']) as String? ?? '',
      year: (json['examYear'] ?? json['ExamYear']) as int? ?? DateTime.now().year,
      description: (json['description'] ?? json['Description']) as String? ?? '',
      availableTests: 0,
    );
  }

  static List<MockExamCategory> dummyList() {
    return [];
  }
}
