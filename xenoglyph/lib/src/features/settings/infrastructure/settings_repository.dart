import 'package:shared_preferences/shared_preferences.dart';
import '../domain/settings_model.dart';

class SettingsRepository {
  static const _kTimer = 'timer_enabled';
  static const _kSound = 'sound_enabled';

  final SharedPreferences prefs;
  SettingsRepository(this.prefs);

  SettingsModel read() {
    final timer = prefs.getBool(_kTimer) ?? true;
    final sound = prefs.getBool(_kSound) ?? true;
    return SettingsModel(timerEnabled: timer, soundEnabled: sound);
  }

  Future<void> save(SettingsModel s) async {
    await prefs.setBool(_kTimer, s.timerEnabled);
    await prefs.setBool(_kSound, s.soundEnabled);
  }
}
