import 'package:shared_preferences/shared_preferences.dart';
import '../domain/stats_model.dart';

class StatsRepository {
  static const _kTotalGames   = 'stats_total_games';
  static const _kTotalRounds  = 'stats_total_rounds';
  static const _kTotalCorrect = 'stats_total_correct';
  static const _kBestStreak   = 'stats_best_streak';
  static const _kTotalTimeMs  = 'stats_total_time_ms';
  static const _kTotalScore   = 'stats_total_score';

  final SharedPreferences prefs;
  StatsRepository(this.prefs);

  StatsModel read() {
    return StatsModel(
      totalGames: prefs.getInt(_kTotalGames) ?? 0,
      totalRounds: prefs.getInt(_kTotalRounds) ?? 0,
      totalCorrect: prefs.getInt(_kTotalCorrect) ?? 0,
      bestStreak: prefs.getInt(_kBestStreak) ?? 0,
      totalTimeMs: prefs.getInt(_kTotalTimeMs) ?? 0,
      totalScore: prefs.getInt(_kTotalScore) ?? 0,
    );
  }

  Future<void> write(StatsModel m) async {
    await prefs.setInt(_kTotalGames, m.totalGames);
    await prefs.setInt(_kTotalRounds, m.totalRounds);
    await prefs.setInt(_kTotalCorrect, m.totalCorrect);
    await prefs.setInt(_kBestStreak, m.bestStreak);
    await prefs.setInt(_kTotalTimeMs, m.totalTimeMs);
    await prefs.setInt(_kTotalScore, m.totalScore);
  }

  Future<void> reset() async {
    await prefs.remove(_kTotalGames);
    await prefs.remove(_kTotalRounds);
    await prefs.remove(_kTotalCorrect);
    await prefs.remove(_kBestStreak);
    await prefs.remove(_kTotalTimeMs);
    await prefs.remove(_kTotalScore);
  }
}
