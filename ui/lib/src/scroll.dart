import 'package:flutter/material.dart';

ScrollPhysics platformScrollPhysics(BuildContext context) => Theme.of(context).platform == TargetPlatform.iOS
    ? BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      )
    : CustomClampingScrollPhysics(canUnderscroll: true, canOverscroll: true);

class CustomClampingScrollPhysics extends ClampingScrollPhysics {
  const CustomClampingScrollPhysics({
    ScrollPhysics? parent,
    this.canUnderscroll = false,
    this.canOverscroll = false,
  }) : super(parent: parent);

  final bool canUnderscroll;

  final bool canOverscroll;

  @override
  ClampingScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomClampingScrollPhysics(
        parent: buildParent(ancestor), canUnderscroll: canUnderscroll, canOverscroll: canOverscroll);
  }

  /// Removes the overscroll and underscroll conditions from the original
  /// [ClampingScrollPhysics.applyBoundaryConditions].
  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    if (value < position.pixels && position.pixels <= position.minScrollExtent) // underscroll
      return canUnderscroll ? 0.0 : value - position.pixels;
    if (position.maxScrollExtent <= position.pixels && position.pixels < value) // overscroll
      return canOverscroll ? 0.0 : value - position.pixels;
    if (value < position.minScrollExtent && position.minScrollExtent < position.pixels) // hit top edge
      return value - position.minScrollExtent;
    if (position.pixels < position.maxScrollExtent && position.maxScrollExtent < value) // hit bottom edge
      return value - position.maxScrollExtent;
    return 0.0;
  }
}
