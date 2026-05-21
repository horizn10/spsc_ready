// lib/controllers/mock_test_controller.dart

import 'dart:async';
import 'package:flutter/material.dart';
import '../core/models/mock_question.dart';
import '../core/models/mock_test_config.dart';
import '../core/models/mock_test_result.dart';
import '../core/services/mock_test_service.dart';

/// Controller that manages the state of an active mock test session.
class MockTestController extends ChangeNotifier {
  /// The configuration for the current test.
  final MockTestConfig config;
  
  /// List of questions loaded for the test.
  List<MockQuestion> questions = [];
  
  /// The index of the currently displayed question (0-based).
  int currentIndex = 0;
  
  /// Map of questionIndex to selectedOptionIndex (0=A, 1=B, 2=C, 3=D).
  Map<int, int> answers = {};
  
  /// Set of indices of questions that have been flagged by the user.
  Set<int> flagged = {};
  
  /// Remaining time in seconds.
  int remainingSeconds;
  
  /// Whether the test has been submitted.
  bool isSubmitted = false;
  
  /// Whether questions are currently being loaded.
  bool isLoading = true;
  
  /// Error message if loading fails.
  String? errorMessage;
  
  Timer? _timer;

  MockTestController({required this.config})
      : remainingSeconds = config.durationMinutes * 60;

  int get totalQuestions => questions.length;
  int get answeredCount => answers.length;
  int get flaggedCount => flagged.length;
  int get unansweredCount => totalQuestions - answeredCount;
  bool get isLastQuestion => currentIndex == totalQuestions - 1;
  bool get isFirstQuestion => currentIndex == 0;

  /// Returns the remaining time formatted as MM:SS.
  String get timerDisplay {
    final m = remainingSeconds ~/ 60;
    final s = remainingSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  /// Returns the state of the timer for color coding.
  String get timerState {
    if (remainingSeconds < 300) return 'danger';
    if (remainingSeconds < 900) return 'warning';
    return 'normal';
  }

  /// Loads questions from [MockTestService] and starts the countdown.
  Future<void> loadAndStart() async {
    isLoading = true;
    notifyListeners();

    try {
      questions = await MockTestService().getQuestions(config.testId);
      if (questions.isEmpty) {
        questions = MockQuestion.dummyList(100);
      }
      isLoading = false;
      notifyListeners();
      _startTimer();
    } catch (e) {
      errorMessage = 'Failed to load questions. Please try again.';
      isLoading = false;
      notifyListeners();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (remainingSeconds <= 0) {
        _timer?.cancel();
        submitTest(autoSubmit: true);
      } else {
        remainingSeconds--;
        notifyListeners();
      }
    });
  }

  /// Selects an answer for the given [questionIndex].
  void selectAnswer(int questionIndex, int optionIndex) {
    if (isSubmitted) return;
    answers[questionIndex] = optionIndex;
    notifyListeners();
  }

  /// Clears the selected answer for the given [questionIndex].
  void clearAnswer(int questionIndex) {
    if (isSubmitted) return;
    answers.remove(questionIndex);
    notifyListeners();
  }

  /// Toggles the flagged status for the given [questionIndex].
  void toggleFlag(int questionIndex) {
    if (isSubmitted) return;
    if (flagged.contains(questionIndex)) {
      flagged.remove(questionIndex);
    } else {
      flagged.add(questionIndex);
    }
    notifyListeners();
  }

  /// Navigates to the question at the specified [index].
  void goToQuestion(int index) {
    if (index < 0 || index >= totalQuestions) return;
    currentIndex = index;
    notifyListeners();
  }

  /// Navigates to the next question.
  void nextQuestion() => goToQuestion(currentIndex + 1);
  
  /// Navigates to the previous question.
  void previousQuestion() => goToQuestion(currentIndex - 1);

  /// Finalizes the test and calculates results.
  MockTestResult submitTest({bool autoSubmit = false}) {
    _timer?.cancel();
    isSubmitted = true;

    int correct = 0;
    int wrong = 0;
    int unanswered = 0;

    for (int i = 0; i < questions.length; i++) {
      if (!answers.containsKey(i)) {
        unanswered++;
      } else if (answers[i] == questions[i].correctOption) {
        correct++;
      } else {
        wrong++;
      }
    }

    final totalMarks = questions.isNotEmpty ? questions[0].marks : 1.0;
    final negMarks = questions.isNotEmpty ? questions[0].negativeMarks : 0.25;
    final score = (correct * totalMarks) - (wrong * negMarks);
    final maxScore = (questions.length * totalMarks);
    final timeTaken = (config.durationMinutes * 60) - remainingSeconds;

    notifyListeners();

    return MockTestResult(
      config: config,
      questions: questions,
      answers: Map.from(answers),
      correct: correct,
      wrong: wrong,
      unanswered: unanswered,
      score: score,
      maxScore: maxScore,
      timeTakenSeconds: timeTaken,
      autoSubmitted: autoSubmit,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
