import 'package:flutter/material.dart';

class InlineErrorView extends StatelessWidget {
  InlineErrorView({
    Key? key,
    required this.text,
    this.backgroundColor = Colors.red,
    this.textStyle,
    this.padding = const EdgeInsets.all(10.0),
    this.margin = const EdgeInsets.only(top: 10.0, bottom: 0),
  }) : super(key: key);
  final String text;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry padding, margin;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      color: backgroundColor ?? Theme.of(context).errorColor,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: textStyle ?? TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }
}
