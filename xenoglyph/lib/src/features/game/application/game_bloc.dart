import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xenoglyph/src/features/achievements/application/achievements_cubit.dart';
import 'package:xenoglyph/src/features/lore/application/lore_cubit.dart';

import '../../../core/constants.dart';
import '../../../core/sound/sound_service.dart';
import '../domain/entities.dart';
import '../domain/game_repository.dart';
import '../../settings/application/settings_cubit.dart';
import '../../stats/application/stats_cubit.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final GameRepository gameRepository;
  final SettingsCubit settingsCubit;

  final StatsCubit statsCubit;
  final AchievementsCubit achievementsCubit;
  final LoreCubit loreCubit;
  final SoundService sound;

  Timer? _ticker;
  DateTime? _roundStartAt;

  GameBloc({
    required this.gameRepository,
    required this.settingsCubit,
    required this.statsCubit,
    required this.achievementsCubit,
    required this.loreCubit,
    required this.sound,
  }) : super(const GameState.initial()) {
    on<GameStarted>(_onStarted);
    on<AnswerSelected>(_onAnswer);
    on<NextRoundRequested>(_onNextRound);
    on<TimerTicked>(_onTick);
    on<GamePausedToggled>(_onPause);
  }

  bool get _soundOn => settingsCubit.state.soundEnabled;

  Future<void> _onStarted(GameStarted e, Emitter<GameState> emit) async {
    _cancelTimer();
    await statsCubit.trackGameStarted();

    final timerOn =
        settingsCubit.state.timerEnabled && e.mode == GameMode.timed;
    final round = gameRepository.nextRound(
      difficulty: e.difficulty,
      timerEnabled: timerOn,
    );

    emit(
      state.copyWith(
        mode: e.mode,
        difficulty: e.difficulty,
        score: 0,
        streak: 0,
        isPaused: false,
        round: round,
        timeLeft: timerOn ? round.timeLimitSec : null,
        status: RoundStatus.playing,
        lastChoiceCorrect: null,
      ),
    );

    _roundStartAt = DateTime.now();
    _startTimerIfNeeded();
  }

  void _onNextRound(NextRoundRequested e, Emitter<GameState> emit) {
    if (state.round == null) return;

    _cancelTimer();

    final timerOn =
        settingsCubit.state.timerEnabled && state.mode == GameMode.timed;
    final next = gameRepository.nextRound(
      difficulty: state.difficulty,
      timerEnabled: timerOn,
    );

    emit(
      state.copyWith(
        round: next,
        timeLeft: timerOn ? next.timeLimitSec : null,
        status: RoundStatus.playing,
        lastChoiceCorrect: null,
      ),
    );

    _roundStartAt = DateTime.now();
    _startTimerIfNeeded();
  }

  void _onAnswer(AnswerSelected e, Emitter<GameState> emit) {
    if (state.round == null ||
        state.isPaused ||
        state.status != RoundStatus.playing)
      return;

    _cancelTimer();

    final correct = e.answer == state.round!.decodedWord;
    final newStreak = correct ? state.streak + 1 : 0;
    final addScore = correct ? 100 + (newStreak * 10) : 0;
    final timeMs = _calcRoundTimeMs();

    emit(
      state.copyWith(
        score: state.score + addScore,
        streak: newStreak,
        status: correct ? RoundStatus.correct : RoundStatus.incorrect,
        lastChoiceCorrect: correct,
      ),
    );

    if (_soundOn) {
      if (correct) {
        sound.playCorrect();
      } else {
        sound.playIncorrect();
      }
    }

    statsCubit
        .trackRound(
          timeMs: timeMs,
          correct: correct,
          streakAfter: newStreak,
          scoreDelta: addScore,
          difficulty: state.difficulty,
        )
        .then((totals) {
          achievementsCubit.checkOnRound(
            correct: correct,
            streak: newStreak,
            difficulty: state.difficulty,
            totalCorrect: totals.totalCorrect,
            totalScore: totals.totalScore,
          );
          loreCubit.checkUnlocksByTotals(totalCorrect: totals.totalCorrect);
        });

    Future.delayed(const Duration(milliseconds: 450), () {
      if (isClosed) return;
      if (!correct && state.mode == GameMode.suddenDeath) {
        add(
          GameStarted(mode: GameMode.suddenDeath, difficulty: state.difficulty),
        );
      } else {
        add(NextRoundRequested());
      }
    });
  }

  void _onTick(TimerTicked e, Emitter<GameState> emit) {
    if (state.timeLeft == null ||
        state.isPaused ||
        state.status != RoundStatus.playing)
      return;

    final t = (state.timeLeft ?? 0) - 1;

    if (_soundOn && t > 0 && t <= 3) {
      sound.playTick();
    }

    if (t <= 0) {
      emit(
        state.copyWith(
          status: RoundStatus.incorrect,
          lastChoiceCorrect: false,
          timeLeft: 0,
        ),
      );

      if (_soundOn) {
        sound.playIncorrect();
      }

      _cancelTimer();

      final timeMs = _calcRoundTimeMs(limitSeconds: state.round?.timeLimitSec);
      statsCubit
          .trackRound(
            timeMs: timeMs,
            correct: false,
            streakAfter: 0,
            scoreDelta: 0,
            difficulty: state.difficulty,
          )
          .then((totals) {
            achievementsCubit.checkOnRound(
              correct: false,
              streak: 0,
              difficulty: state.difficulty,
              totalCorrect: totals.totalCorrect,
              totalScore: totals.totalScore,
            );
            loreCubit.checkUnlocksByTotals(totalCorrect: totals.totalCorrect);
          });

      Future.delayed(const Duration(milliseconds: 300), () {
        if (isClosed) return;
        if (state.mode == GameMode.suddenDeath) {
          add(
            GameStarted(
              mode: GameMode.suddenDeath,
              difficulty: state.difficulty,
            ),
          );
        } else {
          add(NextRoundRequested());
        }
      });
    } else {
      emit(state.copyWith(timeLeft: t));
    }
  }

  void _onPause(GamePausedToggled e, Emitter<GameState> emit) {
    final paused = !state.isPaused;
    emit(state.copyWith(isPaused: paused));
  }

  void _startTimerIfNeeded() {
    _cancelTimer();
    if (state.timeLeft != null) {
      _ticker = Timer.periodic(
        const Duration(seconds: 1),
        (_) => add(TimerTicked()),
      );
    }
  }

  int _calcRoundTimeMs({int? limitSeconds}) {
    final start = _roundStartAt;
    if (start == null) return 0;
    final elapsed = DateTime.now().difference(start).inMilliseconds;
    if (limitSeconds != null) {
      final limitMs = limitSeconds * 1000;
      return elapsed.clamp(0, limitMs);
    }
    return elapsed;
  }

  void _cancelTimer() {
    _ticker?.cancel();
    _ticker = null;
  }

  @override
  Future<void> close() {
    _cancelTimer();
    return super.close();
  }
}
