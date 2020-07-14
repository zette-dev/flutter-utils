import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

extension WidgetExtensions on Widget {
  Widget centered() => Center(child: this);
}

extension ContextExtensions on BuildContext {
  T provider<T>({bool listen = false}) => Provider.of<T>(this, listen: listen);
}
