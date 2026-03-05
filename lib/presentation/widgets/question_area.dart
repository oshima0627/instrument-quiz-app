import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/game_provider.dart';
import '../../domain/models/game_state.dart';
import '../../domain/models/question.dart';
import 'answer_button.dart';

class QuestionArea extends ConsumerWidget {
  const QuestionArea({super.key, required this.question, required this.gameState});

  final Question question;
  final GameState gameState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(gameProvider.notifier);
    final isAnswered = gameState.status == AnswerStatus.correct;

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Text(
              'この音の楽器はどれ？',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: question.choices.map((instrument) {
                final isWrong = gameState.wrongIds.contains(instrument.id);
                final isDisabled = isAnswered || isWrong;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: AnswerButton(
                    label: instrument.displayName,
                    isWrong: isWrong,
                    isDisabled: isDisabled,
                    onTap: () => notifier.answer(instrument.id),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
