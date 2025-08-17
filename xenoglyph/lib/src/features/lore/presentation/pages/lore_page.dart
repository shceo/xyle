import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../application/lore_cubit.dart';
import '../../domain/lore_models.dart';
import '../../../../core/router/app_router.dart';

class LorePage extends StatelessWidget {
  const LorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<LoreCubit>().state;
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
                            'LORE & LOGS',
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
                          icon: Icons.quiz_outlined,
                          color: scheme.primary,
                          onTap: () =>
                              Navigator.pushNamed(context, AppRouter.quiz),
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
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
                      itemCount: s.allLore.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 14),
                      itemBuilder: (context, i) {
                        final e = s.allLore[i];
                        final unlocked = s.isUnlocked(e.id);
                        final passed = s.quizPassed(e.id);
                        
                        final glow = unlocked
                            ? scheme.secondary
                            : scheme.primary.withOpacity(0.50);
                        return _LoreTile(
                          entry: e,
                          glow: glow,
                          unlocked: unlocked,
                          passed: passed,
                          initiallyExpanded: unlocked && i == 0,
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
}



class _LoreTile extends StatelessWidget {
  final LoreEntry entry;
  final Color glow;
  final bool unlocked;
  final bool passed;
  final bool initiallyExpanded;

  const _LoreTile({
    required this.entry,
    required this.glow,
    required this.unlocked,
    required this.passed,
    required this.initiallyExpanded,
  });

  @override
  Widget build(BuildContext context) {
    final titleGradient = LinearGradient(
      colors: [glow, glow.withOpacity(0.85)],
    );
    final scheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A1F2C), Color(0xFF121622)],
        ),
        border: Border.all(color: glow.withOpacity(0.45), width: 1.2),
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
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          expansionTileTheme: ExpansionTileThemeData(
            iconColor: glow,
            collapsedIconColor: glow.withOpacity(0.8),
            textColor: Colors.white,
            collapsedTextColor: Colors.white,
            tilePadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 10,
            ),
            childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
          ),
        ),
        child: ExpansionTile(
          initiallyExpanded: initiallyExpanded,
          title: Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: const Color(0xFF171B28),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: glow.withOpacity(0.45)),
                  boxShadow: [
                    BoxShadow(color: glow.withOpacity(0.35), blurRadius: 14),
                  ],
                ),
                child: Icon(
                  unlocked ? Icons.menu_book_rounded : Icons.lock_rounded,
                  size: 18,
                  color: glow,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ShaderMask(
                  shaderCallback: (r) => titleGradient.createShader(r),
                  child: Text(
                    entry.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      letterSpacing: 0.2,
                      shadows: [
                        Shadow(blurRadius: 10, color: Color(0x6600E5FF)),
                      ],
                    ),
                  ),
                ),
              ),
              if (unlocked && passed) ...[
                const SizedBox(width: 8),
                Icon(
                  Icons.check_circle_rounded,
                  size: 20,
                  color: Colors.lightGreenAccent.shade200,
                ),
              ],
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              unlocked
                  ? 'Unlocked'
                  : 'Unlock at ${entry.unlockAtCorrectTotal} correct',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.white.withOpacity(0.85)),
            ),
          ),
          children: [
            const SizedBox(height: 8),
            _GlowDivider(
              from: scheme.secondary.withOpacity(0.28),
              to: scheme.primary.withOpacity(0.28),
            ),
            const SizedBox(height: 10),
            Text(
              unlocked ? entry.content : 'Keep playing to unlock...',
              style: TextStyle(
                color: Colors.white.withOpacity(0.92),
                height: 1.35,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
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
