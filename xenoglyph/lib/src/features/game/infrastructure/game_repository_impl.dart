import 'dart:math';
import '../../../core/constants.dart';
import '../domain/entities.dart';
import '../domain/game_repository.dart';

class GameRepositoryImpl implements GameRepository {
  static const _alpha = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

  @override
  GameRound nextRound({required Difficulty difficulty, required bool timerEnabled}) {
    final lenByDiff = switch (difficulty) {
      Difficulty.easy   => 3,
      Difficulty.medium => 4,
      Difficulty.hard   => 5,
    };

    
    final symbols = kAlienSymbols.toList()..shuffle(random);
    final letters = _pickUniqueLetters(lenByDiff);

    final symbolToLetter = <String, String>{};
    for (var i = 0; i < lenByDiff; i++) {
      symbolToLetter[symbols[i]] = letters[i];
    }
    final mapping = GlyphMapping(symbolToLetter);

    
    final wordLength = _randIn(3, 6);
    final decoded = List.generate(
      wordLength,
      (_) => letters[random.nextInt(letters.length)],
    ).join();

    final encrypted = mapping.encrypt(decoded);

    
    final opts = <String>{decoded};
    while (opts.length < 4) {
      opts.add(_mutate(decoded, letters));
    }
    final options = opts.toList()..shuffle(random);

    final time = timerEnabled ? defaultTimeFor(difficulty) : 0;

    return GameRound(
      difficulty: difficulty,
      mapping: mapping,
      decodedWord: decoded,
      encryptedWord: encrypted,
      options: options,
      timeLimitSec: time,
    );
  }

  static List<String> _pickUniqueLetters(int n) {
    final pool = _alpha.split('')..shuffle(random);
    return pool.take(n).toList();
  }

  static int _randIn(int a, int b) => a + random.nextInt(b - a + 1);

  static String _mutate(String s, List<String> allowed) {
    if (s.isEmpty) return s;
    final chars = s.split('');
    
    final idx = random.nextInt(chars.length);
    String replacement;
    do {
      replacement = allowed[random.nextInt(allowed.length)];
    } while (replacement == chars[idx]);
    chars[idx] = replacement;

    
    if (chars.length > 2 && random.nextBool()) {
      final i = random.nextInt(chars.length);
      var j = random.nextInt(chars.length);
      if (i == j) j = (j + 1) % chars.length;
      final tmp = chars[i]; chars[i] = chars[j]; chars[j] = tmp;
    }
    return chars.join();
  }
}
