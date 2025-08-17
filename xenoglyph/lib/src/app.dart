import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';


import 'features/settings/infrastructure/settings_repository.dart';
import 'features/settings/application/settings_cubit.dart';


import 'features/game/domain/game_repository.dart';
import 'features/game/infrastructure/game_repository_impl.dart';
import 'features/game/application/game_bloc.dart';


import 'features/stats/infrastructure/stats_repository.dart';
import 'features/stats/application/stats_cubit.dart';


import 'features/achievements/infrastructure/achievements_repository.dart';
import 'features/achievements/application/achievements_cubit.dart';


import 'features/lore/infrastructure/lore_repository.dart';
import 'features/lore/application/lore_cubit.dart';


import 'core/sound/sound_service.dart';

class XenoGlyphApp extends StatelessWidget {
  final SharedPreferences prefs;
  final SoundService sound;

  const XenoGlyphApp({super.key, required this.prefs, required this.sound});

  @override
  Widget build(BuildContext context) {
    final settingsRepo = SettingsRepository(prefs);
    final gameRepo = GameRepositoryImpl();

    final statsRepo = StatsRepository(prefs);
    final achievesRepo = AchievementsRepository(prefs);
    final loreRepo = LoreRepository(prefs);

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<SettingsRepository>.value(value: settingsRepo),
        RepositoryProvider<GameRepository>.value(value: gameRepo),
        RepositoryProvider<StatsRepository>.value(value: statsRepo),
        RepositoryProvider<AchievementsRepository>.value(value: achievesRepo),
        RepositoryProvider<LoreRepository>.value(value: loreRepo),

        
        RepositoryProvider<SoundService>.value(value: sound),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<SettingsCubit>(create: (_) => SettingsCubit(settingsRepo)..load()),
          BlocProvider<StatsCubit>(create: (_) => StatsCubit(statsRepo)),
          BlocProvider<AchievementsCubit>(create: (_) => AchievementsCubit(achievesRepo)),
          BlocProvider<LoreCubit>(create: (_) => LoreCubit(loreRepo)),

          BlocProvider<GameBloc>(
            create: (ctx) => GameBloc(
              gameRepository: gameRepo,
              settingsCubit: ctx.read<SettingsCubit>(),
              statsCubit: ctx.read<StatsCubit>(),
              achievementsCubit: ctx.read<AchievementsCubit>(),
              loreCubit: ctx.read<LoreCubit>(),
              sound: ctx.read<SoundService>(),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'XenoGlyph',
          debugShowCheckedModeBanner: false,
          theme: buildAppTheme(),
          onGenerateRoute: AppRouter.onGenerateRoute,
          initialRoute: AppRouter.mainMenu,
        ),
      ),
    );
  }
}
