import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;

final class DialogService {
  final GlobalKey<NavigatorState> navigatorKey;

  DialogService({required this.navigatorKey});

  OverlayEntry? _overlay;

  Future<void> showDialog({
    required final BuildContext context,
    required final String message,
    required final List<Widget> actions,
    final bool barrierDismissible = true,
    final String? description,
    final VoidCallback? whenComplete,
  }) async {
    return await material
        .showDialog(
          context: context,
          barrierDismissible: barrierDismissible,
          builder: (_) => material.Dialog(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: material.Theme.of(context).textTheme.titleMedium,
                  ),
                  if (description != null && description.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      description,
                      textAlign: TextAlign.center,
                      style: material.Theme.of(context).textTheme.labelMedium,
                    ),
                    const SizedBox(height: 16),
                    // TODO: implement app button component
                    // AppButton(
                    //   height: 44,
                    //   width: 144,
                    //   title: ErrorMessages.unexpectedError,
                    //   onPressed: () => context.pop(),
                    // ),
                  ],
                ],
              ),
            ),
          ),
        )
        .whenComplete(() => whenComplete?.call());
  }

  Future<void> showCupertinoDialog({
    required final BuildContext context,
    required final String message,
    required final List<Widget> actions,
    final bool barrierDismissible = true,
    final String? description,
    final VoidCallback? whenComplete,
  }) async {
    return await material
        .showDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: Text(
              message,
              style: material.Theme.of(context).textTheme.titleSmall,
            ),
            content: description != null ? Text(description) : null,
            actions: actions,
          ),
        )
        .whenComplete(() => whenComplete?.call());
  }

  Future<T?> showContentDialog<T>({
    required final BuildContext context,
    required final Widget content,
    final VoidCallback? whenComplete,
    final Color? backgroundColor,
    final bool barrierDismissible = true,
  }) async {
    return await material
        .showDialog<T>(
          context: context,
          barrierDismissible: barrierDismissible,
          builder: (context) => material.Dialog(
            elevation: 0,
            surfaceTintColor: material.Colors.transparent,
            backgroundColor: backgroundColor ?? material.Theme.of(context).colorScheme.surfaceBright,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
            insetPadding: const EdgeInsets.symmetric(horizontal: 24),
            child: content,
          ),
        )
        .whenComplete(() => whenComplete?.call());
  }

  void showLoader() {
    final context = navigatorKey.currentContext;

    if (context == null) {
      return;
    }

    if (_overlay != null) {
      return;
    }

    _overlay = OverlayEntry(
      builder: (context) => Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaY: 7.5, sigmaX: 7.5),
              child: ColoredBox(
                color: material.Colors.white.withValues(alpha: 0.3),
                child: const SizedBox.expand(),
              ),
            ),
          ),
          // TODO: implement app loading indicator component
          // const AppLoadingIndicator(),
        ],
      ),
    );

    Overlay.of(context).insert(_overlay!);
  }

  void showOverlay({
    required final BuildContext context,
    required final Widget child,
    final bool isDismissible = false,
  }) {
    if (_overlay != null) {
      return;
    }

    _overlay = OverlayEntry(
      builder: (context) => material.Material(
        color: material.Colors.transparent,
        child: GestureDetector(
          onTap: isDismissible ? hideOverlay : null,
          child: Stack(
            fit: StackFit.expand,
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaY: 7.5, sigmaX: 7.5),
                  child: ColoredBox(
                    color: material.Colors.black.withValues(alpha: 0.3),
                    child: const SizedBox.expand(),
                  ),
                ),
              ),
              Center(child: child),
            ],
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlay!);
  }

  void hideLoader() {
    _overlay?.remove();
    _overlay = null;
  }

  void hideOverlay() {
    _overlay?.remove();
    _overlay = null;
  }
}
