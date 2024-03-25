import 'dart:ui' as ui show lerpDouble;

import 'package:ds_ui/ds_ui.dart';
import 'package:flutter/material.dart';

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
        phoneScreenBreakpoint: ui.lerpDouble(
          layoutData.phoneScreenBreakpoint,
          other.layoutData.phoneScreenBreakpoint,
          t,
        )!,
        mobileScreenBreakpoint: ui.lerpDouble(
          layoutData.mobileScreenBreakpoint,
          other.layoutData.mobileScreenBreakpoint,
          t,
        )!,
      ),
    );
  }
}