import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/lore_models.dart';
import '../infrastructure/lore_repository.dart';

class LoreState {
  final List<LoreEntry> allLore;
  final Set<String> unlockedIds;
  final Set<String> quizPassedIds;

  const LoreState({
    required this.allLore,
    required this.unlockedIds,
    required this.quizPassedIds,
  });

  bool isUnlocked(String id) => unlockedIds.contains(id);
  bool quizPassed(String loreId) => quizPassedIds.contains(loreId);
}

class LoreCubit extends Cubit<LoreState> {
  final LoreRepository repo;
  LoreCubit(this.repo)
      : super(LoreState(allLore: builtInLore, unlockedIds: repo.readUnlockedLore(), quizPassedIds: repo.readQuizPassed()));

  // вызывать из GameBloc/Stats при росте totalCorrect
  Future<void> checkUnlocksByTotals({required int totalCorrect}) async {
    final unlocked = {...state.unlockedIds};
    for (final e in state.allLore) {
      if (totalCorrect >= e.unlockAtCorrectTotal) {
        unlocked.add(e.id);
      }
    }
    if (unlocked.length != state.unlockedIds.length) {
      emit(LoreState(allLore: state.allLore, unlockedIds: unlocked, quizPassedIds: state.quizPassedIds));
      await repo.writeUnlockedLore(unlocked);
    }
  }

  Future<void> markQuizPassed(String loreId) async {
    final q = {...state.quizPassedIds}..add(loreId);
    emit(LoreState(allLore: state.allLore, unlockedIds: state.unlockedIds, quizPassedIds: q));
    await repo.writeQuizPassed(q);
  }
}
