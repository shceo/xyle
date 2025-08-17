import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
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
            // лёгкое свечение в углах, как на мокапе
            Positioned(
              top: -120,
              left: -80,
              child: _RadialGlow(
                color: const Color(0xFF00E5FF).withOpacity(0.22),
                radius: 220,
              ),
            ),
            Positioned(
              bottom: -120,
              right: -60,
              child: _RadialGlow(
                color: const Color(0xFF7C4DFF).withOpacity(0.22),
                radius: 260,
              ),
            ),

            SafeArea(
              child: Column(
                children: [
                  // HEADER: back + centered ABOUT
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 4, 12, 10),
                    child: Row(
                      children: [
                        _NeonBackButton(
                          color: scheme.secondary,
                          onTap: () => Navigator.pop(context),
                        ),
                        const Spacer(),
                        ShaderMask(
                          shaderCallback: (r) => LinearGradient(
                            colors: [scheme.secondary, scheme.primary],
                          ).createShader(r),
                          child: const Text(
                            'ABOUT',
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
                        const SizedBox(width: 48), // симметрия с кнопкой назад
                      ],
                    ),
                  ),

                  // тонкая светящаяся линия под шапкой
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _GlowDivider(
                      from: scheme.secondary.withOpacity(0.6),
                      to: scheme.primary.withOpacity(0.6),
                    ),
                  ),

                  // CONTENT
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 28,
                        ),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 560),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              _NeonBigTitle(
                                'XenoGlyph',
                                gradient: LinearGradient(
                                  colors: [scheme.secondary, scheme.primary],
                                ),
                              ),
                              const SizedBox(height: 18),
                              Text(
                                'A mini-game about decoding extraterrestrial symbols.',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      height: 1.35,
                                      color: Colors.white.withOpacity(0.92),
                                      letterSpacing: 0.2,
                                    ),
                              ),
                              const SizedBox(height: 26),
                              Text(
                                'Made with Flutter & Dart.',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(
                                      height: 1.4,
                                      color: Colors.white.withOpacity(0.88),
                                    ),
                              ),
                              const SizedBox(height: 14),
                              Text(
                                '© 2025 shceo',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(
                                      color: Colors.white.withOpacity(0.88),
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // нижняя светящаяся линия
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 14),
                    child: _GlowDivider(
                      from: scheme.secondary.withOpacity(0.45),
                      to: scheme.primary.withOpacity(0.45),
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

/* ========================= Neon pieces ========================= */

class _NeonBackButton extends StatefulWidget {
  final Color color;
  final VoidCallback onTap;
  const _NeonBackButton({required this.color, required this.onTap});

  @override
  State<_NeonBackButton> createState() => _NeonBackButtonState();
}

class _NeonBackButtonState extends State<_NeonBackButton> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    final c = widget.color;
    return Semantics(
      button: true,
      label: 'Back',
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
            width: 48,
            height: 48,
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
            child: Icon(Icons.arrow_back, color: c, size: 22),
          ),
        ),
      ),
    );
  }
}

class _NeonBigTitle extends StatelessWidget {
  final String text;
  final Gradient gradient;
  const _NeonBigTitle(this.text, {required this.gradient});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (rect) => gradient.createShader(rect),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 54,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.8,
          color: Colors.white, // masked
          shadows: [
            Shadow(blurRadius: 26, color: Color(0xAA00E5FF)),
            Shadow(blurRadius: 36, color: Color(0x887C4DFF)),
          ],
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
