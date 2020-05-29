import 'package:flutter/material.dart';

import 'platform_widgets.dart';

class LoadingWrapper extends StatelessWidget {
  LoadingWrapper({
    Key loaderKey,
    this.children,
    this.loading,
    this.ignorePointerWhenLoading = true,
    this.loaderBrightness,
  }) : _loaderKey = loaderKey;
  final List<Widget> children;
  final bool loading, ignorePointerWhenLoading;
  final Key _loaderKey;
  final Brightness loaderBrightness;
  @override
  Widget build(BuildContext context) {
    var _children = children ?? [];
    var _loading = loading ?? false;
    if (_loading)
      _children.add(PlatformLoader(
          key: _loaderKey, centered: true, brightness: loaderBrightness));
    final _stack = Stack(
      alignment: AlignmentDirectional.center,
      children: _children,
    );
    if (ignorePointerWhenLoading ?? true && _loading) {
      return IgnorePointer(
        ignoring: _loading,
        child: _stack,
      );
    } else {
      return _stack;
    }
  }
}
