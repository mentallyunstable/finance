import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

final class AppInputMask {
  const AppInputMask._();

  static MaskTextInputFormatter phoneMask({String? initialText}) => MaskTextInputFormatter(
    mask: '### ### ###',
    initialText: initialText,
    filter: {'#': RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.eager,
  );
  static MaskTextInputFormatter fullPhoneMask({String? initialText}) => MaskTextInputFormatter(
    mask: '+### (###) ### ###',
    initialText: initialText,
    filter: {'#': RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.eager,
  );
}
