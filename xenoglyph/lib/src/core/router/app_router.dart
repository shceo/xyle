import 'package:flutter/material.dart';
import 'package:xenoglyph/src/features/game/presentation/pages/game_page.dart';
import 'package:xenoglyph/src/features/lore/presentation/quiz_page.dart';
import 'package:xenoglyph/src/features/menu/presentation/pages/main_menu_page.dart';
import 'package:xenoglyph/src/features/settings/presentation/pages/settings_page.dart';

// New pages
import 'package:xenoglyph/src/features/stats/presentation/pages/statistics_page.dart';
import 'package:xenoglyph/src/features/achievements/presentation/pages/achievements_page.dart';
import 'package:xenoglyph/src/features/lore/presentation/pages/lore_page.dart';
import 'package:xenoglyph/src/features/info/presentation/pages/how_to_play_page.dart';
import 'package:xenoglyph/src/features/info/presentation/pages/about_page.dart';

class AppRouter {
  static const String mainMenu = '/';
  static const String game = '/game';
  static const String settings = '/settings';

  // New routes
  static const String stats = '/stats';
  static const String achievements = '/achievements';
  static const String lore = '/lore';
  static const String quiz = '/quiz';
  static const String howto = '/howto';
  static const String about = '/about';

  static Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case AppRouter.mainMenu:
        return MaterialPageRoute(builder: (_) => const MainMenuPage());
      case AppRouter.game:
        return MaterialPageRoute(builder: (_) => const GamePage());
      case AppRouter.settings:
        return MaterialPageRoute(builder: (_) => const SettingsPage());

      // New routes
      case AppRouter.stats:
        return MaterialPageRoute(builder: (_) => const StatisticsPage());
      case AppRouter.achievements:
        return MaterialPageRoute(builder: (_) => const AchievementsPage());
      case AppRouter.lore:
        return MaterialPageRoute(builder: (_) => const LorePage());
      case AppRouter.quiz:
        return MaterialPageRoute(builder: (_) => const QuizPage());
      case AppRouter.howto:
        return MaterialPageRoute(builder: (_) => const HowToPlayPage());
      case AppRouter.about:
        return MaterialPageRoute(builder: (_) => const AboutPage());

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Unknown route'))),
        );
    }
  }
}
