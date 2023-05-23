import 'package:intl/intl.dart';

extension StringFormatting on String {
  String capitalize() {
    if (isEmpty) {
      return this;
    }
    return this[0].toUpperCase() + substring(1);
  }
}

String? formatPhoneNumber(String? phoneNumber) {
  if (phoneNumber == null) {
    return '';
  }
  const digits = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'];
  final numbersOnly = phoneNumber.split('').where(digits.contains).join('');
  final length = numbersOnly.length;
  final hasLeadingOne = numbersOnly[0] == '1';
  if (length == 7 || length == 10 || (length == 11 && hasLeadingOne)) {
    final hasAreaCode = (length >= 10);
    var sourceIndex = 0;

    // Leading 1
    var leadingOne = '';
    if (hasLeadingOne) {
      leadingOne = '1 ';
      sourceIndex += 1;
    }

    // Area code
    var areaCode = '';
    if (hasAreaCode) {
      const areaCodeLength = 3;
      final areaCodeSubstring = numbersOnly.substring(sourceIndex, areaCodeLength + sourceIndex);
      areaCode = '($areaCodeSubstring)';
      sourceIndex += areaCodeLength;
    }

    // Prefix, 3 characters
    const prefixLength = 3;
    final prefix = numbersOnly.substring(sourceIndex, prefixLength + sourceIndex);
    sourceIndex += prefixLength;

    // Suffix, 4 characters
    const suffixLength = 4;
    final suffix = numbersOnly.substring(sourceIndex, suffixLength + sourceIndex);

    return '$leadingOne$areaCode $prefix-$suffix';
  } else {
    return null;
  }
}

RegExp _emailRegex = new RegExp(
    r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$");

final RegExp _numericRegex = RegExp(r'^-?[0-9]+$');

bool isNumeric(String str) {
  return _numericRegex.hasMatch(str);
}

String? emailValidator(String? emailInput, {bool isRequired = false, String errorMessage = 'Invalid Email Address'}) {
  if (!isRequired && (emailInput == null || emailInput.isEmpty)) {
    return null;
  }

  return !_emailRegex.hasMatch(emailInput!) ? errorMessage : null;
}

String numberValueAsString(String text, {int precision = 0}) {
  List<String> parts = _getOnlyNumbers(text).split('').toList(growable: true);

  if (precision > 0) {
    if (parts.length > precision) {
      parts.insert(parts.length - precision, '.');
    } else if (parts.length < precision) {
      final diff = precision - parts.length;
      List.generate(diff, (index) => index).forEach(
        (element) => parts.insert(0, element.toString()),
      );
      parts.insert(0, '.');
    } else if (parts.length == precision) {
      parts.insert(0, '0.');
    }
  }

  return parts.join();
}

double numberValue(String text, {int precision = 2}) {
  return double.parse(numberValueAsString(text, precision: precision));
}

String _getOnlyNumbers(String text) {
  String cleanedText = text;

  var onlyNumbersRegex = RegExp(r'[^\d]');

  return cleanedText.replaceAll(onlyNumbersRegex, '');
}

double parseDouble(dynamic value) {
  if (value is int) {
    return value.toDouble();
  } else if (value is double) {
    return value;
  } else {
    return value;
  }
}

final NumberFormat percentageFormatter = NumberFormat.percentPattern();