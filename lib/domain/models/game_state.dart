import 'difficulty.dart';
import 'question.dart';

enum AnswerStatus { unanswered, correct, finished }

class GameState {
  const GameState({
    required this.difficulty,
    required this.questions,
    required this.currentIndex,
    required this.score,
    required this.wrongIds,
    required this.missCount,
    required this.status,
  });

  final Difficulty difficulty;
  final List<Question> questions;
  final int currentIndex;
  final int score;
  final List<String> wrongIds;
  final int missCount;
  final AnswerStatus status;

  Question? get currentQuestion =>
      currentIndex < questions.length ? questions[currentIndex] : null;

  GameState copyWith({
    Difficulty? difficulty,
    List<Question>? questions,
    int? currentIndex,
    int? score,
    List<String>? wrongIds,
    int? missCount,
    AnswerStatus? status,
  }) {
    return GameState(
      difficulty: difficulty ?? this.difficulty,
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      score: score ?? this.score,
      wrongIds: wrongIds ?? this.wrongIds,
      missCount: missCount ?? this.missCount,
      status: status ?? this.status,
    );
  }
}
