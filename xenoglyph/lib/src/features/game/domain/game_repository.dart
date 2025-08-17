import '../../../core/constants.dart';
import 'entities.dart';

abstract class GameRepository {
  GameRound nextRound({required Difficulty difficulty, required bool timerEnabled});
}
