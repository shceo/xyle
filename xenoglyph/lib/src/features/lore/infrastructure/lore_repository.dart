import 'package:shared_preferences/shared_preferences.dart';
import '../domain/lore_models.dart';

class LoreRepository {
  static const _kUnlockedLore = 'lore_unlocked_ids';
  static const _kQuizPassed = 'quiz_passed_ids';

  final SharedPreferences prefs;
  LoreRepository(this.prefs);

  Set<String> readUnlockedLore() {
    return (prefs.getStringList(_kUnlockedLore) ?? const <String>[]).toSet();
  }

  Future<void> writeUnlockedLore(Set<String> ids) async {
    await prefs.setStringList(_kUnlockedLore, ids.toList());
  }

  Set<String> readQuizPassed() {
    return (prefs.getStringList(_kQuizPassed) ?? const <String>[]).toSet();
  }

  Future<void> writeQuizPassed(Set<String> ids) async {
    await prefs.setStringList(_kQuizPassed, ids.toList());
  }
}
