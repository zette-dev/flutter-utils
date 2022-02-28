import 'dart:async';

import 'package:dropsource_ui/dropsource_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';
typedef OnInitCallback<M> = void Function(M manager);
typedef InitialDataCreator<M, T> = T Function(M manager);
typedef StreamCreator<M, T> = Stream<T> Function(M manager);
typedef IgnoreChangeTest<T> = bool Function(T model);

typedef _Builder<M, T> = Widget Function(
  BuildContext,
  M controller,
  T state,
);
typedef OnDisposeCallback<M> = void Function(
  M controller,
);
typedef OnWillChangeCallback<M> = void Function(M manager);
typedef OnInitialBuildCallback<M> = void Function(M manager);

class RiverpodBuilder<SN extends StateNotifierProvider<N, StateNotifier<S>>
    extends ConsumerStatefulWidget {
  final N notifier;
  final _Builder<N, S> builder;
  final InitialDataCreator<N, S> initialData;
  final StreamCreator<N, S> stream;
  final OnInitCallback<N>? onInit;
  final OnDisposeCallback<N>? onDispose;
  final OnInitialBuildCallback<N>? onInitialBuild;

  const RiverpodBuilder({
    Key? key,
    required this.builder,
    required this.stream,
    required this.notifier,
    required this.initialData,
    this.onInit,
    this.onDispose,
    this.onInitialBuild,
  }) : super(key: key);

  @override
  _RiverpodBuilderState createState() {
    return _RiverpodBuilderState<N, S>();
  }
}

class _RiverpodBuilderState<N extends StateNotifier<S>, S>
    extends ConsumerState<RiverpodBuilder<N, S>> with AfterLayoutMixin {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () => widget.onInit?.call(widget.notifier));
  }

  @override
  void afterFirstLayout(BuildContext context) {
    widget.onInitialBuild?.call(widget.notifier);
  }

  @override
  void dispose() {
    super.dispose();
    widget.onDispose?.call(widget.notifier);
  }

  @override
  Widget build(BuildContext context) {


    return StreamBuilder<S>(
      initialData: widget.initialData(widget.manager),
      stream: _createStream(),
      builder: (ctx, snapshot) =>
          widget.builder(ctx, widget.manager, snapshot.data!),
    );
  }

  Stream<T> _createStream() => widget.stream(widget.notifier);
}
