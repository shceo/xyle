import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../settings/application/settings_cubit.dart';
import '../../application/game_bloc.dart';
import '../../../../core/constants.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> with WidgetsBindingObserver {
  late GameBloc _bloc; // <— держим ссылку
  bool _started = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  // Берём Bloc и запускаем игру ОДИН раз, тут уже безопасно пользоваться контекстом
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = context.read<GameBloc>(); // safe здесь
    if (!_started) {
      final settings = context.read<SettingsCubit>().state;
      _bloc.add(
        GameStarted(
          mode: settings.timerEnabled ? GameMode.timed : GameMode.relaxed,
          difficulty: Difficulty.easy,
        ),
      );
      _started = true;
    }
  }

  // Пауза при сворачивании
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) _forcePause();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _forcePause(); // <— без context, только через _bloc
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    _forcePause(); // стопаем перед выходом
    return true;
  }

  void _forcePause() {
    // не трогаем context тут!
    if (!_bloc.state.isPaused) {
      _bloc.add(GamePausedToggled());
    }
    // Если есть аудио — останавливаем здесь
    // SoundFx.instance.stopAll();
  }

  @override
  Widget build(BuildContext context) {
    const bgTop = Color(0xFF0B0E13);
    const bgBottom = Color(0xFF0F1320);
    final scheme = Theme.of(context).colorScheme;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [bgTop, bgBottom],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: -120,
                left: -80,
                child: _RadialGlow(
                  color: const Color(0xFF00E5FF).withOpacity(0.22),
                  radius: 220,
                ),
              ),
              Positioned(
                bottom: -140,
                right: -60,
                child: _RadialGlow(
                  color: const Color(0xFF7C4DFF).withOpacity(0.22),
                  radius: 280,
                ),
              ),

              SafeArea(
                child: BlocBuilder<GameBloc, GameState>(
                  bloc: _bloc,
                  builder: (context, state) {
                    final round = state.round;

                    return Column(
                      children: [
                        // ---------- HEADER ----------
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 4, 12, 10),
                          child: Row(
                            children: [
                              _NeonCircleButton(
                                icon: Icons.arrow_back,
                                color: scheme.secondary,
                                onTap: () {
                                  _forcePause();
                                  Navigator.pop(context);
                                },
                              ),
                              const Spacer(),
                              ShaderMask(
                                shaderCallback: (r) => LinearGradient(
                                  colors: [scheme.secondary, scheme.primary],
                                ).createShader(r),
                                child: const Text(
                                  'GAME',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 3,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 16,
                                        color: Color(0xAA00E5FF),
                                      ),
                                      Shadow(
                                        blurRadius: 24,
                                        color: Color(0x887C4DFF),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Spacer(),
                              // SCORE
                              ShaderMask(
                                shaderCallback: (r) => LinearGradient(
                                  colors: [scheme.secondary, scheme.primary],
                                ).createShader(r),
                                child: Text(
                                  'Score: ${state.score}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              // TIMER
                              if (state.timeLeft != null)
                                _NeonChip(
                                  label: '${state.timeLeft}s',
                                  glow: scheme.primary,
                                ),
                              const SizedBox(width: 8),
                              // PAUSE
                              _NeonCircleButton(
                                icon: state.isPaused
                                    ? Icons.play_arrow_rounded
                                    : Icons.pause_rounded,
                                color: scheme.primary,
                                onTap: () => context.read<GameBloc>().add(
                                  GamePausedToggled(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: _GlowDivider(
                            from: scheme.secondary.withOpacity(0.6),
                            to: scheme.primary.withOpacity(0.6),
                          ),
                        ),
                        // ---------- BODY ----------
                        Expanded(
                          child: round == null
                              ? const Center(child: CircularProgressIndicator())
                              : AbsorbPointer(
                                  absorbing: state.isPaused,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      20,
                                      26,
                                      20,
                                      14,
                                    ),
                                    child: Column(
                                      children: [
                                        // Encrypted word
                                        Expanded(
                                          flex: 3,
                                          child: Center(
                                            child: AnimatedScale(
                                              duration: const Duration(
                                                milliseconds: 180,
                                              ),
                                              scale:
                                                  state.status ==
                                                      RoundStatus.correct
                                                  ? 1.08
                                                  : state.status ==
                                                        RoundStatus.incorrect
                                                  ? 0.96
                                                  : 1.0,
                                              child: ShaderMask(
                                                shaderCallback: (r) =>
                                                    LinearGradient(
                                                      colors: [
                                                        scheme.secondary,
                                                        scheme.primary,
                                                      ],
                                                    ).createShader(r),
                                                child: Text(
                                                  round.encryptedWord,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    fontSize: 56,
                                                    letterSpacing: 8,
                                                    color: Colors.white,
                                                    shadows: [
                                                      Shadow(
                                                        blurRadius: 26,
                                                        color: Color(
                                                          0xAA00E5FF,
                                                        ),
                                                      ),
                                                      Shadow(
                                                        blurRadius: 36,
                                                        color: Color(
                                                          0x887C4DFF,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                        // mapping chips
                                        Wrap(
                                          alignment: WrapAlignment.center,
                                          spacing: 8,
                                          runSpacing: 8,
                                          children: round
                                              .mapping
                                              .symbolToLetter
                                              .entries
                                              .map(
                                                (e) => _NeonMiniChip(
                                                  label:
                                                      '${e.key} = ${e.value}',
                                                  glow: scheme.secondary,
                                                ),
                                              )
                                              .toList(),
                                        ),
                                        const SizedBox(height: 18),

                                        // Answer options
                                        Expanded(
                                          flex: 4,
                                          child: LayoutBuilder(
                                            builder: (_, c) {
                                              final isNarrow = c.maxWidth < 460;
                                              final aspect = isNarrow
                                                  ? 3.1
                                                  : 3.3;
                                              return GridView.count(
                                                crossAxisCount: 2,
                                                mainAxisSpacing: 14,
                                                crossAxisSpacing: 14,
                                                childAspectRatio: aspect,
                                                children: round.options.map((
                                                  opt,
                                                ) {
                                                  final isCorrect =
                                                      opt == round.decodedWord;
                                                  final showFeedback =
                                                      state.status !=
                                                          RoundStatus.playing &&
                                                      state.lastChoiceCorrect !=
                                                          null;

                                                  Color glow = scheme.secondary;
                                                  if (showFeedback) {
                                                    glow = isCorrect
                                                        ? const Color(
                                                            0xFF2EE6A6,
                                                          )
                                                        : const Color(
                                                            0xFFFF4D8D,
                                                          );
                                                  }

                                                  return _NeonOption(
                                                    label: opt,
                                                    glow: glow,
                                                    onTap: () => context
                                                        .read<GameBloc>()
                                                        .add(
                                                          AnswerSelected(opt),
                                                        ),
                                                  );
                                                }).toList(),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                        ),

                        // ---------- FOOTER ----------
                        Container(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
                          child: Row(
                            children: [
                              // Streak
                              ShaderMask(
                                shaderCallback: (r) => LinearGradient(
                                  colors: [scheme.secondary, scheme.primary],
                                ).createShader(r),
                                child: Text(
                                  'Streak: ${state.streak}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              // MODE
                              _ModeDropdown(
                                value: state.mode,
                                glow: scheme.secondary,
                                onChanged: (m) {
                                  if (m == null) return;
                                  context.read<GameBloc>().add(
                                    GameStarted(
                                      mode: m,
                                      difficulty: state.difficulty,
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(width: 10),
                              // DIFFICULTY
                              _DifficultyDropdown(
                                value: state.difficulty,
                                glow: scheme.primary,
                                onChanged: (d) {
                                  if (d == null) return;
                                  context.read<GameBloc>().add(
                                    GameStarted(
                                      mode: state.mode,
                                      difficulty: d,
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(width: 10),
                              _NeonPillButton(
                                label: 'Next',
                                glow: scheme.primary,
                                onTap: () => context.read<GameBloc>().add(
                                  NextRoundRequested(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ========================= Neon widgets ========================= */

class _NeonCircleButton extends StatefulWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _NeonCircleButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  State<_NeonCircleButton> createState() => _NeonCircleButtonState();
}

class _NeonCircleButtonState extends State<_NeonCircleButton> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    final c = widget.color;
    return GestureDetector(
      onTapDown: (_) => setState(() => _down = true),
      onTapCancel: () => setState(() => _down = false),
      onTapUp: (_) {
        setState(() => _down = false);
        widget.onTap();
      },
      child: AnimatedScale(
        duration: const Duration(milliseconds: 120),
        scale: _down ? 0.95 : 1.0,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF141826).withOpacity(0.85),
            border: Border.all(color: c.withOpacity(0.55), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: c.withOpacity(0.65),
                blurRadius: 16,
                spreadRadius: 1,
              ),
              BoxShadow(
                color: c.withOpacity(0.35),
                blurRadius: 36,
                spreadRadius: 8,
              ),
            ],
          ),
          child: Icon(widget.icon, color: c, size: 22),
        ),
      ),
    );
  }
}

class _GlowDivider extends StatelessWidget {
  final Color from;
  final Color to;
  const _GlowDivider({required this.from, required this.to});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [from, to]),
        boxShadow: [
          BoxShadow(color: from.withOpacity(0.35), blurRadius: 16),
          BoxShadow(color: to.withOpacity(0.35), blurRadius: 16),
        ],
      ),
    );
  }
}

class _RadialGlow extends StatelessWidget {
  final Color color;
  final double radius;
  const _RadialGlow({required this.color, required this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: radius / 1.8,
            spreadRadius: radius / 6,
          ),
        ],
      ),
    );
  }
}

class _NeonChip extends StatelessWidget {
  final String label;
  final Color glow;
  const _NeonChip({required this.label, required this.glow});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xFF171B28),
        border: Border.all(color: glow.withOpacity(0.55)),
        boxShadow: [BoxShadow(color: glow.withOpacity(0.35), blurRadius: 14)],
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white.withOpacity(0.94),
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

class _NeonMiniChip extends StatelessWidget {
  final String label;
  final Color glow;
  const _NeonMiniChip({required this.label, required this.glow});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xFF171B28),
        border: Border.all(color: glow.withOpacity(0.45)),
        boxShadow: [BoxShadow(color: glow.withOpacity(0.30), blurRadius: 12)],
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white.withOpacity(0.92),
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

class _NeonOption extends StatefulWidget {
  final String label;
  final Color glow;
  final VoidCallback onTap;

  const _NeonOption({
    required this.label,
    required this.glow,
    required this.onTap,
  });

  @override
  State<_NeonOption> createState() => _NeonOptionState();
}

class _NeonOptionState extends State<_NeonOption> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    final g = widget.glow;

    return GestureDetector(
      onTapDown: (_) => setState(() => _down = true),
      onTapCancel: () => setState(() => _down = false),
      onTapUp: (_) {
        setState(() => _down = false);
        widget.onTap();
      },
      child: AnimatedScale(
        duration: const Duration(milliseconds: 110),
        scale: _down ? 0.98 : 1.0,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1A1F2C), Color(0xFF121622)],
            ),
            border: Border.all(color: g.withOpacity(0.55), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: g.withOpacity(0.35),
                blurRadius: 22,
                spreadRadius: 1,
              ),
              BoxShadow(
                color: g.withOpacity(0.18),
                blurRadius: 46,
                spreadRadius: 8,
              ),
            ],
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.95),
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

class _NeonPillButton extends StatefulWidget {
  final String label;
  final Color glow;
  final VoidCallback onTap;

  const _NeonPillButton({
    required this.label,
    required this.glow,
    required this.onTap,
  });

  @override
  State<_NeonPillButton> createState() => _NeonPillButtonState();
}

class _NeonPillButtonState extends State<_NeonPillButton> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    final g = widget.glow;
    return GestureDetector(
      onTapDown: (_) => setState(() => _down = true),
      onTapCancel: () => setState(() => _down = false),
      onTapUp: (_) {
        setState(() => _down = false);
        widget.onTap();
      },
      child: AnimatedScale(
        duration: const Duration(milliseconds: 110),
        scale: _down ? 0.97 : 1.0,
        child: Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1A1F2C), Color(0xFF121622)],
            ),
            border: Border.all(color: g.withOpacity(0.55), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: g.withOpacity(0.35),
                blurRadius: 22,
                spreadRadius: 1,
              ),
              BoxShadow(
                color: g.withOpacity(0.18),
                blurRadius: 46,
                spreadRadius: 8,
              ),
            ],
          ),
          child: ShaderMask(
            shaderCallback: (r) => LinearGradient(
              colors: [g, g.withOpacity(0.85)],
            ).createShader(r),
            child: const Text(
              'Next',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.6,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ModeDropdown extends StatelessWidget {
  final GameMode value;
  final Color glow;
  final ValueChanged<GameMode?> onChanged;

  const _ModeDropdown({
    required this.value,
    required this.glow,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _NeonDropdown<GameMode>(
      value: value,
      glow: glow,
      items: const [
        DropdownMenuItem(value: GameMode.timed, child: Text('Timed')),
        DropdownMenuItem(value: GameMode.relaxed, child: Text('Relaxed')),
        DropdownMenuItem(
          value: GameMode.suddenDeath,
          child: Text('Sudden Death'),
        ),
      ],
      onChanged: onChanged,
    );
  }
}

class _DifficultyDropdown extends StatelessWidget {
  final Difficulty value;
  final Color glow;
  final ValueChanged<Difficulty?> onChanged;

  const _DifficultyDropdown({
    required this.value,
    required this.glow,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _NeonDropdown<Difficulty>(
      value: value,
      glow: glow,
      items: const [
        DropdownMenuItem(value: Difficulty.easy, child: Text('Easy')),
        DropdownMenuItem(value: Difficulty.medium, child: Text('Medium')),
        DropdownMenuItem(value: Difficulty.hard, child: Text('Hard')),
      ],
      onChanged: onChanged,
    );
  }
}

class _NeonDropdown<T> extends StatelessWidget {
  final T value;
  final List<DropdownMenuItem<T>> items;
  final Color glow;
  final ValueChanged<T?> onChanged;

  const _NeonDropdown({
    required this.value,
    required this.items,
    required this.glow,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: const Color(0xFF171B28),
        border: Border.all(color: glow.withOpacity(0.45)),
        boxShadow: [BoxShadow(color: glow.withOpacity(0.32), blurRadius: 18)],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: DropdownButton<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          elevation: 2,
          dropdownColor: const Color(0xFF171B28),
          underline: const SizedBox.shrink(),
          style: TextStyle(
            color: Colors.white.withOpacity(0.95),
            fontWeight: FontWeight.w600,
          ),
          iconEnabledColor: glow,
        ),
      ),
    );
  }
}
