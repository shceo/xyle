import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../application/stats_cubit.dart';
import '../../domain/stats_model.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = context.watch<StatsCubit>().state;
    final scheme = Theme.of(context).colorScheme;

    const bgTop = Color(0xFF0B0E13);
    const bgBottom = Color(0xFF0F1320);

    return Scaffold(
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
            // ambient glow
            Positioned(
              top: -120,
              left: -80,
              child: _RadialGlow(
                color: const Color(0xFF00E5FF).withOpacity(0.20),
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
              child: Column(
                children: [
                  // header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 4, 12, 10),
                    child: Row(
                      children: [
                        _NeonCircleButton(
                          icon: Icons.arrow_back,
                          color: scheme.secondary,
                          onTap: () => Navigator.pop(context),
                        ),
                        const Spacer(),
                        ShaderMask(
                          shaderCallback: (r) => LinearGradient(
                            colors: [scheme.secondary, scheme.primary],
                          ).createShader(r),
                          child: const Text(
                            'STATISTICS',
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
                        _NeonCircleButton(
                          icon: Icons.refresh_rounded,
                          color: scheme.primary,
                          onTap: () => _confirmReset(context),
                        ),
                      ],
                    ),
                  ),

                  // subtle glowing line
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _GlowDivider(
                      from: scheme.secondary.withOpacity(0.6),
                      to: scheme.primary.withOpacity(0.6),
                    ),
                  ),

                  // content
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
                      children: [
                        _StatTile(
                          icon: Icons.sports_esports_rounded,
                          title: 'Games played',
                          value: stats.totalGames.toString(),
                          glow: scheme.secondary,
                          valueColor: scheme.primary,
                        ),
                        const SizedBox(height: 14),
                        _StatTile(
                          icon: Icons.timelapse_rounded,
                          title: 'Rounds',
                          value: stats.totalRounds.toString(),
                          glow: scheme.secondary,
                          valueColor: scheme.primary,
                        ),
                        const SizedBox(height: 14),
                        _StatTile(
                          icon: Icons.check_circle_rounded,
                          title: 'Correct answers',
                          value: stats.totalCorrect.toString(),
                          glow: scheme.secondary,
                          valueColor: scheme.primary,
                        ),
                        const SizedBox(height: 14),
                        _StatTile(
                          icon: Icons.show_chart_rounded,
                          title: 'Accuracy',
                          value: _pct(stats.accuracy),
                          glow: scheme.secondary,
                          valueColor: scheme.primary,
                        ),
                        const SizedBox(height: 14),
                        _StatTile(
                          icon: Icons.local_fire_department_rounded,
                          title: 'Best streak',
                          value: stats.bestStreak.toString(),
                          glow: scheme.secondary,
                          valueColor: scheme.primary,
                        ),
                        const SizedBox(height: 14),
                        _StatTile(
                          icon: Icons.timer_rounded,
                          title: 'Avg time/answer',
                          value: _secs(stats.avgTimePerAnswerSec),
                          glow: scheme.secondary,
                          valueColor: scheme.primary,
                        ),
                        const SizedBox(height: 14),
                        _StatTile(
                          icon: Icons.star_rounded,
                          title: 'Total score',
                          value: stats.totalScore.toString(),
                          glow: scheme.secondary,
                          valueColor: scheme.primary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _pct(double v) => '${(v * 100).toStringAsFixed(1)}%';
  static String _secs(double v) => '${v.toStringAsFixed(2)}s';

  static Future<void> _confirmReset(BuildContext context) async {
    final scheme = Theme.of(context).colorScheme;
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: const Color(0xFF151926),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: scheme.primary.withOpacity(0.35),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: scheme.primary.withOpacity(0.25),
                blurRadius: 30,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ShaderMask(
                shaderCallback: (r) => LinearGradient(
                  colors: [scheme.secondary, scheme.primary],
                ).createShader(r),
                child: const Text(
                  'RESET STATS?',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2,
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'This cannot be undone.',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _NeonActionButton(
                      label: 'Cancel',
                      glow: scheme.secondary,
                      onTap: () => Navigator.pop(context, false),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _NeonActionButton(
                      label: 'Reset',
                      glow: scheme.primary,
                      onTap: () => Navigator.pop(context, true),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    if (ok == true && context.mounted) {
      await context.read<StatsCubit>().resetAll();
    }
  }
}

/* ========================= Widgets ========================= */

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color glow;
  final Color valueColor;

  const _StatTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.glow,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, c) {
        final w = c.maxWidth;
        final height = (w < 380) ? 68.0 : 76.0;
        final iconSize = (w * 0.095).clamp(20.0, 28.0);

        return Container(
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1A1F2C), Color(0xFF121622)],
            ),
            border: Border.all(color: glow.withOpacity(0.35), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: glow.withOpacity(0.32),
                blurRadius: 26,
                spreadRadius: 1,
              ),
              BoxShadow(
                color: glow.withOpacity(0.18),
                blurRadius: 50,
                spreadRadius: 8,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFF171B28),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: glow.withOpacity(0.45),
                      width: 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: glow.withOpacity(0.35),
                        blurRadius: 18,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Icon(icon, color: glow, size: iconSize),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: (w < 380) ? 16 : 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white.withOpacity(0.92),
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
                ShaderMask(
                  shaderCallback: (r) => LinearGradient(
                    colors: [valueColor, glow],
                  ).createShader(r),
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: (w < 380) ? 18 : 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: valueColor.withOpacity(0.7),
                          blurRadius: 10,
                        ),
                        Shadow(color: glow.withOpacity(0.5), blurRadius: 18),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

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
    return Semantics(
      button: true,
      child: GestureDetector(
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
          BoxShadow(
            color: from.withOpacity(0.35),
            blurRadius: 16,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: to.withOpacity(0.35),
            blurRadius: 16,
            spreadRadius: 0,
          ),
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

class _NeonActionButton extends StatefulWidget {
  final String label;
  final Color glow;
  final VoidCallback onTap;
  final bool uppercase;

  const _NeonActionButton({
    required this.label,
    required this.glow,
    required this.onTap,
    this.uppercase = true,
    super.key,
  });

  @override
  State<_NeonActionButton> createState() => _NeonActionButtonState();
}

class _NeonActionButtonState extends State<_NeonActionButton> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    final g = widget.glow;
    final text = widget.uppercase ? widget.label.toUpperCase() : widget.label;

    return Semantics(
      button: true,
      label: widget.label,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _down = true),
        onTapCancel: () => setState(() => _down = false),
        onTapUp: (_) {
          setState(() => _down = false);
          widget.onTap();
        },
        child: AnimatedScale(
          duration: const Duration(milliseconds: 120),
          scale: _down ? 0.97 : 1.0,
          child: Container(
            height: 44,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1A1F2C), Color(0xFF121622)],
              ),
              border: Border.all(color: g.withOpacity(0.45), width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: g.withOpacity(0.35),
                  blurRadius: 22,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: ShaderMask(
              shaderCallback: (r) => LinearGradient(
                colors: [g, g.withOpacity(0.85)],
              ).createShader(r),
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white, // нужен для ShaderMask
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
