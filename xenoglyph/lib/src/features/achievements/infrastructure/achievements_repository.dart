import 'package:shared_preferences/shared_preferences.dart';
import '../domain/achievement.dart';

class AchievementsRepository {
  static const _kUnlocked = 'achievements_unlocked_ids'; 
  static const _kHardSessionCorrect = 'achievements_hard_session_correct'; 

  final SharedPreferences prefs;
  AchievementsRepository(this.prefs);

  Set<AchievementId> readUnlocked() {
    final raw = prefs.getStringList(_kUnlocked) ?? const [];
    return raw.map((s) => AchievementId.values.firstWhere((e) => e.name == s, orElse: () => AchievementId.streak10))
              .toSet();
  }

  Future<void> writeUnlocked(Set<AchievementId> set) async {
    await prefs.setStringList(_kUnlocked, set.map((e) => e.name).toList());
  }

  int readHardSessionCorrect() => prefs.getInt(_kHardSessionCorrect) ?? 0;
  Future<void> writeHardSessionCorrect(int v) async => prefs.setInt(_kHardSessionCorrect, v);
  Future<void> resetHardSessionCorrect() async => prefs.remove(_kHardSessionCorrect);
}
