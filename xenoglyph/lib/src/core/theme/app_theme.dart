import 'package:flutter/material.dart';

ThemeData buildAppTheme() {
  final base = ThemeData.dark(useMaterial3: true);
  return base.copyWith(
    scaffoldBackgroundColor: const Color(0xFF0C0F13),
    colorScheme: base.colorScheme.copyWith(
      primary: const Color(0xFF7C4DFF),
      secondary: const Color(0xFF00E5FF),
      tertiary: const Color(0xFF00E676),
    ),
    textTheme: base.textTheme.apply(fontFamily: null),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),
  );
}
