import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/stats_model.dart';
import '../infrastructure/stats_repository.dart';
import '../../../core/constants.dart';

class StatsCubit extends Cubit<StatsModel> {
  final StatsRepository repo;
  StatsCubit(this.repo) : super(StatsModel.empty()) {
    load();
  }

  void load() {
    emit(repo.read());
  }

  // начало новой игры
  Future<StatsModel> trackGameStarted() async {
    final next = state.copyWith(totalGames: state.totalGames + 1);
    emit(next);
    await repo.write(next);
    return next;
  }

  // завершение одного раунда
  // timeMs - фактическое время ответа (или дожидание таймера), scoreDelta - добавленные очки
  Future<StatsModel> trackRound({
    required int timeMs,
    required bool correct,
    required int streakAfter,
    required int scoreDelta,
    required Difficulty difficulty,
  }) async {
    final totalRounds = state.totalRounds + 1;
    final totalCorrect = state.totalCorrect + (correct ? 1 : 0);
    final bestStreak = streakAfter > state.bestStreak ? streakAfter : state.bestStreak;
    final totalTimeMs = state.totalTimeMs + (timeMs < 0 ? 0 : timeMs);
    final totalScore = state.totalScore + (scoreDelta > 0 ? scoreDelta : 0);

    final next = state.copyWith(
      totalRounds: totalRounds,
      totalCorrect: totalCorrect,
      bestStreak: bestStreak,
      totalTimeMs: totalTimeMs,
      totalScore: totalScore,
    );
    emit(next);
    await repo.write(next);
    return next;
  }

  Future<void> resetAll() async {
    await repo.reset();
    emit(StatsModel.empty());
  }
}
