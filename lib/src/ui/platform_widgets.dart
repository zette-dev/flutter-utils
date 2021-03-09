import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformWidget extends StatelessWidget {
  PlatformWidget({required this.ios, required this.android});
  final Widget Function(BuildContext) ios;
  final Widget Function(BuildContext) android;
  @override
  Widget build(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.android
        ? android(context)
        : ios(context);
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
  });
  final List<BottomNavigationBarItem> items;
  final Color? activeColor;
  final Color inactiveColor;
  final Color? backgroundColor;
  final int currentIndex;
  final Function(int)? onTap;
  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      ios: (context) => CupertinoTabBar(
        backgroundColor: backgroundColor,
        activeColor: activeColor,
        inactiveColor: inactiveColor,
        items: items,
        onTap: onTap,
        currentIndex: currentIndex,
      ),
      android: (context) => Theme(
        data: Theme.of(context).copyWith(
          // sets the background color of the `BottomNavigationBar`
          canvasColor: backgroundColor,
          textTheme: Theme.of(context).textTheme.copyWith(
                caption: TextStyle(
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
  }) : super(key: key);
  final bool? centered;
  final Color? color;
  final Brightness brightness;
  final double size;

  @override
  Widget build(BuildContext context) {
    final _widget = PlatformWidget(
      ios: (context) => CupertinoTheme(
        child: CupertinoActivityIndicator(
          animating: true,
          radius: size,
        ),
        data: CupertinoTheme.of(context).copyWith(brightness: brightness),
      ),
      android: (context) => CircularProgressIndicator(
          valueColor:
              color != null ? AlwaysStoppedAnimation<Color>(color!) : null),
    );

    if (centered ?? false) {
      return Center(child: _widget);
    } else {
      return _widget;
    }
  }
}

class PlatformButton extends StatelessWidget {
  PlatformButton({
    Key? key,
    required this.child,
    required this.onPressed,
    this.color,
    this.disabledColor,
    this.padding,
    this.borderRadius = const BorderRadius.all(Radius.zero),
  }) : super(key: key);
  final Widget child;
  final void Function() onPressed;
  final Color? color;
  final Color? disabledColor;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      ios: (ctx) => CupertinoButton(
        child: child,
        onPressed: onPressed,
        color: color,
        disabledColor: disabledColor ?? CupertinoColors.quaternarySystemFill,
        pressedOpacity: 0.9,
        borderRadius: borderRadius,
        padding: padding ?? Theme.of(context).buttonTheme.padding,
      ),
      android: (ctx) => FlatButton(
        child: child,
        onPressed: onPressed,
        color: color,
        textTheme: ButtonTextTheme.primary,
        disabledColor: disabledColor,
        padding: padding ?? Theme.of(context).buttonTheme.padding,
      ),
    );
  }
}

Route<T> platformRoute<T>(
  BuildContext context, {
  required WidgetBuilder builder,
  RouteSettings? settings,
  bool fullscreenDialog = false,
}) {
  if (Theme.of(context).platform == TargetPlatform.iOS) {
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

Future<T?> showPlatformDialog<T>(BuildContext context,
    {String? title, String? content, List<Widget>? actions}) {
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

void showPlatformBottomSheet(BuildContext context,
    {List<Widget>? actions, TextStyle? style}) {
  if (Theme.of(context).platform == TargetPlatform.iOS) {
    showCupertinoModalPopup(
        context: context,
        builder: (ctx) => CupertinoActionSheet(
              cancelButton: PlatformButton(
                key: Key('bottom-sheet-cancel-button'),
                child: Text('Cancel', style: style),
                onPressed: () => Navigator.of(ctx).pop(),
              ),
              actions: actions ?? [],
            ));
  } else {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: actions ?? [],
      ),
    );
  }
}
