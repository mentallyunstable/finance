import 'dart:ui';

import 'package:design_system/components/buttons/gradient_decoration_button.dart';
import 'package:flutter/material.dart';

final class VoiceRecognitionIconButton extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isListening;

  const VoiceRecognitionIconButton({
    super.key,
    required this.onPressed,
    required this.isListening,
  });

  @override
  State<VoiceRecognitionIconButton> createState() => _VoiceRecognitionIconButtonState();
}

final class _VoiceRecognitionIconButtonState extends State<VoiceRecognitionIconButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _syncPulseAnimation();
  }

  @override
  void didUpdateWidget(covariant VoiceRecognitionIconButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isListening != widget.isListening) {
      _syncPulseAnimation();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _syncPulseAnimation() {
    if (widget.isListening) {
      _pulseController.repeat(reverse: true);
    } else {
      _pulseController
        ..stop()
        ..value = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);

    return SizedBox.square(
      dimension: 80,
      child: AnimatedBuilder(
        animation: _pulseController,
        child: GradientDecorationButton(
          onPressed: widget.onPressed,
          child: Icon(
            widget.isListening ? Icons.mic_rounded : Icons.mic_none_rounded,
            size: 32,
            color: colorScheme.onPrimary,
          ),
        ),
        builder: (context, child) {
          final pulseValue = Curves.easeOut.transform(_pulseController.value);
          final scale = lerpDouble(1, 1.08, pulseValue)!;
          final shadowBlur = lerpDouble(0, 20, pulseValue)!;
          final shadowSpread = lerpDouble(0, 4, pulseValue)!;
          final shadowAlpha = lerpDouble(0, 0.28, pulseValue)!;

          return Transform.scale(
            scale: scale,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  if (widget.isListening)
                    BoxShadow(
                      color: const Color(0xFF0052CC).withValues(alpha: shadowAlpha),
                      blurRadius: shadowBlur,
                      spreadRadius: shadowSpread,
                    ),
                ],
              ),
              child: child,
            ),
          );
        },
      ),
    );
  }
}
