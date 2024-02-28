import 'package:ds_ui/ds_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'layout.freezed.dart';

@freezed
class Layout with _$Layout {
  const factory Layout.mobile() = _Mobile;
  const factory Layout.desktop() = _Desktop;
  const factory Layout.tablet() = _Tablet;

  factory Layout.fromSize(double width, LayoutData data) {
    if (width <= data.phoneScreenBreakpoint) {
      return Layout.mobile();
    } else if (width <= data.mobileScreenBreakpoint) {
      return Layout.tablet();
    } else {
      return Layout.desktop();
    }
  }
}

@freezed
class LayoutData with _$LayoutData {
  const factory LayoutData({
    @Default(940.0) double phoneScreenBreakpoint,
    @Default(1050.0) double mobileScreenBreakpoint,
    Layout? layout,
  }) = _LayoutData;
  const LayoutData._();

  Layout getLayout(BuildContext context) =>
      layout ??
      Layout.fromSize(
        context.screenSize().width,
        this,
      );

  bool isMobile(BuildContext context) => getLayout(context).maybeWhen(
        orElse: () => false,
        mobile: () => true,
      );
  bool isTablet(BuildContext context) => getLayout(context).maybeWhen(
        orElse: () => false,
        tablet: () => true,
      );
  bool isDesktop(BuildContext context) => getLayout(context).maybeWhen(
        orElse: () => false,
        desktop: () => true,
      );
}

final layoutProvider = StateProvider<LayoutData>((ref) => LayoutData());

typedef AdaptiveLayoutBuilder = Widget Function(BuildContext, LayoutData);

class _AdaptiveLayout extends AdaptiveLayout {
  _AdaptiveLayout({
    required super.ref,
    super.builder,
    super.mobileBuilder,
    super.tabletBuilder,
    super.desktopBuilder,
  });
}

abstract class AdaptiveLayout extends LayoutBuilder {
  AdaptiveLayout({
    required WidgetRef ref,
    AdaptiveLayoutBuilder? builder,
    AdaptiveLayoutBuilder? mobileBuilder,
    AdaptiveLayoutBuilder? tabletBuilder,
    AdaptiveLayoutBuilder? desktopBuilder,
  })  : assert(builder != null || (mobileBuilder != null && tabletBuilder != null && desktopBuilder != null),
            'If builder is not specified, mobileBuilder, tabletBuilder, and dekstopBuilder must be specified'),
        super(
          builder: (ctx, constraints) {
            final layout = Layout.fromSize(constraints.maxWidth, ref.read(layoutProvider));
            AdaptiveLayoutBuilder? builderMethod;
            builderMethod = layout.when(
                  mobile: () => mobileBuilder,
                  tablet: () => tabletBuilder,
                  desktop: () => desktopBuilder,
                ) ??
                builder;

            return builderMethod!.call(
              ctx,
              ref.read(layoutProvider).copyWith(layout: layout),
            );
          },
        );

  factory AdaptiveLayout.when(
    WidgetRef ref, {
    required AdaptiveLayoutBuilder mobileBuilder,
    required AdaptiveLayoutBuilder tabletBuilder,
    required AdaptiveLayoutBuilder desktopBuilder,
  }) =>
      _AdaptiveLayout(
        ref: ref,
        mobileBuilder: mobileBuilder,
        tabletBuilder: tabletBuilder,
        desktopBuilder: desktopBuilder,
      );

  factory AdaptiveLayout.maybeWhen(
    WidgetRef ref, {
    AdaptiveLayoutBuilder? mobileBuilder,
    AdaptiveLayoutBuilder? tabletBuilder,
    AdaptiveLayoutBuilder? desktopBuilder,
    required AdaptiveLayoutBuilder builder,
  }) =>
      _AdaptiveLayout(
        ref: ref,
        mobileBuilder: mobileBuilder,
        tabletBuilder: tabletBuilder,
        desktopBuilder: desktopBuilder,
        builder: builder,
      );
}