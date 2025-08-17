import 'dart:math';

enum GameMode { timed, relaxed, suddenDeath }
enum Difficulty { easy, medium, hard }

const List<String> kAlienSymbols = [
  '▲','●','■','◆','★','✦','☾','⟡','✚','✶','◇','⬟','⬢','⬡','✧'
];

int defaultTimeFor(Difficulty d) {
  switch (d) {
    case Difficulty.easy: return 15;
    case Difficulty.medium: return 12;
    case Difficulty.hard: return 10;
  }
}

final random = Random();
