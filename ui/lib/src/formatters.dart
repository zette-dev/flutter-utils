import 'package:intl/intl.dart';

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

final NumberFormat percentageFormatter = NumberFormat.percentPattern();

String? formatAudioDuration(Duration? duration) {
  if (duration == null) return null;
  String output = duration.toString().split('.').first.padLeft(8, '0');
  if (output.startsWith('00:')) {
    output = output.substring(3);
  }

  return output;
}