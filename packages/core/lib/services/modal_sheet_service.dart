import 'dart:async';

import 'package:flutter/material.dart';

class ModalSheetService {
  const ModalSheetService();

  Future<void> showModalSheet({
    required final BuildContext context,
    required final Widget content,
    final bool isScrollControlled = true,
    final bool enabledDrag = true,
    final bool useWrapper = true,
    final VoidCallback? whenComplete,
    final bool useRootNavigator = true,
  }) async {
    return await showModalBottomSheet(
      context: context,
      useSafeArea: true,
      useRootNavigator: useRootNavigator,
      enableDrag: enabledDrag,
      isScrollControlled: isScrollControlled,
      backgroundColor: useWrapper ? Colors.transparent : Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(14))),
      builder: (context) {
        if (useWrapper) {
          return _ModalSheetWrapper(child: content);
        }

        return content;
      },
    ).whenComplete(() => whenComplete?.call());
  }

  /// Calculates initialChildSize magnitude for [DraggableScrollableSheet], clamps total value between [0.25, 1]
  /// header height - minimum 52px, listview symmetric vertical padding - 8px (multiply by 2), bottom spacing - 52px,
  /// static height is 120 pixels,
  /// each button height - 56px
  double calculateInitialChildSize({
    required final BuildContext context,
    required final int itemsCount,
    final double headerHeight = 52,
    final double verticalPadding = 8,
    final double bottomSpacing = 52,
    final double itemHeight = 57,
    final double? additionalHeight,
  }) {
    final staticHeight = headerHeight + (verticalPadding * 2) + bottomSpacing + (additionalHeight ?? 0);
    final itemsHeight = itemHeight * itemsCount;

    return ((staticHeight + itemsHeight) / MediaQuery.sizeOf(context).height).clamp(0.25, 1);
  }
}

final class _ModalSheetWrapper extends StatelessWidget {
  final Widget child;

  const _ModalSheetWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: Material(
          color: Colors.transparent,
          child: child,
        ),
      ),
    );
  }
}
