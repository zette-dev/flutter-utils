import 'package:flutter/material.dart';

import './pin_keyboard.dart';
import './pin_view.dart';
import 'shake_view.dart';

enum _BackButtonStyle { back, cancel }

class PinCode extends StatelessWidget {
  final Widget titleWidget;
  final Widget subtitleWidget;
  final Function(String) onCodeCompleted, onCodeUpdated;
  final Function() onCancelPressed, onBackPressed;
  final int codeLength;
  final bool clearOnCodeEntered, hideCancelWhenEmpty;
  final TextStyle keyTextStyle;
  final Decoration keyDecoration;
  final EdgeInsetsGeometry keyPadding;
  final Color outlineColor, pinFillColor, backgroundColor;
  final String pin;
  final Map<String, Key> pinKeys;
  final ShakeController shakeController;
  final double shakeBegin, shakeEnd;
  final IconData backIcon, cancelIcon;
  final Duration tapDuration;

  PinCode({
    this.titleWidget,
    this.subtitleWidget,
    this.codeLength = 6,
    this.clearOnCodeEntered = false,
    this.hideCancelWhenEmpty = true,
    this.onCodeCompleted,
    this.onCodeUpdated,
    this.onCancelPressed,
    this.onBackPressed,
    this.outlineColor = Colors.white,
    this.pinFillColor,
    this.keyTextStyle = const TextStyle(color: Colors.white, fontSize: 25.0),
    this.keyDecoration,
    this.keyPadding,
    this.backgroundColor,
    this.pin = '',
    this.pinKeys,
    this.shakeController,
    this.shakeBegin,
    this.shakeEnd,
    this.backIcon = Icons.backspace,
    this.cancelIcon = Icons.cancel,
    this.tapDuration = const Duration(milliseconds: 90),
  });

  bool get pinExists => pin != null && pin.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor ?? Theme.of(context).primaryColor,
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: titleWidget ?? Container(),
                margin: const EdgeInsets.only(bottom: 10.0),
              ),
              subtitleWidget ?? Container(),
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: shakeController != null
                ? ShakeView(
                    begin: shakeBegin,
                    end: shakeEnd,
                    child: _pinView(),
                    controller: shakeController,
                  )
                : _pinView(),
          ),
          PinKeyboard(
            pinKeys: pinKeys,
            tapDuration: tapDuration,
            textStyle: keyTextStyle,
            keyDecoration: keyDecoration,
            keyPadding: keyPadding,
            onPressedKey: (key) {
              String _pin = pin;
              if (_pin.length < codeLength) {
                _pin = pin + key;
                onCodeUpdated(_pin);
              }
              if (_pin.length == codeLength) {
                if (onCodeCompleted != null) {
                  onCodeCompleted(_pin);
                }
                if (clearOnCodeEntered) {
                  onCodeUpdated('');
                }
              }
            },
            backIcon: _backIcon,
            onBackPressed: _backIconPressed,
          ),
        ],
      ),
    );
  }

  Widget _pinView() => PinView(
        code: pin,
        outlineColor: outlineColor,
        pinFillColor: pinFillColor,
        length: codeLength,
      );

  _BackButtonStyle get _backButtonStyle {
    if (!pinExists && hideCancelWhenEmpty) {
      return null;
    } else if (pinExists) {
      return _BackButtonStyle.back;
    } else {
      return _BackButtonStyle.cancel;
    }
  }

  IconData get _backIcon {
    switch (_backButtonStyle) {
      case _BackButtonStyle.back:
        return backIcon;
      case _BackButtonStyle.cancel:
        return cancelIcon;
      default:
        return null;
    }
  }

  VoidCallback get _backIconPressed {
    switch (_backButtonStyle) {
      case _BackButtonStyle.back:
        return () {
          int codeLength = pin.length;
          if (codeLength > 0)
            this.onCodeUpdated(pin.substring(0, codeLength - 1));

          if (onBackPressed != null) this.onBackPressed();
        };
      case _BackButtonStyle.cancel:
        return onCancelPressed;
      default:
        return null;
    }
  }
}
