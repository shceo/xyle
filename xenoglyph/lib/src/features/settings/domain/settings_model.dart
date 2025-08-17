class SettingsModel {
  final bool timerEnabled;
  final bool soundEnabled;
  final String appVersion;
  final String authors;

  const SettingsModel({
    required this.timerEnabled,
    required this.soundEnabled,
    this.appVersion = '1.0.0',
    this.authors = 'SHCEO',
  });

  SettingsModel copyWith({bool? timerEnabled, bool? soundEnabled}) {
    return SettingsModel(
      timerEnabled: timerEnabled ?? this.timerEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      appVersion: appVersion,
      authors: authors,
    );
  }
}
