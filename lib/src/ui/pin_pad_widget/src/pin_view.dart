import 'dart:core';

import 'package:flutter/material.dart';

class PinView extends StatelessWidget {
  PinView({this.code, this.length = 6, this.outlineColor, this.pinFillColor});
  final String code;
  final int length;
  final Color outlineColor, pinFillColor;

  Widget _buildItem(bool isEmpty) {
    return Container(
      height: 14,
      width: 14,
      padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
      margin: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: isEmpty ? Colors.transparent : (pinFillColor ?? outlineColor),
        border: Border.all(
            color: isEmpty ? outlineColor : (pinFillColor ?? outlineColor)),
        borderRadius: BorderRadius.circular(7.0),
      ),
    );
  }

  _getCodeViews() {
    List<Widget> widgets = [];
    for (var i = 0; i < length; i++) {
      final int index = i + 1;
      widgets.add(
        _buildItem(code == null || code.length < index),
      );
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _getCodeViews(),
    );
  }
}
