import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

extension WidgetExtensions on Widget {
  Widget centered() => Center(child: this);
}

extension ContextExtensions on BuildContext {
  T provider<T>({bool listen = false}) => Provider.of<T>(this, listen: listen);

  double get topPadding => this != null
      ? (MediaQuery.of(this, nullOk: true)?.padding?.top ?? 0.0)
      : 0.0;

  double get bottomPadding => this != null
      ? (MediaQuery.of(this, nullOk: true)?.padding?.bottom ?? 0.0)
      : 0.0;
}
