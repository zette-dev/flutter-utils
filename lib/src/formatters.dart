extension StringFormatting on String {
  String capitalize() {
    if (this == null) {
      throw ArgumentError('string: $this');
    }
    if (isEmpty) {
      return this;
    }
    return this[0].toUpperCase() + substring(1);
  }
}

String formatPhoneNumber(String phoneNumber) {
  if (phoneNumber == null) {
    return '';
  }
  final numbersOnly = phoneNumber.replaceAll(RegExp('/[^0-9]/g'), phoneNumber);
  final length = numbersOnly.length;
  final hasLeadingOne = (numbersOnly[0] ?? '') == '1';
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
      final areaCodeSubstring =
          numbersOnly.substring(sourceIndex, areaCodeLength + sourceIndex);
      areaCode = '($areaCodeSubstring)';
      sourceIndex += areaCodeLength;
    }

    // Prefix, 3 characters
    const prefixLength = 3;
    final prefix =
        numbersOnly.substring(sourceIndex, prefixLength + sourceIndex);
    sourceIndex += prefixLength;

    // Suffix, 4 characters
    const suffixLength = 4;
    final suffix =
        numbersOnly.substring(sourceIndex, suffixLength + sourceIndex);

    return '$leadingOne$areaCode $prefix-$suffix';
  } else {
    return null;
  }
}
