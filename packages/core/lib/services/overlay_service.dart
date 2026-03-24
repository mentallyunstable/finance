import 'package:flutter/material.dart';

final class OverlayService {
  OverlayService();

  OverlayEntry? _overlayEntry;

  OverlayEntry showOverlay({required final BuildContext context, required final Widget content}) {
    final overlay = OverlayEntry(builder: (context) => content);

    Overlay.of(context).insert(overlay);

    return _overlayEntry = overlay;
  }

  void removeLast() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
