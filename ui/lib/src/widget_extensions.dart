// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/widgets.dart';

extension WidgetExtensions on Widget {
  Widget centered() => Center(child: this);

  Widget expanded() => Expanded(child: this);

  Widget paddedSides(double padding) =>
      Padding(child: this, padding: EdgeInsets.symmetric(horizontal: padding));

  Widget withPadding(EdgeInsets padding) => Padding(
        child: this,
        padding: padding,
      );

  Widget slivered({EdgeInsets? padding}) {
    Widget _sliver = SliverToBoxAdapter(child: this);
    if (padding != null) {
      return SliverPadding(padding: padding, sliver: _sliver);
    }

    return _sliver;
  }
}

extension ContextExtensions on BuildContext {
  void popToRoot([RoutePredicate? predicate]) =>
      Navigator.of(this, rootNavigator: true).popUntil((r) {
        if (predicate != null) {
          return predicate(r) || r.isFirst;
        }

        return r.isFirst;
      });
}

extension StateExtensions<T extends StatefulWidget> on State<T> {
  void safeSetState(VoidCallback fn) => mounted ? setState(fn) : null;
}
