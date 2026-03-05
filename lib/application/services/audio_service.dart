import 'package:just_audio/just_audio.dart';

class AudioService {
  final AudioPlayer _player = AudioPlayer();

  static const String correctSePath = 'assets/sounds/se/correct.mp3';
  static const String incorrectSePath = 'assets/sounds/se/incorrect.mp3';

  Future<void> playAsset(String assetPath) async {
    try {
      await _player.stop();
      await _player.setAsset(assetPath);
      await _player.play();
    } catch (e) {
      // ignore playback errors (e.g., missing asset during dev)
    }
  }

  Future<void> playCorrectSe() => playAsset(correctSePath);
  Future<void> playIncorrectSe() => playAsset(incorrectSePath);

  Future<void> stop() async {
    try {
      await _player.stop();
    } catch (_) {}
  }

  void dispose() {
    _player.dispose();
  }
}
