import 'package:ds_ui/src/ui/animated_card_navigator.dart';
import 'package:flutter/material.dart';

class PinKeyboard extends StatelessWidget {
  final Function(String) onPressedKey;
  final VoidCallback? onBackPressed;
  final TextStyle textStyle;
  final Decoration? keyDecoration;
  final String? code;
  final Map<String, Key>? pinKeys;
  final EdgeInsets? keyPadding;
  final IconData? backIcon;
  final Duration tapDuration;
  PinKeyboard({
    this.code,
    required this.onPressedKey,
    this.onBackPressed,
    required this.textStyle,
    this.pinKeys,
    this.keyDecoration,
    this.keyPadding,
    this.backIcon,
    this.tapDuration = const Duration(milliseconds: 70),
  });

  Widget _iconButton(String title, Key? key) => AnimatedTap(
        key: key,
        duration: tapDuration,
        child: Container(
          child: SizedBox(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                title,
                style: textStyle,
              ),
            ),
            height: textStyle.fontSize! + 2,
            width: textStyle.fontSize! + 2,
          ),
          padding: keyPadding,
          decoration: keyDecoration,
        ),
        onPressed: (_) => onPressedKey(title),
      );

  @override
  Widget build(BuildContext context) {
    final _padding = EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0);

    /// Use mediaquery textScaleFactor to ensure the pin key text does not grow
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: _padding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _iconButton('1', pinKeys?['1']),
                _iconButton('2', pinKeys?['2']),
                _iconButton('3', pinKeys?['3']),
              ],
            ),
          ),
          Padding(
            padding: _padding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _iconButton('4', pinKeys?['4']),
                _iconButton('5', pinKeys?['5']),
                _iconButton('6', pinKeys?['6']),
              ],
            ),
          ),
          Padding(
            padding: _padding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _iconButton('7', pinKeys?['7']),
                _iconButton('8', pinKeys?['8']),
                _iconButton('9', pinKeys?['9']),
              ],
            ),
          ),
          Padding(
            padding: _padding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  onPressed: null,
                  splashColor: Colors.transparent,
                  icon: SizedBox(),
                ),
                _iconButton('0', pinKeys?['0']),
                IconButton(
                  splashColor: Colors.transparent,
                  onPressed: (backIcon != null && onBackPressed != null)
                      ? onBackPressed
                      : null,
                  icon: backIcon == null
                      ? SizedBox()
                      : Icon(
                          backIcon,
                          color: textStyle.color,
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
