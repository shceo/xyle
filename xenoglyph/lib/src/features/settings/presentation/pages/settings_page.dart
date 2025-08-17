import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../settings/application/settings_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<SettingsCubit>().state;
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
          child: Column(
            children: [
              
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
                child: Row(
                  children: [
                    _NeonRoundIcon(
                      icon: Icons.arrow_back,
                      color: scheme.secondary,
                      onTap: () => Navigator.pop(context),
                    ),
                    const Spacer(),
                    
                    ShaderMask(
                      shaderCallback: (rect) => LinearGradient(
                        colors: [scheme.secondary, scheme.primary],
                      ).createShader(rect),
                      child: const Text(
                        'SETTINGS',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 3,
                          color: Colors.white,
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

              
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _NeonCard(
                      borderGlow: scheme.primary,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Enable timer',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Opacity(
                                  opacity: 0.9,
                                  child: Text(
                                    'Timed mode uses per-round countdown',
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _NeonToggle(
                            value: s.timerEnabled,
                            onChanged: (v) =>
                                context.read<SettingsCubit>().toggleTimer(v),
                            from: scheme.primary, 
                            to: scheme.secondary, 
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    _NeonCard(
                      borderGlow: scheme.secondary,
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Sound',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          _NeonToggle(
                            value: s.soundEnabled,
                            onChanged: (v) =>
                                context.read<SettingsCubit>().toggleSound(v),
                            from: scheme.secondary,
                            to: scheme.tertiary,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 22),
                    _NeonDivider(color: scheme.secondary.withOpacity(0.35)),
                    const SizedBox(height: 12),

                    
                    _InfoLine(
                      label: 'Version',
                      value: s.appVersion,
                      color: scheme.secondary,
                    ),
                    const SizedBox(height: 6),
                    _InfoLine(
                      label: 'Authors',
                      value: s.authors,
                      color: scheme.secondary,
                    ),
                    const SizedBox(height: 8),
                    _NeonDivider(color: scheme.secondary.withOpacity(0.2)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class _NeonRoundIcon extends StatefulWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _NeonRoundIcon({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  State<_NeonRoundIcon> createState() => _NeonRoundIconState();
}

class _NeonRoundIconState extends State<_NeonRoundIcon> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _down = true),
      onTapCancel: () => setState(() => _down = false),
      onTapUp: (_) {
        setState(() => _down = false);
        widget.onTap();
      },
      child: AnimatedScale(
        duration: const Duration(milliseconds: 120),
        scale: _down ? 0.95 : 1,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFF141826).withOpacity(0.85),
            shape: BoxShape.circle,
            border: Border.all(color: widget.color.withOpacity(0.45)),
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(0.45),
                blurRadius: 18,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Icon(widget.icon, color: widget.color, size: 22),
        ),
      ),
    );
  }
}

class _NeonCard extends StatelessWidget {
  final Widget child;
  final Color borderGlow;
  const _NeonCard({required this.child, required this.borderGlow});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A1F2C), Color(0xFF121622)],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderGlow.withOpacity(0.35), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: borderGlow.withOpacity(0.35),
            blurRadius: 26,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: borderGlow.withOpacity(0.2),
            blurRadius: 50,
            spreadRadius: 6,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        child: child,
      ),
    );
  }
}

class _NeonToggle extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color from; 
  final Color to; 

  const _NeonToggle({
    required this.value,
    required this.onChanged,
    required this.from,
    required this.to,
  });

  @override
  State<_NeonToggle> createState() => _NeonToggleState();
}

class _NeonToggleState extends State<_NeonToggle> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  void didUpdateWidget(covariant _NeonToggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _value = widget.value;
    }
  }

  void _toggle() {
    setState(() => _value = !_value);
    widget.onChanged(_value);
  }

  @override
  Widget build(BuildContext context) {
    final glow = Color.lerp(widget.from, widget.to, 0.5) ?? widget.to;

    return Semantics(
      container: true,
      toggled: _value,
      value: _value ? 'on' : 'off',
      child: GestureDetector(
        onTap: _toggle,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 66,
          height: 36,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: _value
                ? LinearGradient(colors: [widget.from, widget.to])
                : const LinearGradient(
                    colors: [Color(0xFF2A2E3C), Color(0xFF181C27)],
                  ),
            boxShadow: _value
                ? [
                    BoxShadow(
                      color: glow.withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 1,
                    ),
                    BoxShadow(
                      color: glow.withOpacity(0.25),
                      blurRadius: 40,
                      spreadRadius: 8,
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 8,
                    ),
                  ],
            border: Border.all(
              color: glow.withOpacity(_value ? 0.45 : 0.2),
              width: 1.2,
            ),
          ),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 180),
            alignment: _value ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: _value
                    ? [
                        BoxShadow(
                          color: glow.withOpacity(0.8),
                          blurRadius: 14,
                          spreadRadius: 1,
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.35),
                          blurRadius: 8,
                        ),
                      ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NeonDivider extends StatelessWidget {
  final Color color;
  const _NeonDivider({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(height: 1, color: color);
  }
}

class _InfoLine extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _InfoLine({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: Colors.white.withOpacity(0.9)),
        children: [
          TextSpan(text: '$label: '),
          TextSpan(
            text: value,
            style: TextStyle(color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
