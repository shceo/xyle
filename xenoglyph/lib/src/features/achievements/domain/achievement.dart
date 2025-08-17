enum AchievementId {
  streak10,
  streak20,
  correct50,
  correct100,
  hard10Correct,
  score1000,
}

class Achievement {
  final AchievementId id;
  final String title;
  final String description;
  final bool unlocked;
  final DateTime? unlockedAt;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.unlocked,
    this.unlockedAt,
  });

  Achievement copyUnlocked() =>
      Achievement(id: id, title: title, description: description, unlocked: true, unlockedAt: DateTime.now());
}

final List<Achievement> defaultAchievements = [
  Achievement(id: AchievementId.streak10,   title: 'Hot Streak',  description: 'Reach a 10+ streak', unlocked: false),
  Achievement(id: AchievementId.streak20,   title: 'On Fire',     description: 'Reach a 20+ streak', unlocked: false),
  Achievement(id: AchievementId.correct50,  title: 'Decoder I',   description: '50 correct answers total', unlocked: false),
  Achievement(id: AchievementId.correct100, title: 'Decoder II',  description: '100 correct answers total', unlocked: false),
  Achievement(id: AchievementId.hard10Correct, title: 'Hardcore', description: '10 correct on Hard (one session)', unlocked: false),
  Achievement(id: AchievementId.score1000,  title: 'Collector',   description: 'Reach 1000 total score', unlocked: false),
];
