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

// class AdaptiveLayout extends LayoutBuilder {
//   AdaptiveLayout({
//     required WidgetRef ref,
//     required Widget Function(BuildContext, BoxConstraints, Layout) builder,
//   }) : super(
//           builder: (ctx, constraints) => builder(
//             ctx,
//             constraints,
//             Layout.fromSize(constraints.maxWidth, ref.read(layoutProvider)),
//           ),
//         );
