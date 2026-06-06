// lib/core/services/mock_test_service.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/mock_question.dart';
import '../models/mock_test_config.dart';
import '../models/mock_test_result.dart';
import 'auth_service.dart';

class MockTestService {
  static const String baseUrl = ApiConfig.rawBaseUrl;

  Map<String, String> get _headers {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    headers.addAll(AuthService().getAuthHeaders());
    return headers;
  }

  Future<List<MockExamCategory>> getCategories() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/v1/exams'), headers: _headers);
      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        return data.map((e) => MockExamCategory.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('Error getCategories: $e');
      return [];
    }
  }

  Future<List<MockTestConfig>> getSubjects(int examId, String examName) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/v1/exams/$examId/mocktests'), headers: _headers);
      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        return data.map((e) => MockTestConfig.fromJson(e, categoryName: examName, examId: examId)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('Error getSubjects: $e');
      return [];
    }
  }

  Future<int> startAttempt(int mockTestId) async {
    final url = Uri.parse('$baseUrl/api/v1/attempts/start');
    try {
      final response = await http.post(
        url,
        headers: _headers,
        body: json.encode({'mockTestId': mockTestId}),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        final id = int.tryParse((data['attemptId'] ?? data['id']).toString());
        if (id == null) throw Exception('No attemptId found');
        return id;
      }
      throw Exception('Server error: ${response.statusCode}');
    } catch (e) {
      debugPrint('Error startAttempt: $e');
      rethrow;
    }
  }

  Future<List<MockSection>> getMockTestDetail(int mockTestId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/v1/mocktests/$mockTestId'), headers: _headers);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List sectionsData = data['sections'] ?? data['Sections'] ?? [];
        return sectionsData.map((s) => MockSection.fromJson(s)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('Error getMockTestDetail: $e');
      return [];
    }
  }

  Future<MockTestResult?> submitAttempt(int attemptId, Map<int, int> userAnswers, Set<int> flagged, List<MockQuestion> allQuestions, MockTestConfig config, {int timeTakenSeconds = 0}) async {
    final url = Uri.parse('$baseUrl/api/v1/attempts/$attemptId/submit');
    try {
      final answersList = allQuestions.asMap().entries.map((entry) {
        final idx = entry.key;
        final selectedIdx = userAnswers[idx];
        return {
          'questionId': entry.value.questionId,
          'selectedOption': selectedIdx == null ? null : String.fromCharCode(65 + selectedIdx),
          'isMarkedForReview': flagged.contains(idx),
        };
      }).toList();

      final response = await http.post(
        url,
        headers: _headers,
        body: json.encode({'attemptId': attemptId, 'answers': answersList}),
      ).timeout(const Duration(seconds: 45));

      debugPrint('Submit Response: ${response.statusCode}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final cleanBody = response.body.replaceAll(RegExp(r'[\x00-\x1F\x7F]'), '');
        final data = json.decode(cleanBody);
        final result = MockTestResult.fromJson(data, config, timeTakenSeconds: timeTakenSeconds);
        debugPrint('Parsed successfully: Score ${result.score}');
        return result;
      }
      return null;
    } catch (e, stack) {
      debugPrint('Critical Error in submitAttempt: $e');
      debugPrint(stack.toString());
      return null;
    }
  }
}
