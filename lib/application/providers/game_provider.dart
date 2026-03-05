import 'dart:async';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/difficulty.dart';
import '../../domain/models/game_state.dart';
import '../../domain/models/question.dart';
import '../../infrastructure/asset_loader.dart';
import 'audio_provider.dart';

// Tracks whether the correct-answer overlay should be shown
final showOverlayProvider = StateProvider<bool>((ref) => false);

class GameNotifier extends Notifier<GameState?> {
  @override
  GameState? build() => null;

  void initGame(Difficulty difficulty) {
    final rng = Random();
    final allInstruments = List.of(AssetLoader.instruments)..shuffle(rng);

    // Pick 10 correct instruments
    final correctInstruments = allInstruments.take(10).toList();

    final questions = correctInstruments.asMap().entries.map((entry) {
      final index = entry.key;
      final correct = entry.value;

      // Build pool of wrong choices from remaining instruments
      final others = allInstruments.where((i) => i.id != correct.id).toList()
        ..shuffle(rng);
      final wrongChoices = others.take(difficulty.choiceCount - 1).toList();

      final choices = [correct, ...wrongChoices]..shuffle(rng);

      return Question(
        correctInstrument: correct,
        choices: choices,
        questionNumber: index + 1,
      );
    }).toList();

    state = GameState(
      difficulty: difficulty,
      questions: questions,
      currentIndex: 0,
      score: 0,
      wrongIds: const [],
      missCount: 0,
      status: AnswerStatus.unanswered,
    );
  }

  Future<void> answer(String instrumentId) async {
    final current = state;
    if (current == null) return;
    if (current.status != AnswerStatus.unanswered) return;

    final audioService = ref.read(audioServiceProvider);
    final correctId = current.currentQuestion!.correctInstrument.id;

    if (instrumentId == correctId) {
      final points = _pointsForMissCount(current.missCount);
      final newScore = current.score + points;

      // Mark correct
      state = current.copyWith(
        score: newScore,
        status: AnswerStatus.correct,
      );

      // Play correct SE, show overlay, play instrument sound
      await audioService.playCorrectSe();
      ref.read(showOverlayProvider.notifier).state = true;
      await Future.delayed(const Duration(milliseconds: 500));
      await audioService.playAsset(current.currentQuestion!.correctInstrument.soundPath);

      // Wait then advance
      await Future.delayed(const Duration(milliseconds: 1500));
      ref.read(showOverlayProvider.notifier).state = false;
      _advance();
    } else {
      // Wrong answer
      await audioService.playIncorrectSe();
      state = current.copyWith(
        wrongIds: [...current.wrongIds, instrumentId],
        missCount: current.missCount + 1,
      );
    }
  }

  void _advance() {
    final current = state;
    if (current == null) return;

    final nextIndex = current.currentIndex + 1;
    if (nextIndex >= current.questions.length) {
      state = current.copyWith(
        currentIndex: nextIndex,
        status: AnswerStatus.finished,
        missCount: 0,
        wrongIds: const [],
      );
    } else {
      state = current.copyWith(
        currentIndex: nextIndex,
        status: AnswerStatus.unanswered,
        missCount: 0,
        wrongIds: const [],
      );
    }
  }

  int _pointsForMissCount(int missCount) => switch (missCount) {
        0 => 10,
        1 => 7,
        2 => 5,
        _ => 1,
      };
}

final gameProvider = NotifierProvider<GameNotifier, GameState?>(GameNotifier.new);
