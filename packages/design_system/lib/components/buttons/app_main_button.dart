import 'package:flutter/material.dart';

final class AppMainButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String? title;
  final Widget? child;
  final double width;
  final double height;

  const AppMainButton({
    super.key,
    required this.onPressed,
    this.title,
    this.child,
    this.width = double.infinity,
    this.height = 68,
  }) : assert(
         title != null || child != null,
         'Either title or child must be provided.',
       ),
       assert(
         title == null || child == null,
         'Only one of title or child can be provided.',
       );

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);
    final textTheme = TextTheme.of(context);
    const borderRadius = BorderRadius.all(.circular(36));

    return Material(
      color: Colors.transparent,
      shape: const RoundedRectangleBorder(borderRadius: .all(.circular(36))),
      clipBehavior: Clip.antiAlias,
      child: Ink(
        decoration: const BoxDecoration(
          borderRadius: borderRadius,
          gradient: LinearGradient(
            colors: [
              Color(0xFF003D9B),
              Color(0xFF0052CC),
            ],
          ),
        ),
        child: InkWell(
          onTap: onPressed,
          borderRadius: borderRadius,
          overlayColor: WidgetStateColor.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return colorScheme.onPrimary.withValues(alpha: 0.16);
            }

            if (states.contains(WidgetState.hovered) || states.contains(WidgetState.focused)) {
              return colorScheme.onPrimary.withValues(alpha: 0.08);
            }

            return Colors.transparent;
          }),
          child: SizedBox(
            width: width,
            height: height,
            child: Center(
              child:
                  child ??
                  Text(
                    title!,
                    style: textTheme.titleLarge?.copyWith(
                      fontSize: 18,
                      color: colorScheme.onPrimary,
                    ),
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
