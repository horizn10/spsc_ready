// lib/core/models/mock_test_config.dart

/// Configuration model for a Mock Test.
class MockTestConfig {
  final int testId;
  final String examName;
  final String paperType;
  final int questionCount;
  final int durationMinutes;
  final double marksPerQuestion;
  final double negativeMarks;
  final bool isAttempted;
  final double? bestScore;

  const MockTestConfig({
    required this.testId,
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
        examName: 'Sub Inspector Combined Competitive Exam',
        paperType: 'Paper I',
        isAttempted: true,
        bestScore: 85.5,
      ),
      MockTestConfig(
        testId: 2,
        examName: 'Assistant Commissioner (ASF) Exam',
        paperType: 'Paper II',
        isAttempted: false,
      ),
      MockTestConfig(
        testId: 3,
        examName: 'Senior Auditor (Finance) Screening',
        paperType: 'General Knowledge',
        isAttempted: false,
      ),
    ];
  }
}
