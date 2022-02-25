import 'package:dropsource_ui/dropsource_ui.dart';
import 'package:flutter/widgets.dart';

extension WidgetExtensions on Widget {
  Widget centered() => Center(child: this);

  Widget paddedSides(double padding) =>
      Padding(child: this, padding: EdgeInsets.symmetric(horizontal: padding));

  Widget slivered({EdgeInsets? padding}) {
    Widget _sliver = SliverToBoxAdapter(child: this);
    if (padding != null) {
      return SliverPadding(padding: padding, sliver: _sliver);
    }

    return _sliver;
  }
}

extension ContextExtensions on BuildContext {
  Translations? get translations => Translations.of(this);

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
