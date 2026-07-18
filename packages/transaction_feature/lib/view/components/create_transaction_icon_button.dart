import 'package:design_system/components/buttons/gradient_decoration_button.dart';
import 'package:flutter/material.dart';

final class CreateTransactionIconButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CreateTransactionIconButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 80,
      child: GradientDecorationButton(
        onPressed: onPressed,
        child: Icon(
          Icons.check,
          size: 32,
          color: ColorScheme.of(context).onPrimary,
        ),
      ),
    );
  }
}
