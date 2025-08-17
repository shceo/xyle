class StatsModel {
  final int totalGames;
  final int totalRounds;
  final int totalCorrect;
  final int bestStreak;
  final int totalTimeMs; 
  final int totalScore;

  const StatsModel({
    required this.totalGames,
    required this.totalRounds,
    required this.totalCorrect,
    required this.bestStreak,
    required this.totalTimeMs,
    required this.totalScore,
  });

  double get accuracy => totalRounds == 0 ? 0 : (totalCorrect / totalRounds);
  double get avgTimePerAnswerSec =>
      totalRounds == 0 ? 0 : (totalTimeMs / totalRounds) / 1000.0;

  StatsModel copyWith({
    int? totalGames,
    int? totalRounds,
    int? totalCorrect,
    int? bestStreak,
    int? totalTimeMs,
    int? totalScore,
  }) {
    return StatsModel(
      totalGames: totalGames ?? this.totalGames,
      totalRounds: totalRounds ?? this.totalRounds,
      totalCorrect: totalCorrect ?? this.totalCorrect,
      bestStreak: bestStreak ?? this.bestStreak,
      totalTimeMs: totalTimeMs ?? this.totalTimeMs,
      totalScore: totalScore ?? this.totalScore,
    );
  }

  factory StatsModel.empty() => const StatsModel(
        totalGames: 0,
        totalRounds: 0,
        totalCorrect: 0,
        bestStreak: 0,
        totalTimeMs: 0,
        totalScore: 0,
      );
}
