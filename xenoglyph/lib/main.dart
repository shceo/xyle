import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xenoglyph/src/app.dart';
import 'package:xenoglyph/src/core/sound/sound_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  // Инициализируем звуковой сервис
  final sound = SoundService();
  await sound.init();

  runApp(XenoGlyphApp(prefs: prefs, sound: sound));
}
