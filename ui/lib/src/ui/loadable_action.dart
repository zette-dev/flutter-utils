import 'package:ds_ui/src/extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LoadableAction<T> extends StatefulWidget {
  const LoadableAction({
    super.key,
    this.action,
    required this.builder,
  });
  final AsyncValueSetter<BuildContext>? action;
  final Widget Function(BuildContext, bool, [AsyncValueSetter<BuildContext>?]) builder;

  @override
  State<LoadableAction<T>> createState() => _LoadableActionState<T>();
}

class _LoadableActionState<T> extends State<LoadableAction<T>> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) => widget.builder(
        context,
        _isLoading,
        widget.action != null
            ? (ctx) async {
                safeSetState(() => _isLoading = true);
                await widget.action!(ctx);
                safeSetState(() => _isLoading = false);
              }
            : null,
      );
}
