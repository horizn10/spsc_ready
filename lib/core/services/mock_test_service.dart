// lib/core/services/mock_test_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/mock_question.dart';
import '../models/mock_test_config.dart';
import '../models/mock_test_result.dart';
import 'auth_service.dart';

class MockTestService {
  static const String baseUrl = 'https://192.168.40.200:7241/api/v1';

  Map<String, String> get _headers {
    final headers = {'Content-Type': 'application/json'};
    headers.addAll(AuthService().getAuthHeaders());
    return headers;
  }

  /// 1. Get Exams (Categories)
  Future<List<MockExamCategory>> getCategories() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/exams'), headers: _headers);
      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        return data.map((e) => MockExamCategory.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      print('Error getCategories: $e');
      return [];
    }
  }

  /// 2. Get Mock Tests for an Exam
  Future<List<MockTestConfig>> getSubjects(int examId, String examName) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/exams/$examId/mocktests'), headers: _headers);
      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        return data.map((e) => MockTestConfig.fromJson(e, categoryName: examName, examId: examId)).toList();
      }
      return [];
    } catch (e) {
      print('Error getSubjects: $e');
      return [];
    }
  }

  /// 3. Start an attempt (Returns AttemptId)
  Future<int?> startAttempt(int mockTestId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/attempts/start'),
        headers: _headers,
        body: json.encode({'mockTestId': mockTestId}),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['attemptId'] ?? data['AttemptId']) as int;
      }
      return null;
    } catch (e) {
      print('Error startAttempt: $e');
      return null;
    }
  }

  /// 4. Get Test Detail (Sections & Questions)
  Future<List<MockSection>> getMockTestDetail(int mockTestId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/mocktests/$mockTestId'), headers: _headers);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List sectionsData = data['sections'] ?? data['Sections'] ?? [];
        return sectionsData.map((s) => MockSection.fromJson(s)).toList();
      }
      return [];
    } catch (e) {
      print('Error getMockTestDetail: $e');
      return [];
    }
  }

  /// 5. Submit Attempt
  Future<MockTestResult?> submitAttempt(int attemptId, Map<int, int> userAnswers, Set<int> flagged, List<MockQuestion> allQuestions, MockTestConfig config) async {
    try {
      final answersList = allQuestions.map((q) {
        final selectedIdx = userAnswers[allQuestions.indexOf(q)];
        String? char;
        if (selectedIdx != null) {
          char = String.fromCharCode('A'.codeUnitAt(0) + selectedIdx);
        }
        return {
          'questionId': q.questionId,
          'selectedOption': char,
          'isMarkedForReview': flagged.contains(allQuestions.indexOf(q)),
        };
      }).toList();

      final response = await http.post(
        Uri.parse('$baseUrl/attempts/$attemptId/submit'),
        headers: _headers,
        body: json.encode({
          'attemptId': attemptId,
          'answers': answersList,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return MockTestResult.fromJson(data, config);
      }
      return null;
    } catch (e) {
      print('Error submitAttempt: $e');
      return null;
    }
  }
}
