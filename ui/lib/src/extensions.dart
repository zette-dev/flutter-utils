// ignore_for_file: invalid_use_of_protected_member

import 'dart:convert';

import 'package:ds_ui/ds_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

extension WidgetExtensions on Widget {
  Widget centered() => Center(child: this);

  Widget expanded({bool expanded = true}) => expanded ? Expanded(child: this) : this;

  Widget semantic([String? identifier, String? label]) => identifier != null
      ? Semantics(
          key: ValueKey(identifier),
          identifier: identifier,
          label: label,
          child: this,
        )
      : this;

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

extension Base64String on String {
  String toBase64() => base64.encode(utf8.encode(this));
  String fromBase64() => utf8.decode(base64.decode(this));
}

extension FocusScopeExt on BuildContext {
  void closeKeyboard() => FocusScope.of(this).requestFocus(FocusNode());
}

extension ThemeExt on BuildContext {
  T? themeExt<T>() => theme().extension<T>();
  LayoutThemeExtension? layoutExt() => themeExt<LayoutThemeExtension>();
  LayoutData? layoutData() => themeExt<LayoutThemeExtension>()?.layoutData;
  Layout? layout() => layoutData()?.layoutFromContext(this);
  ThemeData theme() => Theme.of(this);
  TextTheme textTheme() => theme().textTheme;
  InputDecorationTheme inputDecorationTheme() => theme().inputDecorationTheme;

  bool get isAndroid => theme().platform == TargetPlatform.android;
  bool get isIOS => theme().platform == TargetPlatform.iOS;
}

extension MediaDatExt on BuildContext {
  MediaQueryData mediaData() => MediaQuery.of(this);
  Size screenSize() => mediaData().size;
  TextScaler textScaler() => mediaData().textScaler;
  EdgeInsets padding() => mediaData().padding;
  EdgeInsets viewInsets() => mediaData().viewInsets;
}

extension AsyncValueHelper<T> on AsyncValue<T> {
  bool get shouldDisplayLoading => isLoading && !isRefreshing;
}
