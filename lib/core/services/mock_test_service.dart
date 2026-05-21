// lib/core/services/mock_test_service.dart

import '../models/mock_question.dart';

/// Service responsible for fetching mock test questions.
class MockTestService {
  /// Fetches questions for a specific [testId].
  Future<List<MockQuestion>> getQuestions(int testId) async {
    // TODO: replace with real API call in backend integration phase
    await Future.delayed(const Duration(milliseconds: 800));   // simulate network
    return MockQuestion.dummyList(100);
  }
}
