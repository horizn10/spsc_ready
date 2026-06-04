// lib/core/services/mock_test_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/mock_question.dart';
import '../models/mock_test_config.dart';
import '../models/mock_test_result.dart';
import 'auth_service.dart';

class MockTestService {
  static const String baseUrl = 'https://192.168.40.200:7241';

  Map<String, String> get _headers {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    headers.addAll(AuthService().getAuthHeaders());
    return headers;
  }

  /// 1. Get Exams (Categories)
  Future<List<MockExamCategory>> getCategories() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/v1/exams'), headers: _headers);
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
      final response = await http.get(Uri.parse('$baseUrl/api/v1/exams/$examId/mocktests'), headers: _headers);
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
  Future<int> startAttempt(int mockTestId) async {
    final url = Uri.parse('$baseUrl/api/v1/attempts/start');
    try {
      print('Starting attempt for mockTestId: $mockTestId at $url');
      
      final response = await http.post(
        url,
        headers: _headers,
        body: json.encode({'mockTestId': mockTestId}),
      ).timeout(const Duration(seconds: 15));

      print('StartAttempt Response Status: ${response.statusCode}');
      print('StartAttempt Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final dynamic data = json.decode(response.body);
        dynamic rawId;
        
        if (data is Map) {
          rawId = data['attemptId'] ?? data['AttemptId'] ?? data['id'] ?? data['Id'];
        } else {
          rawId = data;
        }
        
        if (rawId == null) {
          throw Exception('Server responded successfully but no attemptId was found in body: ${response.body}');
        }
        
        final id = int.tryParse(rawId.toString());
        if (id == null) {
          throw Exception('Invalid attemptId format received: $rawId');
        }
        return id;
      } else {
        throw Exception('Server error (${response.statusCode}): ${response.body}');
      }
    } catch (e) {
      print('Error startAttempt: $e');
      if (e is Exception) rethrow;
      throw Exception('Failed to start attempt: $e');
    }
  }

  /// 4. Get Test Detail (Sections & Questions)
  Future<List<MockSection>> getMockTestDetail(int mockTestId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/v1/mocktests/$mockTestId'), headers: _headers);
      
      print('MockTest API Response Status: ${response.statusCode}');
      print('MockTest API Response Body: ${response.body}');

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
    final url = Uri.parse('$baseUrl/api/v1/attempts/$attemptId/submit');
    try {
      print('Submitting attempt $attemptId to $url');
      final answersList = allQuestions.asMap().entries.map((entry) {
        final idx = entry.key;
        final q = entry.value;
        final selectedIdx = userAnswers[idx];
        String? char;
        if (selectedIdx != null) {
          char = String.fromCharCode('A'.codeUnitAt(0) + selectedIdx);
        }
        return {
          'questionId': q.questionId,
          'selectedOption': char,
          'isMarkedForReview': flagged.contains(idx),
        };
      }).toList();

      final requestBody = json.encode({
        'attemptId': attemptId,
        'answers': answersList,
      });

      final response = await http.post(
        url,
        headers: _headers,
        body: requestBody,
      ).timeout(const Duration(seconds: 30));

      print('SubmitAttempt Response Status: ${response.statusCode}');
      print('SubmitAttempt Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        try {
          return MockTestResult.fromJson(data, config);
        } catch (e, stack) {
          print('Error parsing MockTestResult: $e');
          print(stack);
          return null;
        }
      } else {
        print('Submit Error (${response.statusCode}): ${response.body}');
        return null;
      }
    } catch (e, stack) {
      print('Error submitAttempt: $e');
      print(stack);
      return null;
    }
  }
}
