import 'package:ds_ui/ds_ui.dart';
import 'package:ds_ui/src/ref_like.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PlatformWidget extends StatelessWidget {
  PlatformWidget({required this.ios, required this.android});
  final Widget Function(BuildContext) ios;
  final Widget Function(BuildContext) android;
  @override
  Widget build(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.android ? android(context) : ios(context);
  }
}

class PlatformTabBar extends StatelessWidget {
  PlatformTabBar({
    required this.items,
    this.activeColor,
    required this.inactiveColor,
    this.backgroundColor,
    required this.currentIndex,
    this.onTap,
    this.labelTextStyle,
    this.height,
  });
  final List<BottomNavigationBarItem> items;
  final Color? activeColor;
  final Color inactiveColor;
  final Color? backgroundColor;
  final int currentIndex;
  final Function(int)? onTap;
  final TextStyle? labelTextStyle;
  final double? height;
  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      ios: (context) => CupertinoTheme(
        data: CupertinoThemeData(
          textTheme: CupertinoTextThemeData(
            tabLabelTextStyle: labelTextStyle,
          ),
        ),
        child: CupertinoTabBar(
          backgroundColor: backgroundColor,
          activeColor: activeColor,
          inactiveColor: inactiveColor,
          items: items,
          onTap: onTap,
          currentIndex: currentIndex,
          height: height ?? kBottomNavigationBarHeight,
        ),
      ),
      android: (context) => SizedBox(
        height: height ?? kBottomNavigationBarHeight,
        child: Theme(
          data: Theme.of(context).copyWith(
            // sets the background color of the `BottomNavigationBar`
            canvasColor: backgroundColor,
            textTheme: Theme.of(context).textTheme.copyWith(
                  bodySmall: TextStyle(
                    color: inactiveColor,
                  ),
                ),
          ), // sets the inactive color of the `BottomNavigationBar`
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            fixedColor: activeColor,
            currentIndex: currentIndex,
            onTap: onTap,
            items: items,
          ),
        ),
      ),
    );
  }
}

class PlatformSwitch extends StatelessWidget {
  PlatformSwitch({
    required this.value,
    required this.onChanged,
    this.activeColor,
    this.materialTapTargetSize,
  });
  final bool value;
  final Function(bool) onChanged;
  final Color? activeColor;
  final MaterialTapTargetSize? materialTapTargetSize;
  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      ios: (context) => CupertinoSwitch(
        value: value,
        onChanged: onChanged,
        activeColor: activeColor,
      ),
      android: (context) => Switch(
        value: value,
        onChanged: onChanged,
        activeColor: activeColor,
        materialTapTargetSize: materialTapTargetSize,
      ),
    );
  }
}

class PlatformLoader extends StatelessWidget {
  const PlatformLoader({
    Key? key,
    this.color,
    this.centered,
    this.brightness = Brightness.light,
    this.size = 15.0,
    this.progress,
  }) : super(key: key);
  final bool? centered;
  final Color? color;
  final Brightness brightness;
  final double size;
  final double? progress;

  @override
  Widget build(BuildContext context) {
    final _widget = PlatformWidget(
      ios: (context) => CupertinoTheme(
        child: progress != null
            ? CupertinoActivityIndicator.partiallyRevealed(radius: size, progress: progress!)
            : CupertinoActivityIndicator(
                animating: true,
                radius: size,
              ),
        data: CupertinoTheme.of(context).copyWith(brightness: brightness),
      ),
      android: (context) => SizedBox(
        height: size * 2,
        width: size * 2,
        child: CircularProgressIndicator(
          value: progress,
          valueColor: color != null ? AlwaysStoppedAnimation<Color>(color!) : null,
        ),
      ),
    );

    if (centered ?? false) {
      return Center(child: _widget);
    } else {
      return _widget;
    }
  }
}

class PlatformSliverRefreshControl extends CupertinoSliverRefreshControl {
  PlatformSliverRefreshControl({Future Function()? onRefresh, Color? refreshColor, double radius = 14.0})
      : super(
            onRefresh: onRefresh,
            builder: (
              ctx,
              refreshState,
              pulledExtent,
              refreshTriggerPullDistance,
              refreshIndicatorExtent,
            ) {
              final double percentageComplete = (pulledExtent / refreshTriggerPullDistance).clamp(0.0, 1.0);

              // Place the indicator at the top of the sliver that opens up. Note that we're using
              // a Stack/Positioned widget because the CupertinoActivityIndicator does some internal
              // translations based on the current size (which grows as the user drags) that makes
              // Padding calculations difficult. Rather than be reliant on the internal implementation
              // of the activity indicator, the Positioned widget allows us to be explicit where the
              // widget gets placed. Also note that the indicator should appear over the top of the
              // dragged widget, hence the use of Overflow.visible.
              return Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    Positioned(
                      top: 16,
                      width: radius,
                      height: radius,
                      // left: 0.0,
                      // right: 0.0,
                      child: Builder(
                        builder: (ctx) {
                          switch (refreshState) {
                            case RefreshIndicatorMode.drag:
                              // While we're dragging, we draw individual ticks of the spinner while simultaneously
                              // easing the opacity in. Note that the opacity curve values here were derived using
                              // Xcode through inspecting a native app running on iOS 13.5.
                              const Curve opacityCurve = Interval(0.0, 0.35, curve: Curves.easeInOut);
                              return Opacity(
                                opacity: opacityCurve.transform(percentageComplete),
                                child: PlatformLoader(color: refreshColor, size: radius, progress: percentageComplete),
                              );
                            case RefreshIndicatorMode.armed:
                            case RefreshIndicatorMode.refresh:
                              // Once we're armed or performing the refresh, we just show the normal spinner.
                              return PlatformLoader(size: radius, color: refreshColor);
                            case RefreshIndicatorMode.done:
                              // When the user lets go, the standard transition is to shrink the spinner.
                              return PlatformLoader(
                                size: radius * percentageComplete,
                                color: refreshColor,
                              );
                            case RefreshIndicatorMode.inactive:
                              // Anything else doesn't show anything.
                              return Container();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              );
            });
}

Route<T> platformRoute<T>(
  BuildContext context,
  RefLike ref, {
  required WidgetBuilder builder,
  RouteSettings? settings,
  bool fullscreenDialog = false,
  bool Function(BuildContext, LayoutData)? useDialogWhen,
}) {
  LayoutData layoutData = ref.read(layoutProvider);
  layoutData = layoutData.copyWith(layout: layoutData.getLayout(context));
  if ((useDialogWhen?.call(context, layoutData) ?? false)) {
    return DialogRoute(
      context: context,
      builder: (ctx) => Dialog(
        child: builder(ctx),
        insetPadding: EdgeInsets.symmetric(
          horizontal: layoutData.isDesktop(context) ? (context.screenSize().width - 800) / 2 : 5,
          vertical: layoutData.isDesktop(context) ? 50 : 25,
        ),
      ),
      barrierDismissible: false,
      settings: settings,
      traversalEdgeBehavior: TraversalEdgeBehavior.closedLoop,
    );
  } else if (context.isIOS) {
    return CupertinoPageRoute<T>(
      builder: builder,
      settings: settings,
      fullscreenDialog: fullscreenDialog,
    );
  } else {
    return MaterialPageRoute<T>(
      builder: builder,
      settings: settings,
      fullscreenDialog: fullscreenDialog,
    );
  }
}

Page platformPage(
  BuildContext context,
  RefLike ref,
  GoRouterState state, {
  required Widget child,
  bool fullscreenDialog = false,
  bool Function(BuildContext, LayoutData)? useDialogWhen,
}) {
  LayoutData layoutData = ref.read(layoutProvider);
  layoutData = layoutData.copyWith(layout: layoutData.getLayout(context));

  if ((useDialogWhen?.call(context, layoutData) ?? false)) {
    return DialogPage(
      builder: (context) => child,
    );
  } else if (kIsWeb) {
    return NoTransitionPage(
      name: state.name,
      child: child,
    );
  } else if (context.isIOS) {
    return CupertinoPage(
      child: child,
      name: state.name,
      fullscreenDialog: fullscreenDialog,
    );
  } else {
    return MaterialPage(
      child: child,
      name: state.name,
      fullscreenDialog: fullscreenDialog,
    );
  }
}

Future<T?> showPlatformDialog<T>(BuildContext context, {String? title, String? content, List<Widget>? actions}) {
  final _title = title != null ? Text(title) : null;
  final _content = content != null ? Text(content) : null;

  return showDialog<T>(
      context: context,
      builder: (_) {
        if (Theme.of(context).platform == TargetPlatform.iOS) {
          return CupertinoAlertDialog(
            title: _title,
            content: _content,
            actions: actions ?? [],
          );
        } else {
          return AlertDialog(
            title: _title,
            content: _content,
            actions: actions ?? [],
          );
        }
      });
}

/// A dialog page with Material entrance and exit animations, modal barrier color,
/// and modal barrier behavior (dialog is dismissible with a tap on the barrier).
class DialogPage<T> extends Page<T> {
  final Offset? anchorPoint;
  final Color? barrierColor;
  final bool barrierDismissible;
  final String? barrierLabel;
  final bool useSafeArea;
  final CapturedThemes? themes;
  final WidgetBuilder builder;

  const DialogPage({
    required this.builder,
    this.anchorPoint,
    this.barrierColor = Colors.black54,
    this.barrierDismissible = true,
    this.barrierLabel,
    this.useSafeArea = true,
    this.themes,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  });

  @override
  Route<T> createRoute(BuildContext context) => DialogRoute<T>(
      context: context,
      settings: this,
      builder: builder,
      anchorPoint: anchorPoint,
      barrierColor: barrierColor,
      barrierDismissible: barrierDismissible,
      barrierLabel: barrierLabel,
      useSafeArea: useSafeArea,
      themes: themes);
}
