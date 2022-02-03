import 'dart:async';

import 'package:dropsource_ui/dropsource_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

typedef OnInitCallback<M> = void Function(M manager);
typedef InitialDataCreator<M, T> = T Function(M manager);
typedef StreamCreator<M, T> = Stream<T> Function(M manager);
typedef IgnoreChangeTest<T> = bool Function(T model);

typedef _Builder<M, T> = Widget Function(
  BuildContext,
  M manager,
  T model,
);
typedef OnDisposeCallback<M> = void Function(
  M manager,
);
typedef OnWillChangeCallback<M> = void Function(M manager);
typedef OnInitialBuildCallback<M> = void Function(M manager);

class StatefulStreamBuilder<M, T> extends StatelessWidget {
  final _Builder<M, T> builder;
  final InitialDataCreator<M, T> initialData;
  final StreamCreator<M, T> stream;
  final IgnoreChangeTest<T>? ignoreChange;
  final OnInitCallback<M>? onInit;
  final OnDisposeCallback<M>? onDispose;
  final OnInitialBuildCallback<M>? onInitialBuild;
  const StatefulStreamBuilder({
    Key? key,
    required this.builder,
    required this.stream,
    required this.initialData,
    this.ignoreChange,
    this.onInit,
    this.onDispose,
    this.onInitialBuild,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _StatefulLifecycleManager<M, T>(
      builder: builder,
      manager: Provider.of<M>(context, listen: false),
      stream: stream,
      ignoreChange: ignoreChange,
      initialData: initialData,
      onInit: onInit,
      onDispose: onDispose,
      onInitialBuild: onInitialBuild,
    );
  }
}

class _StatefulLifecycleManager<M, T> extends StatefulWidget {
  final M manager;
  final _Builder<M, T> builder;
  final InitialDataCreator<M, T> initialData;
  final StreamCreator<M, T> stream;
  final IgnoreChangeTest<T>? ignoreChange;
  final OnInitCallback<M>? onInit;
  final OnDisposeCallback<M>? onDispose;
  final OnInitialBuildCallback<M>? onInitialBuild;

  const _StatefulLifecycleManager({
    Key? key,
    required this.builder,
    required this.stream,
    required this.manager,
    required this.initialData,
    this.onInit,
    this.onDispose,
    this.ignoreChange,
    this.onInitialBuild,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _StatefulLifecycleManagerState<M, T>();
  }
}

class _StatefulLifecycleManagerState<M, T>
    extends State<_StatefulLifecycleManager<M, T>> with AfterLayoutMixin {
  @override
  void initState() {
    super.initState();
    widget.onInit?.call(widget.manager);
  }

  @override
  void afterFirstLayout(BuildContext context) {
    widget.onInitialBuild?.call(widget.manager);
  }

  @override
  void dispose() {
    super.dispose();
    widget.onDispose?.call(widget.manager);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      initialData: widget.initialData(widget.manager),
      stream: _createStream(),
      builder: (ctx, snapshot) =>
          widget.builder(ctx, widget.manager, snapshot.data!),
    );
  }

  bool _ignoreChange(T model) {
    if (widget.ignoreChange != null) {
      return !widget.ignoreChange!(model);
    }

    return true;
  }

  Stream<T> _createStream() =>
      widget.stream(widget.manager).where(_ignoreChange);
}