import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xenoglyph/src/features/lore/application/lore_cubit.dart';
import 'package:xenoglyph/src/features/lore/domain/lore_models.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});
  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> with SingleTickerProviderStateMixin {
  int _index = 0;
  int _score = 0;

  int? _pressed;          
  bool _showResult = false;

  late final AnimationController _fadeCtrl =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 700))
        ..forward();
  late final Animation<double> _fade = CurvedAnimation(
    parent: _fadeCtrl,
    curve: Curves.easeOutCubic,
  );

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loreState = context.watch<LoreCubit>().state;
    final deck = builtInQuiz.where((q) => loreState.isUnlocked(q.loreId)).toList();

    const bgTop = Color(0xFF0B0E13);
    const bgBottom = Color(0xFF0F1320);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [bgTop, bgBottom],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -120, left: -80,
              child: _RadialGlow(color: const Color(0xFF00E5FF).withOpacity(0.22), radius: 220),
            ),
            Positioned(
              bottom: -140, right: -60,
              child: _RadialGlow(color: const Color(0xFF7C4DFF).withOpacity(0.22), radius: 280),
            ),

            SafeArea(
              child: deck.isEmpty
                  ? _EmptyQuiz(scheme: scheme)
                  : Column(
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
                                shaderCallback: (r) =>
                                    LinearGradient(colors: [scheme.secondary, scheme.primary])
                                        .createShader(r),
                                child: const Text(
                                  'LORE QUIZ',
                                  style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w800,
                                    letterSpacing: 3, color: Colors.white,
                                    shadows: [
                                      Shadow(blurRadius: 16, color: Color(0xAA00E5FF)),
                                      Shadow(blurRadius: 24, color: Color(0x887C4DFF)),
                                    ],
                                  ),
                                ),
                              ),
                              const Spacer(),
                              const SizedBox(width: 44),
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
                          child: FadeTransition(
                            opacity: _fade,
                            child: Center(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 720),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
                                  child: _QuestionView(
                                    index: _index,
                                    score: _score,
                                    total: deck.length,
                                    question: deck[_index],
                                    scheme: scheme,
                                    pressed: _pressed,
                                    showResult: _showResult,
                                    onTap: (i) => _answer(context, i, deck),
                                  ),
                                ),
                              ),
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

  void _answer(BuildContext context, int picked, List<QuizQuestion> deck) {
    if (_showResult) return;
    final q = deck[_index];
    final correct = picked == q.correctIndex;

    setState(() {
      _pressed = picked;
      _showResult = true;
      if (correct) _score += 1;
    });

    Future.delayed(const Duration(milliseconds: 650), () async {
      if (!mounted) return;
      final next = _index + 1;
      if (next >= deck.length) {
        
        final loreIds = deck.map((e) => e.loreId).toSet();
        for (final id in loreIds) {
          context.read<LoreCubit>().markQuizPassed(id);
        }
        await _showResultDialog(context, _score, deck.length);
        if (mounted) Navigator.pop(context);
      } else {
        setState(() {
          _index = next;
          _pressed = null;
          _showResult = false;
        });
      }
    });
  }

  Future<void> _showResultDialog(BuildContext context, int score, int total) async {
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
            border: Border.all(color: scheme.primary.withOpacity(0.35), width: 1.2),
            boxShadow: [BoxShadow(color: scheme.primary.withOpacity(0.25), blurRadius: 30)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ShaderMask(
                shaderCallback: (r) =>
                    LinearGradient(colors: [scheme.secondary, scheme.primary]).createShader(r),
                child: const Text(
                  'QUIZ COMPLETE',
                  style: TextStyle(
                    fontWeight: FontWeight.w800, letterSpacing: 2, color: Colors.white, fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text('Score: $score / $total', style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 14),
              Align(
                alignment: Alignment.centerRight,
                child: _NeonActionButton(
                  label: 'OK',
                  glow: scheme.secondary,
                  onTap: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class _QuestionView extends StatelessWidget {
  final int index;
  final int score;
  final int total;
  final QuizQuestion question;
  final ColorScheme scheme;
  final int? pressed;
  final bool showResult;
  final ValueChanged<int> onTap;

  const _QuestionView({
    required this.index,
    required this.score,
    required this.total,
    required this.question,
    required this.scheme,
    required this.pressed,
    required this.showResult,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleLarge?.copyWith(
          fontSize: 20,
          color: Colors.white.withOpacity(0.9),
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ShaderMask(
          shaderCallback: (r) =>
              LinearGradient(colors: [scheme.secondary, scheme.primary]).createShader(r),
          child: Text(
            'Question ${index + 1}/$total',
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(question.question, style: titleStyle, textAlign: TextAlign.center),
        const SizedBox(height: 18),

        
        ...List.generate(question.options.length, (i) {
          final isCorrect = i == question.correctIndex;
          final isPressed = pressed == i;
          final Color glow;
          if (showResult && isCorrect) {
            glow = const Color(0xFF2EE6A6); 
          } else if (showResult && isPressed && !isCorrect) {
            glow = const Color(0xFFFF4D8D); 
          } else {
            glow = scheme.secondary; 
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _NeonOption(
              label: question.options[i],
              glow: glow,
              disabled: showResult,
              onTap: () => onTap(i),
            ),
          );
        }),

        const Spacer(),

        
        Opacity(
          opacity: 0.9,
          child: ShaderMask(
            shaderCallback: (r) =>
                LinearGradient(colors: [scheme.secondary, scheme.primary]).createShader(r),
            child: Text(
              'Score: $score',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.6,
              ),
            ),
          ),
        ),
      ],
    );
  }
}



class _NeonOption extends StatefulWidget {
  final String label;
  final Color glow;
  final bool disabled;
  final VoidCallback onTap;

  const _NeonOption({
    required this.label,
    required this.glow,
    required this.onTap,
    this.disabled = false,
  });

  @override
  State<_NeonOption> createState() => _NeonOptionState();
}

class _NeonOptionState extends State<_NeonOption> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    final g = widget.glow;

    return Semantics(
      button: true,
      label: widget.label,
      child: GestureDetector(
        onTapDown: widget.disabled ? null : (_) => setState(() => _down = true),
        onTapCancel: widget.disabled ? null : () => setState(() => _down = false),
        onTapUp: widget.disabled
            ? null
            : (_) {
                setState(() => _down = false);
                widget.onTap();
              },
        child: AnimatedScale(
          duration: const Duration(milliseconds: 110),
          scale: _down ? 0.98 : 1.0,
          child: Container(
            height: 58,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: const LinearGradient(
                begin: Alignment.topLeft, end: Alignment.bottomRight,
                colors: [Color(0xFF1A1F2C), Color(0xFF121622)],
              ),
              border: Border.all(color: g.withOpacity(0.55), width: 1.2),
              boxShadow: [
                BoxShadow(color: g.withOpacity(0.35), blurRadius: 22, spreadRadius: 1),
                BoxShadow(color: g.withOpacity(0.18), blurRadius: 46, spreadRadius: 8),
              ],
            ),
            child: Text(
              widget.label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.95),
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
                fontSize: 16,
              ),
            ),
          ),
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
          width: 44, height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF141826).withOpacity(0.85),
            border: Border.all(color: c.withOpacity(0.55), width: 1.2),
            boxShadow: [
              BoxShadow(color: c.withOpacity(0.65), blurRadius: 16, spreadRadius: 1),
              BoxShadow(color: c.withOpacity(0.35), blurRadius: 36, spreadRadius: 8),
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
      width: radius, height: radius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: color, blurRadius: radius / 1.8, spreadRadius: radius / 6)],
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
              begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: [Color(0xFF1A1F2C), Color(0xFF121622)],
            ),
            border: Border.all(color: g.withOpacity(0.45), width: 1.2),
            boxShadow: [
              BoxShadow(color: g.withOpacity(0.35), blurRadius: 22, spreadRadius: 1),
            ],
          ),
          child: ShaderMask(
            shaderCallback: (r) => LinearGradient(colors: [g, g.withOpacity(0.85)]).createShader(r),
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w700, letterSpacing: 0.8,
              ),
            ),
          ),
        ),
      ),
    );
  }
}



class _EmptyQuiz extends StatelessWidget {
  final ColorScheme scheme;
  const _EmptyQuiz({required this.scheme});

  @override
  Widget build(BuildContext context) {
    return Column(
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
                shaderCallback: (r) =>
                    LinearGradient(colors: [scheme.secondary, scheme.primary]).createShader(r),
                child: const Text(
                  'LORE QUIZ',
                  style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w800,
                    letterSpacing: 3, color: Colors.white,
                    shadows: [
                      Shadow(blurRadius: 16, color: Color(0xAA00E5FF)),
                      Shadow(blurRadius: 24, color: Color(0x887C4DFF)),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              const SizedBox(width: 44),
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
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Unlock lore entries to access the quiz.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
              height: 1.4,
            ),
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
