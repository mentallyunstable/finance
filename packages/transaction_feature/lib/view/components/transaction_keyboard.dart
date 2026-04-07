import 'package:flutter/material.dart';

typedef TransactionKeyboardNumberCallback = void Function(int number);
typedef TransactionKeyboardPointCallback = void Function();
typedef TransactionKeyboardRemoveCallback = void Function();

final class TransactionKeyboard extends StatelessWidget {
  final TransactionKeyboardNumberCallback onKeyPressed;
  final TransactionKeyboardPointCallback onPointPressed;
  final TransactionKeyboardRemoveCallback onRemovePressed;

  const TransactionKeyboard({
    super.key,
    required this.onKeyPressed,
    required this.onPointPressed,
    required this.onRemovePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 24,
      children: [
        Row(
          mainAxisAlignment: .center,
          spacing: 24,
          children: [1, 2, 3]
              .map(
                (number) => _NumberKeyboardButton(
                  number: number,
                  onPressed: () => onKeyPressed(number),
                ),
              )
              .toList(),
        ),
        Row(
          mainAxisAlignment: .center,
          spacing: 24,
          children: [4, 5, 6]
              .map(
                (number) => _NumberKeyboardButton(
                  number: number,
                  onPressed: () => onKeyPressed(number),
                ),
              )
              .toList(),
        ),
        Row(
          mainAxisAlignment: .center,
          spacing: 24,
          children: [7, 8, 9]
              .map(
                (number) => _NumberKeyboardButton(
                  number: number,
                  onPressed: () => onKeyPressed(number),
                ),
              )
              .toList(),
        ),
        Row(
          mainAxisAlignment: .center,
          spacing: 24,
          children: [
            _KeyboardButton(
              onTap: onPointPressed,
              child: Text(
                '.',
                style: TextTheme.of(context).headlineMedium,
              ),
            ),
            _NumberKeyboardButton(
              number: 0,
              onPressed: () => onKeyPressed(0),
            ),
            _KeyboardButton(
              onTap: onRemovePressed,
              child: Icon(
                Icons.backspace_outlined,
                color: ColorScheme.of(context).error,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

final class _NumberKeyboardButton extends StatelessWidget {
  final int number;
  final VoidCallback onPressed;

  const _NumberKeyboardButton({
    required this.number,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return _KeyboardButton(
      onTap: onPressed,
      child: Text(
        '$number',
        style: TextTheme.of(context).headlineMedium,
      ),
    );
  }
}

final class _KeyboardButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;

  const _KeyboardButton({
    required this.child,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 64,
        child: Ink(
          decoration: BoxDecoration(
            color: ColorScheme.of(context).surfaceContainerLow,
            borderRadius: const .all(.circular(24)),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: const .all(.circular(24)),
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}
