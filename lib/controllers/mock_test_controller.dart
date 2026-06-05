// lib/controllers/mock_test_controller.dart

import 'dart:async';
import 'package:flutter/material.dart';
import '../core/models/mock_question.dart';
import '../core/models/mock_test_config.dart';
import '../core/models/mock_test_result.dart';
import '../core/services/mock_test_service.dart';

class MockTestController extends ChangeNotifier {
  final MockTestConfig config;
  
  List<MockSection> sections = [];
  List<MockQuestion> questions = []; // Flattened list for the UI
  
  int currentIndex = 0;
  Map<int, int> answers = {}; // questionIndex -> selectedOptionIndex
  Set<int> flagged = {};
  
  int remainingSeconds;
  bool isSubmitted = false;
  bool isLoading = true;
  String? errorMessage;
  int? attemptId;
  
  Timer? _timer;

  MockTestController({required this.config})
      : remainingSeconds = config.durationMinutes * 60;

  int get totalQuestions => questions.length;
  int get answeredCount => answers.length;
  int get unansweredCount => totalQuestions - answeredCount;

  String get timerDisplay {
    final m = remainingSeconds ~/ 60;
    final s = remainingSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  String get timerState {
    if (remainingSeconds < 300) return 'danger';
    if (remainingSeconds < 900) return 'warning';
    return 'normal';
  }

  Future<void> loadAndStart() async {
    isLoading = true;
    notifyListeners();

    try {
      // 1. Start Attempt
      attemptId = await MockTestService().startAttempt(config.testId);

      // 2. Load Questions
      sections = await MockTestService().getMockTestDetail(config.testId);
      questions = sections.expand((s) => s.questions).toList();
      
      if (questions.isEmpty) throw Exception("No questions found for this test");

      isLoading = false;
      notifyListeners();
      _startTimer();
    } catch (e) {
      errorMessage = e.toString().contains("Exception") ? e.toString().replaceFirst("Exception: ", "") : 'Failed to connect to server.';
      isLoading = false;
      notifyListeners();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (remainingSeconds <= 0) {
        _timer?.cancel();
        // Auto submit logic could go here
      } else {
        remainingSeconds--;
        notifyListeners();
      }
    });
  }

  void selectAnswer(int questionIndex, int optionIndex) {
    if (isSubmitted) return;
    answers[questionIndex] = optionIndex;
    notifyListeners();
  }

  void clearAnswer(int questionIndex) {
    if (isSubmitted) return;
    answers.remove(questionIndex);
    notifyListeners();
  }

  void toggleFlag(int questionIndex) {
    if (isSubmitted) return;
    if (flagged.contains(questionIndex)) {
      flagged.remove(questionIndex);
    } else {
      flagged.add(questionIndex);
    }
    notifyListeners();
  }

  void goToQuestion(int index) {
    if (index < 0 || index >= totalQuestions) return;
    currentIndex = index;
    notifyListeners();
  }

  void nextQuestion() => goToQuestion(currentIndex + 1);
  void previousQuestion() => goToQuestion(currentIndex - 1);

  Future<MockTestResult?> submitTest() async {
    _timer?.cancel();
    isSubmitted = true;
    notifyListeners();

    if (attemptId == null) return null;

    final timeTakenSeconds = (config.durationMinutes * 60) - remainingSeconds;

    final result = await MockTestService().submitAttempt(
      attemptId!, 
      answers, 
      flagged, 
      questions,
      config,
      timeTakenSeconds: timeTakenSeconds,
    );
    
    return result;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
