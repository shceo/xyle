import '../../../core/constants.dart';

class GlyphMapping {
  final Map<String, String> symbolToLetter; 
  const GlyphMapping(this.symbolToLetter);

  String encrypt(String decoded) {
    final reverse = {for (var e in symbolToLetter.entries) e.value: e.key};
    return decoded.split('').map((ch) => reverse[ch] ?? '?').join();
  }
}

class GameRound {
  final Difficulty difficulty;
  final GlyphMapping mapping;
  final String decodedWord;   
  final String encryptedWord; 
  final List<String> options; 
  final int timeLimitSec;    

  const GameRound({
    required this.difficulty,
    required this.mapping,
    required this.decodedWord,
    required this.encryptedWord,
    required this.options,
    required this.timeLimitSec,
  });
}
