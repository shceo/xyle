import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/achievement.dart';
import '../infrastructure/achievements_repository.dart';
import '../../../core/constants.dart';

class AchievementsState {
  final List<Achievement> all;
  const AchievementsState(this.all);
}

class AchievementsCubit extends Cubit<AchievementsState> {
  final AchievementsRepository repo;
  AchievementsCubit(this.repo) : super(AchievementsState(defaultAchievements)) {
    _load();
  }

  void _load() {
    final unlocked = repo.readUnlocked();
    emit(AchievementsState(defaultAchievements.map((a) =>
      unlocked.contains(a.id) ? a.copyUnlocked() : a
    ).toList()));
  }

  Future<void> _unlock(AchievementId id) async {
    final current = state.all;
    final idx = current.indexWhere((a) => a.id == id);
    if (idx < 0 || current[idx].unlocked) return;

    final updated = [...current];
    updated[idx] = updated[idx].copyUnlocked();
    emit(AchievementsState(updated));

    final set = updated.where((a) => a.unlocked).map((a) => a.id).toSet();
    await repo.writeUnlocked(set);
  }

  // вызывается из GameBloc по каждому раунду
  Future<void> checkOnRound({
    required bool correct,
    required int streak,
    required Difficulty difficulty,
    required int totalCorrect,
    required int totalScore,
  }) async {
    if (streak >= 10) await _unlock(AchievementId.streak10);
    if (streak >= 20) await _unlock(AchievementId.streak20);

    if (totalCorrect >= 50) await _unlock(AchievementId.correct50);
    if (totalCorrect >= 100) await _unlock(AchievementId.correct100);

    if (totalScore >= 1000) await _unlock(AchievementId.score1000);

    // Трекер для "10 правильных на Hard за одну сессию"
    if (difficulty == Difficulty.hard) {
      final current = repo.readHardSessionCorrect();
      final next = correct ? current + 1 : current;
      await repo.writeHardSessionCorrect(next);
      if (next >= 10) await _unlock(AchievementId.hard10Correct);
    } else {
      // в других сложностях сбрасываем прогресс "hard-сессии"
      await repo.resetHardSessionCorrect();
    }
  }

  Future<void> resetAll() async {
    await repo.writeUnlocked(<AchievementId>{});
    await repo.resetHardSessionCorrect();
    emit(AchievementsState(defaultAchievements));
  }
}
