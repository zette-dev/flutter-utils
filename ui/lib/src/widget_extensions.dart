// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

extension WidgetExtensions on Widget {
  Widget centered() => Center(child: this);

  Widget expanded({bool expanded = true}) => expanded ? Expanded(child: this) : this;

  Widget semantic([String? label]) => Semantics(child: this, label: label);

  Widget paddedSides(double padding) => Padding(child: this, padding: EdgeInsets.symmetric(horizontal: padding));

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

  Widget providerScoped({
    List<Override> overrides = const [],
    List<ProviderObserver> observers = const [],
  }) =>
      ProviderScope(
        child: this,
        overrides: overrides,
        observers: observers,
      );
}

extension ContextExtensions on BuildContext {
  void popToRoot([RoutePredicate? predicate]) => Navigator.maybeOf(this, rootNavigator: true)?.popUntil((r) {
        if (predicate != null) {
          return predicate(r) || r.isFirst;
        }

        return r.isFirst;
      });
}

extension StateExtensions<T extends StatefulWidget> on State<T> {
  void safeSetState(VoidCallback fn) => mounted ? setState(fn) : null;
}

extension ConsumerStateExtensions<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  void safeSetState(VoidCallback fn) => mounted ? setState(fn) : null;
}
