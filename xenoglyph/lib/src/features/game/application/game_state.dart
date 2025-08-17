part of 'game_bloc.dart';

enum RoundStatus { playing, correct, incorrect }

class GameState extends Equatable {
  final GameMode mode;
  final Difficulty difficulty;
  final int score;
  final int streak;
  final bool isPaused;
  final GameRound? round;
  final int? timeLeft;
  final RoundStatus status;
  final bool? lastChoiceCorrect;

  const GameState({
    required this.mode,
    required this.difficulty,
    required this.score,
    required this.streak,
    required this.isPaused,
    required this.round,
    required this.timeLeft,
    required this.status,
    required this.lastChoiceCorrect,
  });

  const GameState.initial()
      : mode = GameMode.timed,
        difficulty = Difficulty.easy,
        score = 0,
        streak = 0,
        isPaused = false,
        round = null,
        timeLeft = null,
        status = RoundStatus.playing,
        lastChoiceCorrect = null;

  GameState copyWith({
    GameMode? mode,
    Difficulty? difficulty,
    int? score,
    int? streak,
    bool? isPaused,
    GameRound? round,
    int? timeLeft,
    RoundStatus? status,
    bool? lastChoiceCorrect,
  }) {
    return GameState(
      mode: mode ?? this.mode,
      difficulty: difficulty ?? this.difficulty,
      score: score ?? this.score,
      streak: streak ?? this.streak,
      isPaused: isPaused ?? this.isPaused,
      round: round ?? this.round,
      timeLeft: timeLeft ?? this.timeLeft,
      status: status ?? this.status,
      lastChoiceCorrect: lastChoiceCorrect ?? this.lastChoiceCorrect,
    );
  }

  @override
  List<Object?> get props => [mode, difficulty, score, streak, isPaused, round, timeLeft, status, lastChoiceCorrect];
}
