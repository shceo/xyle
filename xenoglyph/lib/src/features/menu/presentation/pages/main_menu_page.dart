import 'package:flutter/material.dart';
import '../../../../core/router/app_router.dart';

class MainMenuPage extends StatelessWidget {
  const MainMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bgTop = const Color(0xFF0B0E13);
    final bgBottom = const Color(0xFF0F1320);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [bgTop, bgBottom],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Top icons: Settings (left) and About (right)
              Positioned(
                left: 12,
                right: 12,
                top: 18,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _NeonIconButton(
                      icon: Icons.settings,
                      tooltip: 'Settings',
                      onTap: () => Navigator.pushNamed(context, AppRouter.settings),
                      glowColor: scheme.primary,
                    ),
                    _NeonIconButton(
                      icon: Icons.info_outline,
                      tooltip: 'About',
                      onTap: () => Navigator.pushNamed(context, AppRouter.about),
                      glowColor: scheme.secondary,
                    ),
                  ],
                ),
              ),

              // Center content
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _NeonTitle(
                          'XenoGlyph',
                          gradient: LinearGradient(
                            colors: [
                              scheme.secondary, // cyan
                              scheme.primary,   // violet
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),

                        _NeonButton(
                          label: 'Play',
                          onTap: () => Navigator.pushNamed(context, AppRouter.game),
                          from: scheme.secondary,
                          to: scheme.primary,
                        ),
                        const SizedBox(height: 14),

                        _NeonButton(
                          label: 'Statistics',
                          onTap: () => Navigator.pushNamed(context, AppRouter.stats),
                          from: scheme.primary,
                          to: scheme.tertiary,
                        ),
                        const SizedBox(height: 14),

                        _NeonButton(
                          label: 'Achievements',
                          onTap: () => Navigator.pushNamed(context, AppRouter.achievements),
                          from: scheme.tertiary,
                          to: scheme.secondary,
                        ),
                        const SizedBox(height: 14),

                        _NeonButton(
                          label: 'Lore & Quiz',
                          onTap: () => Navigator.pushNamed(context, AppRouter.lore),
                          from: scheme.secondary,
                          to: scheme.primary,
                        ),
                        const SizedBox(height: 14),

                        _NeonButton(
                          label: 'How to Play',
                          onTap: () => Navigator.pushNamed(context, AppRouter.howto),
                          from: scheme.primary,
                          to: scheme.tertiary,
                        ),
                        const SizedBox(height: 28),

                        Opacity(
                          opacity: 0.9,
                          child: Text(
                            'Decode alien symbols. Learn the lore. Earn achievements.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  letterSpacing: 0.2,
                                  color: Colors.white.withOpacity(0.85),
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ========================= NEON WIDGETS ========================= */

class _NeonTitle extends StatelessWidget {
  final String text;
  final Gradient gradient;
  const _NeonTitle(this.text, {required this.gradient});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (rect) => gradient.createShader(rect),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 44,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.8,
          color: Colors.white, // masked by ShaderMask
          shadows: [
            Shadow(blurRadius: 16, color: Color(0xAA00E5FF), offset: Offset(0, 0)),
            Shadow(blurRadius: 24, color: Color(0x887C4DFF), offset: Offset(0, 0)),
          ],
        ),
      ),
    );
  }
}

class _NeonButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final Color from;
  final Color to;

  const _NeonButton({
    required this.label,
    required this.onTap,
    required this.from,
    required this.to,
  });

  @override
  State<_NeonButton> createState() => _NeonButtonState();
}

class _NeonButtonState extends State<_NeonButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final gradient = LinearGradient(colors: [widget.from, widget.to]);
    final glowColor = Color.lerp(widget.from, widget.to, 0.5) ?? widget.to;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      child: AnimatedScale(
        duration: const Duration(milliseconds: 120),
        scale: _pressed ? 0.98 : 1.0,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            boxShadow: [
              BoxShadow(color: glowColor.withOpacity(0.45), blurRadius: 24, spreadRadius: 1),
              BoxShadow(color: glowColor.withOpacity(0.25), blurRadius: 48, spreadRadius: 8),
            ],
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF1A1F2C),
                const Color(0xFF121622),
              ],
            ),
            border: Border.all(color: glowColor.withOpacity(0.35), width: 1.2),
          ),
          child: Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.center,
            child: ShaderMask(
              shaderCallback: (rect) => gradient.createShader(rect),
              child: Text(
                widget.label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                  color: Colors.white,
                  shadows: [
                    Shadow(color: glowColor.withOpacity(0.8), blurRadius: 16),
                    Shadow(color: glowColor.withOpacity(0.5), blurRadius: 32),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NeonIconButton extends StatefulWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final Color glowColor;

  const _NeonIconButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    required this.glowColor,
  });

  @override
  State<_NeonIconButton> createState() => _NeonIconButtonState();
}

class _NeonIconButtonState extends State<_NeonIconButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final bg = const Color(0xFF141826);
    final glow = widget.glowColor;

    return Semantics(
      button: true,
      label: widget.tooltip,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) {
          setState(() => _pressed = false);
          widget.onTap();
        },
        child: AnimatedScale(
          duration: const Duration(milliseconds: 120),
          scale: _pressed ? 0.95 : 1.0,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: bg.withOpacity(0.8),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: glow.withOpacity(0.45), blurRadius: 18, spreadRadius: 1),
              ],
              border: Border.all(color: glow.withOpacity(0.4), width: 1.1),
            ),
            child: Icon(widget.icon, size: 22, color: glow),
          ),
        ),
      ),
    );
  }
}
