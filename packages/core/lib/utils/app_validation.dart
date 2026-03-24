import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class AppValidation {
  const AppValidation._();

  static String? validatePhoneNumber(String? value, [MaskTextInputFormatter? phoneMask]) {
    if (value == null || value.isEmpty) {
      return "This field can't be empty";
    }

    if (phoneMask != null) {
      value = phoneMask.unmaskText(value);
    }

    if (value.length != 10) {
      return 'Enter correct phone number';
    }

    return null;
  }
}
