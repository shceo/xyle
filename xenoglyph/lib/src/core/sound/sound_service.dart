import 'package:audioplayers/audioplayers.dart';






class SoundService {
  bool _muted = false;

  final AudioPlayer _correct = AudioPlayer();
  final AudioPlayer _incorrect = AudioPlayer();
  final AudioPlayer _tick = AudioPlayer();

  
  Future<void> init() async {
    
    await _correct.setReleaseMode(ReleaseMode.stop);
    await _incorrect.setReleaseMode(ReleaseMode.stop);
    await _tick.setReleaseMode(ReleaseMode.stop);

    
    await _correct.setVolume(1.0);
    await _incorrect.setVolume(1.0);
    await _tick.setVolume(0.9);
  }

  void setMuted(bool value) {
    _muted = value;
  }

  Future<void> playCorrect() async {
    if (_muted) return;
    try {
      await _correct.stop(); 
      await _correct.play(AssetSource('sound/correct.mp3'));
    } catch (_) {}
  }

  Future<void> playIncorrect() async {
    if (_muted) return;
    try {
      await _incorrect.stop();
      await _incorrect.play(AssetSource('sound/incorrect.mp3'));
    } catch (_) {}
  }

  
  Future<void> playTick() async {
    if (_muted) return;
    try {
      await _tick.stop();
      await _tick.play(AssetSource('sound/ticking.mp3'));
    } catch (_) {}
  }

  Future<void> dispose() async {
    try {
      await _correct.dispose();
      await _incorrect.dispose();
      await _tick.dispose();
    } catch (_) {}
  }
}
