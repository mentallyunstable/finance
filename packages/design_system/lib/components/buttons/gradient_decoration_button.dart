import 'package:flutter/material.dart';

final class GradientDecorationButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;

  const GradientDecorationButton({
    super.key,
    required this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);

    return Opacity(
      opacity: onPressed == null ? 0.45 : 1,
      child: Material(
        color: Colors.transparent,
        shape: const RoundedRectangleBorder(borderRadius: .all(.circular(36))),
        clipBehavior: .antiAlias,
        child: Ink(
          decoration: const BoxDecoration(
            shape: .circle,
            gradient: LinearGradient(
              colors: [
                Color(0xFF003D9B),
                Color(0xFF0052CC),
              ],
            ),
          ),
          child: InkWell(
            onTap: onPressed,
            overlayColor: WidgetStateColor.resolveWith((states) {
              if (states.contains(WidgetState.pressed)) {
                return colorScheme.onPrimary.withValues(alpha: 0.16);
              }

              if (states.contains(WidgetState.hovered) || states.contains(WidgetState.focused)) {
                return colorScheme.onPrimary.withValues(alpha: 0.08);
              }

              return Colors.transparent;
            }),
            child: child,
          ),
        ),
      ),
    );
  }
}
