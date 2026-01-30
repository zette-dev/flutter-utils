import 'package:flutter/material.dart';

import 'platform_widgets.dart';

class LoadingWrapper extends StatelessWidget {
  const LoadingWrapper({
    super.key,
    Key? loaderKey,
    required this.children,
    this.loading,
    this.ignorePointerWhenLoading = true,
    this.loaderBrightness,
    this.loaderColor,
  }) : _loaderKey = loaderKey;

  final List<Widget> children;
  final bool? loading, ignorePointerWhenLoading;
  final Key? _loaderKey;
  final Brightness? loaderBrightness;
  final Color? loaderColor;

  @override
  Widget build(BuildContext context) {
    final isLoading = loading ?? false;
    final stackChildren = [
      ...children,
      if (isLoading)
        PlatformLoader(
          key: _loaderKey,
          centered: true,
          color: loaderColor,
          brightness: loaderBrightness ?? Brightness.light,
        ),
    ];

    final stack = Stack(
      alignment: AlignmentDirectional.center,
      children: stackChildren,
    );

    if ((ignorePointerWhenLoading ?? true) && isLoading) {
      return IgnorePointer(ignoring: true, child: stack);
    }
    return stack;
  }
}
