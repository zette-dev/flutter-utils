import 'dart:ui' as ui show lerpDouble;

import 'package:flutter/material.dart';
import 'package:zette_ui/zette_ui.dart';

class LayoutThemeExtension extends ThemeExtension<LayoutThemeExtension> {
  final LayoutData layoutData;

  LayoutThemeExtension({
    required this.layoutData,
  });

  @override
  ThemeExtension<LayoutThemeExtension> copyWith({LayoutData? layoutData}) => LayoutThemeExtension(
        layoutData: layoutData ?? this.layoutData,
      );

  @override
  ThemeExtension<LayoutThemeExtension> lerp(covariant ThemeExtension<LayoutThemeExtension>? other, double t) {
    if (other is! LayoutThemeExtension) {
      return this;
    }
    return LayoutThemeExtension(
      layoutData: LayoutData(
        compactScreen: ui.lerpDouble(
          layoutData.compactScreen,
          other.layoutData.compactScreen,
          t,
        )!,
        mediumScreen: ui.lerpDouble(
          layoutData.mediumScreen,
          other.layoutData.mediumScreen,
          t,
        )!,
        expandedScreen: ui.lerpDouble(
          layoutData.expandedScreen,
          other.layoutData.expandedScreen,
          t,
        )!,
        largeScreen: ui.lerpDouble(
          layoutData.largeScreen,
          other.layoutData.largeScreen,
          t,
        )!,
      ),
    );
  }
}
