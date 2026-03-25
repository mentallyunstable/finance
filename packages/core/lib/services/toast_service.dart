import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

final class ToastService {
  final FToast fToast;

  ToastService() : fToast = FToast();

  void showToast({
    required final BuildContext context,
    required final Widget child,
    required final Color color,
  }) {
    fToast.removeQueuedCustomToasts();
    fToast
      ..init(context)
      ..showToast(
        isDismissible: true,
        gravity: ToastGravity.TOP,
        toastDuration: const Duration(seconds: 3),
        child: _ToastDecorator(color: color, child: child),
      );
  }
}

final class _ToastDecorator extends StatelessWidget {
  final Widget child;
  final Color color;

  const _ToastDecorator({required this.child, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: child,
        ),
      ),
    );
  }
}
