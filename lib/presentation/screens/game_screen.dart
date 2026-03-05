import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../application/providers/audio_provider.dart';
import '../../application/providers/game_provider.dart';
import '../../domain/models/game_state.dart';
import '../widgets/correct_overlay.dart';
import '../widgets/instrument_list.dart';
import '../widgets/question_area.dart';
import '../widgets/score_display.dart';

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  int? _lastQuestionIndex;

  @override
  void initState() {
    super.initState();
    // Play the first question's instrument sound after build
    WidgetsBinding.instance.addPostFrameCallback((_) => _playCurrentSound());
  }

  void _playCurrentSound() {
    final game = ref.read(gameProvider);
    if (game == null) return;
    final q = game.currentQuestion;
    if (q == null) return;
    ref.read(audioServiceProvider).playAsset(q.correctInstrument.soundPath);
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameProvider);
    final showOverlay = ref.watch(showOverlayProvider);

    if (gameState == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Navigate to result when finished
    if (gameState.status == AnswerStatus.finished) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.go('/result');
      });
    }

    // Auto-play sound when question changes
    final currentIndex = gameState.currentIndex;
    if (_lastQuestionIndex != currentIndex &&
        gameState.status == AnswerStatus.unanswered) {
      _lastQuestionIndex = currentIndex;
      WidgetsBinding.instance.addPostFrameCallback((_) => _playCurrentSound());
    }

    final question = gameState.currentQuestion;
    if (question == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('楽器クイズ'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => context.go('/'),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ScoreDisplay(
                  score: gameState.score,
                  questionNumber: gameState.currentIndex + 1,
                ),
              ),
              Expanded(
                child: OrientationBuilder(
                  builder: (context, orientation) {
                    if (orientation == Orientation.landscape) {
                      return Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: InstrumentList(question: question),
                          ),
                          Expanded(
                            child: QuestionArea(
                              question: question,
                              gameState: gameState,
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.3,
                            child: InstrumentList(question: question),
                          ),
                          Expanded(
                            child: QuestionArea(
                              question: question,
                              gameState: gameState,
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ],
          ),
          if (showOverlay)
            CorrectOverlay(instrument: question.correctInstrument),
        ],
      ),
    );
  }
}
