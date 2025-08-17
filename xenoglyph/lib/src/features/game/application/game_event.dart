part of 'game_bloc.dart';

abstract class GameEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GameStarted extends GameEvent {
  final GameMode mode;
  final Difficulty difficulty;
  GameStarted({required this.mode, required this.difficulty});

  @override
  List<Object?> get props => [mode, difficulty];
}

class AnswerSelected extends GameEvent {
  final String answer;
  AnswerSelected(this.answer);
  @override
  List<Object?> get props => [answer];
}

class NextRoundRequested extends GameEvent {}

class TimerTicked extends GameEvent {}

class GamePausedToggled extends GameEvent {}
