import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

extension WidgetExtensions on Widget {
  Widget centered() => Center(child: this);

  Widget paddedSides(double padding) =>
      Padding(child: this, padding: EdgeInsets.symmetric(horizontal: padding));

  Widget slivered({EdgeInsets padding}) {
    Widget _sliver = SliverToBoxAdapter(child: this);
    if (padding != null) {
      return SliverPadding(padding: padding, sliver: _sliver);
    }

    return _sliver;
  }
}

extension ContextExtensions on BuildContext {
  T provider<T>({bool listen = false}) => Provider.of<T>(this, listen: listen);
}
