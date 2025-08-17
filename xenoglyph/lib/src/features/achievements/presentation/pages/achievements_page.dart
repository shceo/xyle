import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../application/achievements_cubit.dart';
import '../../domain/achievement.dart';

class AchievementsPage extends StatelessWidget {
  const AchievementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AchievementsCubit>().state;
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
                            'ACHIEVEMENTS',
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
                          icon: Icons.restore_rounded,
                          color: scheme.primary,
                          onTap: () => _confirmReset(context),
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

                  
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final width = constraints.maxWidth;

                        int crossAxisCount;
                        if (width < 460) {
                          crossAxisCount = 1;
                        } else if (width < 900) {
                          crossAxisCount = 2;
                        } else {
                          crossAxisCount = 3;
                        }

                        const padding = 20.0;
                        const spacing = 18.0;
                        final totalHSpacing =
                            padding * 2 + spacing * (crossAxisCount - 1);
                        final itemWidth =
                            (width - totalHSpacing) / crossAxisCount;
                        final minHeight = width < 460 ? 210.0 : 220.0;
                        final childAspectRatio = itemWidth / minHeight;

                        return GridView.builder(
                          padding: const EdgeInsets.all(padding),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                mainAxisSpacing: spacing,
                                crossAxisSpacing: spacing,
                                childAspectRatio: childAspectRatio,
                              ),
                          itemCount: state.all.length,
                          itemBuilder: (_, i) {
                            final a = state.all[i];
                            final glow = (i % 2 == 0)
                                ? scheme.secondary
                                : scheme.primary;
                            return _AchievementCard(a: a, glow: glow);
                          },
                        );
                      },
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

  static Future<void> _confirmReset(BuildContext context) async {
    final scheme = Theme.of(context).colorScheme;
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: const Color(0xFF151926),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
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
      await context.read<AchievementsCubit>().resetAll();
    }
  }
}



class _AchievementCard extends StatelessWidget {
  final Achievement a;
  final Color glow;
  const _AchievementCard({required this.a, required this.glow});

  @override
  Widget build(BuildContext context) {
    final titleGradient = LinearGradient(
      colors: [glow, glow.withOpacity(0.85)],
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A1F2C), Color(0xFF121622)],
        ),
        border: Border.all(color: glow.withOpacity(0.45), width: 1.3),
        boxShadow: [
          BoxShadow(
            color: glow.withOpacity(0.35),
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
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
        child: LayoutBuilder(
          builder: (context, c) {
            final w = c.maxWidth;
            final iconSize = (w * 0.22).clamp(28.0, 48.0);

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  a.unlocked ? Icons.emoji_events_rounded : Icons.lock_rounded,
                  size: iconSize,
                  color: glow,
                  shadows: [
                    Shadow(color: glow.withOpacity(0.5), blurRadius: 14),
                  ],
                ),
                const SizedBox(height: 10),

                
                ShaderMask(
                  shaderCallback: (rect) => titleGradient.createShader(rect),
                  child: Text(
                    a.title,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: (w < 320) ? 16 : 18,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.2,
                      shadows: [
                        Shadow(color: glow.withOpacity(0.7), blurRadius: 10),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                
                Flexible(
                  child: Center(
                    child: Text(
                      a.description,
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        height: 1.35,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                
                if (a.unlocked && a.unlockedAt != null)
                  Opacity(
                    opacity: 0.9,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Unlocked: ${_formatDate(a.unlockedAt!)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 13,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  String _two(int v) => v.toString().padLeft(2, '0');
  String _formatDate(DateTime d) =>
      '${d.year}-${_two(d.month)}-${_two(d.day)} ${_two(d.hour)}:${_two(d.minute)}';
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
                  color: Colors.white,
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
