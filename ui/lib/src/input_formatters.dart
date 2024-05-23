import 'package:flutter/services.dart';
import 'package:zette_ui/src/formatters.dart';

class MaskedTextInputFormatter extends TextInputFormatter {
  final String mask;
  final String separator;

  MaskedTextInputFormatter({
    required this.mask,
    required this.separator,
  });

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isNotEmpty) {
      if (newValue.text.length > oldValue.text.length) {
        if (newValue.text.length > mask.length) {
          return oldValue;
        }
        if (newValue.text.length < mask.length &&
            mask[newValue.text.length - 1] == separator) {
          return TextEditingValue(
            text:
                '${oldValue.text}$separator${newValue.text.substring(newValue.text.length - 1)}',
            selection: TextSelection.collapsed(
              offset: newValue.selection.end + 1,
            ),
          );
        }
      }
    }
    return newValue;
  }
}


class PercentageTextInputFormatter extends TextInputFormatter {
  String _stripStartingZero(String str) =>
      str.startsWith('0') ? str.substring(1, str.length) : str;

  String _sanitize(String str) => List<String Function(String)>.from(
          [numberValueAsString, _stripStartingZero])
      .fold<String>(str, (previousValue, func) => func(previousValue));

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final _new = _sanitize(newValue.text);
    String returnValue = _new.isEmpty ? '0' : _new;
    double _intValue = int.parse(returnValue) / 100;
    final result = percentageFormatter.format(_intValue);
    return TextEditingValue(
      text: result,
      selection: TextSelection.collapsed(
        offset: result.length - 1,
      ),
    );
  }
}
