import 'dart:ui';

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    String _hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      _hexColor = 'FF$_hexColor';
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}