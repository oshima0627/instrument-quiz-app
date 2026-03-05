import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../application/providers/game_provider.dart';
import '../../core/theme/app_theme.dart';

class ResultScreen extends ConsumerStatefulWidget {
  const ResultScreen({super.key});

  @override
  ConsumerState<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends ConsumerState<ResultScreen> {
  int _displayScore = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    final finalScore = ref.read(gameProvider)?.score ?? 0;
    _animateScore(finalScore);
  }

  void _animateScore(int finalScore) {
    const steps = 30;
    final increment = (finalScore / steps).ceil();
    int current = 0;
    _timer = Timer.periodic(const Duration(milliseconds: 40), (timer) {
      current += increment;
      if (current >= finalScore) {
        current = finalScore;
        timer.cancel();
      }
      if (mounted) setState(() => _displayScore = current);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameProvider);
    final score = gameState?.score ?? 0;

    String message;
    Color messageColor;
    if (score == 100) {
      message = '完璧です！';
      messageColor = const Color(0xFFFFD600);
    } else if (score >= 70) {
      message = 'すばらしい！';
      messageColor = AppColors.correct;
    } else if (score >= 40) {
      message = 'よくできました！';
      messageColor = AppColors.primary;
    } else {
      message = 'もう少し練習しよう！';
      messageColor = Colors.orange;
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Congratulations!',
                  style: GoogleFonts.notoSansJp(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  style: GoogleFonts.notoSansJp(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: messageColor,
                  ),
                ),
                const SizedBox(height: 40),
                _ScoreCircle(displayScore: _displayScore),
                const SizedBox(height: 12),
                Text(
                  '/ 100点',
                  style: const TextStyle(fontSize: 20, color: Colors.black54),
                ),
                const SizedBox(height: 48),
                ElevatedButton.icon(
                  icon: const Icon(Icons.replay),
                  label: const Text('もう一度遊ぶ'),
                  onPressed: () => context.go('/'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ScoreCircle extends StatelessWidget {
  const _ScoreCircle({required this.displayScore});
  final int displayScore;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 160,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Center(
        child: Text(
          '$displayScore',
          style: const TextStyle(
            fontSize: 56,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
