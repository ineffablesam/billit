import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CommaInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Remove all non-digit characters from the input
    final cleanString = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Check if the cleaned string is empty
    if (cleanString.isEmpty) {
      return TextEditingValue();
    }

    // Format the number with commas
    final doubleValue = double.tryParse(cleanString);
    final formattedString = NumberFormat('#,###').format(doubleValue);

    // Return the formatted value
    return TextEditingValue(
      text: formattedString,
      selection: TextSelection.collapsed(offset: formattedString.length),
    );
  }
}
