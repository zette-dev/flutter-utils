import 'package:zette_ui/zette_ui.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'layout.freezed.dart';

@freezed
class Layout with _$Layout {
  const factory Layout.mobile() = _Mobile;
  const factory Layout.desktop() = _Desktop;
  const factory Layout.tablet() = _Tablet;
  const Layout._();
  factory Layout.of(BuildContext context) => Layout.fromSize(context.screenSize().width);
  factory Layout.fromSize(double width, [LayoutData? data]) {
    data ??= const LayoutData();
    if (width <= data.phoneScreenBreakpoint) {
      return Layout.mobile();
    } else if (width <= data.mobileScreenBreakpoint) {
      return Layout.tablet();
    } else {
      return Layout.desktop();
    }
  }

  bool get isMobile => maybeWhen(
        orElse: () => false,
        mobile: () => true,
      );

  bool get isTablet => maybeWhen(
        orElse: () => false,
        tablet: () => true,
      );

  bool get isDesktop => maybeWhen(
        orElse: () => false,
        desktop: () => true,
      );
}

@freezed
class LayoutData with _$LayoutData {
  const factory LayoutData({
    @Default(940.0) double phoneScreenBreakpoint,
    @Default(1050.0) double mobileScreenBreakpoint,
  }) = _LayoutData;
  const LayoutData._();

  Layout layoutFromContext(BuildContext context) => Layout.fromSize(
        context.screenSize().width,
        this,
      );

  Layout layoutFromConstraints(BoxConstraints constraints) => Layout.fromSize(
        constraints.maxWidth,
        this,
      );

  bool isMobile(BoxConstraints constraints) => layoutFromConstraints(constraints).isMobile;
  bool isTablet(BoxConstraints constraints) => layoutFromConstraints(constraints).isTablet;
  bool isDesktop(BoxConstraints constraints) => layoutFromConstraints(constraints).isDesktop;

  // Less desireable, only use
  bool isMobileLookup(BuildContext context) => layoutFromContext(context).isMobile;
  bool isTabletLookup(BuildContext context) => layoutFromContext(context).isTablet;
  bool isDesktopLookup(BuildContext context) => layoutFromContext(context).isDesktop;
}

typedef AdaptiveLayoutBuilder = Widget Function(BuildContext, BoxConstraints, Layout);

class _AdaptiveLayout extends AdaptiveLayout {
  _AdaptiveLayout({
    super.builder,
    super.mobileBuilder,
    super.tabletBuilder,
    super.desktopBuilder,
  });
}

abstract class AdaptiveLayout extends LayoutBuilder {
  AdaptiveLayout({
    AdaptiveLayoutBuilder? builder,
    AdaptiveLayoutBuilder? mobileBuilder,
    AdaptiveLayoutBuilder? tabletBuilder,
    AdaptiveLayoutBuilder? desktopBuilder,
  })  : assert(builder != null || (mobileBuilder != null && tabletBuilder != null && desktopBuilder != null),
            'If builder is not specified, mobileBuilder, tabletBuilder, and dekstopBuilder must be specified'),
        super(
          builder: (ctx, constraints) {
            final layout = Layout.fromSize(
                constraints.maxWidth, ctx.themeExt<LayoutThemeExtension>()?.layoutData ?? const LayoutData());
            AdaptiveLayoutBuilder? builderMethod;
            builderMethod = layout.when(
                  mobile: () => mobileBuilder,
                  tablet: () => tabletBuilder,
                  desktop: () => desktopBuilder,
                ) ??
                builder;

            return builderMethod!.call(
              ctx,
              constraints,
              layout,
            );
          },
        );

  factory AdaptiveLayout.when({
    required AdaptiveLayoutBuilder mobileBuilder,
    required AdaptiveLayoutBuilder tabletBuilder,
    required AdaptiveLayoutBuilder desktopBuilder,
  }) =>
      _AdaptiveLayout(
        mobileBuilder: mobileBuilder,
        tabletBuilder: tabletBuilder,
        desktopBuilder: desktopBuilder,
      );

  factory AdaptiveLayout.maybeWhen({
    AdaptiveLayoutBuilder? mobileBuilder,
    AdaptiveLayoutBuilder? tabletBuilder,
    AdaptiveLayoutBuilder? desktopBuilder,
    required AdaptiveLayoutBuilder builder,
  }) =>
      _AdaptiveLayout(
        mobileBuilder: mobileBuilder,
        tabletBuilder: tabletBuilder,
        desktopBuilder: desktopBuilder,
        builder: builder,
      );
}
