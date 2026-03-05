import 'package:flutter/material.dart';
import '../../domain/models/instrument.dart';

class CorrectOverlay extends StatefulWidget {
  const CorrectOverlay({super.key, required this.instrument});

  final Instrument instrument;

  @override
  State<CorrectOverlay> createState() => _CorrectOverlayState();
}

class _CorrectOverlayState extends State<CorrectOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    )..forward();
    _scaleAnim = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: ScaleTransition(
          scale: _scaleAnim,
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '正解！',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF43A047),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Image.asset(
                    widget.instrument.imagePath,
                    width: 160,
                    height: 160,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.music_note,
                      size: 160,
                      color: Color(0xFF3F51B5),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.instrument.displayName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
