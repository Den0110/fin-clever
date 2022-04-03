import 'package:flutter/services.dart' as text_input_service;
import 'package:flutter/cupertino.dart';

class UpperCaseTextFormatter extends text_input_service.TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
