// lib/core/models/mock_test_config.dart

/// Configuration model for a Mock Test.
class MockTestConfig {
  final int testId;
  final String categoryName; // E.g., "Sub Inspector"
  final String examName; // E.g., "Paper I" or "General Knowledge"
  final String paperType; // Label like "MCQ", "Subjective"
  final int questionCount;
  final int durationMinutes;
  final double marksPerQuestion;
  final double negativeMarks;
  final bool isAttempted;
  final double? bestScore;

  const MockTestConfig({
    required this.testId,
    required this.categoryName,
    required this.examName,
    required this.paperType,
    this.questionCount = 100,
    this.durationMinutes = 90,
    this.marksPerQuestion = 1.0,
    this.negativeMarks = 0.25,
    required this.isAttempted,
    this.bestScore,
  });

  /// Creates a [MockTestConfig] from a JSON map.
  factory MockTestConfig.fromJson(Map<String, dynamic> json) {
    return MockTestConfig(
      testId: json['testId'] as int,
      categoryName: json['categoryName'] as String? ?? 'General',
      examName: json['examName'] as String,
      paperType: json['paperType'] as String,
      questionCount: json['questionCount'] as int? ?? 100,
      durationMinutes: json['durationMinutes'] as int? ?? 90,
      marksPerQuestion: (json['marksPerQuestion'] as num?)?.toDouble() ?? 1.0,
      negativeMarks: (json['negativeMarks'] as num?)?.toDouble() ?? 0.25,
      isAttempted: json['isAttempted'] as bool? ?? false,
      bestScore: (json['bestScore'] as num?)?.toDouble(),
    );
  }

  /// Returns a list of dummy [MockTestConfig] objects for UI testing.
  static List<MockTestConfig> dummyList() {
    return const [
      MockTestConfig(
        testId: 1,
        categoryName: 'Sub Inspector',
        examName: 'General Knowledge',
        paperType: 'Paper I',
        questionCount: 50,
        durationMinutes: 60,
        isAttempted: true,
        bestScore: 42.5,
      ),
      MockTestConfig(
        testId: 2,
        categoryName: 'Sub Inspector',
        examName: 'English & Urdu',
        paperType: 'Paper II',
        questionCount: 100,
        durationMinutes: 90,
        isAttempted: false,
      ),
      MockTestConfig(
        testId: 3,
        categoryName: 'Asst. Commissioner',
        examName: 'Current Affairs',
        paperType: 'Paper I',
        questionCount: 50,
        durationMinutes: 45,
        isAttempted: false,
      ),
      MockTestConfig(
        testId: 4,
        categoryName: 'Asst. Commissioner',
        examName: 'Pakistan Studies',
        paperType: 'Paper II',
        questionCount: 50,
        durationMinutes: 45,
        isAttempted: false,
      ),
      MockTestConfig(
        testId: 5,
        categoryName: 'Senior Auditor',
        examName: 'Accounting & Audit',
        paperType: 'Core Subject',
        questionCount: 100,
        durationMinutes: 120,
        isAttempted: false,
      ),
    ];
  }
}

/// Simple model for Tier 1 Categories
class MockExamCategory {
  final String name;
  final String description;
  final int availableTests;
  final String icon;

  const MockExamCategory({
    required this.name,
    required this.description,
    required this.availableTests,
    required this.icon,
  });

  static List<MockExamCategory> dummyList() {
    return const [
      MockExamCategory(
        name: 'Sub Inspector',
        description: 'Police Department Competitive Exam',
        availableTests: 12,
        icon: '👮',
      ),
      MockExamCategory(
        name: 'Asst. Commissioner',
        description: 'Combined Competitive Examination',
        availableTests: 8,
        icon: '🏛️',
      ),
      MockExamCategory(
        name: 'Senior Auditor',
        description: 'Finance & Audit Department',
        availableTests: 5,
        icon: '📊',
      ),
    ];
  }
}
