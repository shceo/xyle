import 'package:flutter/material.dart';

class HowToPlayPage extends StatefulWidget {
  const HowToPlayPage({super.key});

  @override
  State<HowToPlayPage> createState() => _HowToPlayPageState();
}

class _HowToPlayPageState extends State<HowToPlayPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    );
    _fade = CurvedAnimation(parent: _c, curve: Curves.easeOutCubic);
    _c.forward();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

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
            // ambient glow
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
                            'HOW TO PLAY',
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
                          icon: Icons.help_outline_rounded,
                          color: scheme.primary,
                          onTap: () => _showTips(context),
                        ),
                      ],
                    ),
                  ),

                  // thin glow line
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _GlowDivider(
                      from: scheme.secondary.withOpacity(0.6),
                      to: scheme.primary.withOpacity(0.6),
                    ),
                  ),

                  // content
                  Expanded(
                    child: FadeTransition(
                      opacity: _fade,
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(20, 22, 20, 26),
                        children: [
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 680),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _Section(
                                  title: 'Goal',
                                  gradient: LinearGradient(
                                    colors: [scheme.secondary, scheme.primary],
                                  ),
                                  child: Text(
                                    'Decode alien symbols into letters and select the correct decoded word.',
                                    style: _bodyStyle(context),
                                  ),
                                ),
                                _SoftDivider(scheme: scheme),

                                _Section(
                                  title: 'Mapping',
                                  gradient: LinearGradient(
                                    colors: [scheme.secondary, scheme.primary],
                                  ),
                                  child: Text(
                                    'Use the legend (symbol = letter) to translate the encrypted word.',
                                    style: _bodyStyle(context),
                                  ),
                                ),
                                _SoftDivider(scheme: scheme),

                                _Section(
                                  title: 'Scoring & Streak',
                                  gradient: LinearGradient(
                                    colors: [scheme.secondary, scheme.primary],
                                  ),
                                  child: Text(
                                    'Correct answers grant points. Consecutive correct answers increase your streak and bonus.',
                                    style: _bodyStyle(context),
                                  ),
                                ),
                                _SoftDivider(scheme: scheme),

                                _Section(
                                  title: 'Modes',
                                  gradient: LinearGradient(
                                    colors: [scheme.secondary, scheme.primary],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _BulletLine(
                                        dot: scheme.secondary,
                                        labelGradient: LinearGradient(
                                          colors: [
                                            scheme.secondary,
                                            scheme.primary,
                                          ],
                                        ),
                                        label: 'Timed',
                                        text:
                                            ' – answer before the countdown expires.',
                                      ),
                                      const SizedBox(height: 8),
                                      _BulletLine(
                                        dot: scheme.secondary,
                                        labelGradient: LinearGradient(
                                          colors: [
                                            scheme.secondary,
                                            scheme.primary,
                                          ],
                                        ),
                                        label: 'Relaxed',
                                        text: ' – no timer.',
                                      ),
                                      const SizedBox(height: 8),
                                      _BulletLine(
                                        dot: scheme.secondary,
                                        labelGradient: LinearGradient(
                                          colors: [
                                            scheme.secondary,
                                            scheme.primary,
                                          ],
                                        ),
                                        label: 'Sudden Death',
                                        text: ' – one mistake ends your run.',
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _bodyStyle(BuildContext context) =>
      Theme.of(context).textTheme.titleMedium?.copyWith(
        height: 1.35,
        color: Colors.white.withOpacity(0.92),
        letterSpacing: 0.2,
      ) ??
      const TextStyle(fontSize: 16, height: 1.35, color: Colors.white70);

  Future<void> _showTips(BuildContext context) async {
    final scheme = Theme.of(context).colorScheme;
    await showDialog(
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
                  'TIP',
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
                'Focus on vowels first – they appear more often and help to guess the word faster.',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: _NeonActionButton(
                  label: 'Close',
                  glow: scheme.secondary,
                  onTap: () => Navigator.pop(context),
                  uppercase: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ========================= Sections & bullets ========================= */

class _Section extends StatelessWidget {
  final String title;
  final Gradient gradient;
  final Widget child;

  const _Section({
    required this.title,
    required this.gradient,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18, top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShaderMask(
            shaderCallback: (rect) => gradient.createShader(rect),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.3,
                color: Colors.white,
                shadows: [
                  Shadow(blurRadius: 18, color: Color(0xAA00E5FF)),
                  Shadow(blurRadius: 26, color: Color(0x887C4DFF)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _SoftDivider extends StatelessWidget {
  final ColorScheme scheme;
  const _SoftDivider({required this.scheme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: _GlowDivider(
        from: scheme.secondary.withOpacity(0.28),
        to: scheme.primary.withOpacity(0.28),
      ),
    );
  }
}

class _BulletLine extends StatelessWidget {
  final Color dot;
  final Gradient labelGradient;
  final String label;
  final String text;

  const _BulletLine({
    required this.dot,
    required this.labelGradient,
    required this.label,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final base =
        Theme.of(context).textTheme.titleMedium?.copyWith(
          height: 1.35,
          color: Colors.white.withOpacity(0.92),
        ) ??
        const TextStyle(fontSize: 16, height: 1.35, color: Colors.white70);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // glowing dot
        Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.only(top: 9, right: 10),
          decoration: BoxDecoration(
            color: dot,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: dot.withOpacity(0.8), blurRadius: 10)],
          ),
        ),
        // gradient label + rest text
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                WidgetSpan(
                  alignment: PlaceholderAlignment.baseline,
                  baseline: TextBaseline.alphabetic,
                  child: ShaderMask(
                    shaderCallback: (r) => labelGradient.createShader(r),
                    child: Text(
                      label,
                      style: base.copyWith(
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                TextSpan(text: text, style: base),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/* ========================= Shared neon widgets ========================= */

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

    return GestureDetector(
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
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
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
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
