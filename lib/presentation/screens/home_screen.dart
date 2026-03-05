import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../application/providers/game_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/models/difficulty.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.music_note, size: 80, color: AppColors.primary),
                const SizedBox(height: 16),
                Text(
                  '楽器クイズ',
                  style: GoogleFonts.notoSansJp(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '音を聴いて楽器名を当てよう！',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 48),
                const Text(
                  '難易度を選んでください',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 24),
                _DifficultyButton(
                  label: 'かんたん（2択）',
                  difficulty: Difficulty.easy,
                  color: const Color(0xFF43A047),
                  ref: ref,
                ),
                const SizedBox(height: 12),
                _DifficultyButton(
                  label: 'ふつう（3択）',
                  difficulty: Difficulty.normal,
                  color: AppColors.primary,
                  ref: ref,
                ),
                const SizedBox(height: 12),
                _DifficultyButton(
                  label: 'むずかしい（4択）',
                  difficulty: Difficulty.hard,
                  color: const Color(0xFFE53935),
                  ref: ref,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DifficultyButton extends StatelessWidget {
  const _DifficultyButton({
    required this.label,
    required this.difficulty,
    required this.color,
    required this.ref,
  });

  final String label;
  final Difficulty difficulty;
  final Color color;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          ref.read(gameProvider.notifier).initGame(difficulty);
          context.go('/game');
        },
        child: Text(label),
      ),
    );
  }
}
