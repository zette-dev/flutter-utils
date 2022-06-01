import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'layout.freezed.dart';

@JsonEnum()
enum Layout {
  mobile,
  tablet,
  desktop;

  factory Layout.fromSize(double width, LayoutData data) {
    if (width <= data.phoneScreenBreakpoint) {
      return Layout.mobile;
    } else if (width <= data.mobileScreenBreakpoint) {
      return Layout.tablet;
    } else {
      return Layout.desktop;
    }
  }
}

class _LayoutNotifier extends StateNotifier<LayoutData> {
  _LayoutNotifier() : super(LayoutData());
}

@freezed
class LayoutData with _$LayoutData {
  const factory LayoutData({
    @Default(480.0) double phoneScreenBreakpoint,
    @Default(768.0) double mobileScreenBreakpoint,
    @Default(992.0) double laptopScreenBreakpoint,
    BoxConstraints? constraints,
  }) = _LayoutData;
  const LayoutData._();

  Layout? get layout =>
      constraints != null ? Layout.fromSize(constraints!.maxWidth, this) : null;

  bool get hasLayout => constraints != null && layout != null;

  bool get isMobile => layout == Layout.mobile;
  bool get isTablet => layout == Layout.tablet;
  bool get isDesktop => layout == Layout.desktop;
}

final layoutProvider = StateNotifierProvider<_LayoutNotifier, LayoutData>(
    (ref) => _LayoutNotifier());

typedef AdaptiveLayoutBuilder = Widget Function(
    BuildContext, BoxConstraints, Layout);

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
  })  : assert(
            builder != null ||
                (mobileBuilder != null &&
                    tabletBuilder != null &&
                    desktopBuilder != null),
            'If builder is not specified, mobileBuilder, tabletBuilder, and dekstopBuilder must be specified'),
        super(
          builder: (ctx, constraints) {
            final layout =
                Layout.fromSize(constraints.maxWidth, ref.read(layoutProvider));
            AdaptiveLayoutBuilder? builderMethod;
            switch (layout) {
              case Layout.mobile:
                builderMethod = mobileBuilder ?? builder;
                break;
              case Layout.tablet:
                builderMethod = tabletBuilder ?? builder;
                break;
              case Layout.desktop:
                builderMethod = desktopBuilder ?? builder;
                break;
            }

            return builderMethod!.call(
              ctx,
              constraints,
              Layout.fromSize(constraints.maxWidth, ref.read(layoutProvider)),
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
