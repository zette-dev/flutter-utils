import 'dart:async';

import 'package:ds_ui/src/layout/layout.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../ds_ui.dart';

typedef _Builder<M, T> = Widget Function(
  BuildContext,
  WidgetRef,
  M controller,
  T state,
);

typedef _LayoutBuilder<M, T> = Widget Function(
  BuildContext,
  LayoutData,
  WidgetRef,
  M controller,
  T state,
);

typedef OnControllerCallback<M> = void Function(
  M controller,
  WidgetRef ref,
);

enum _BuilderType { stream, watch }

class StateBuilder<S, N extends StateNotifier<S>>
    extends ConsumerStatefulWidget {
  final StateNotifierProvider<N, S> provider;
  final _Builder<N, S>? builder;
  final _LayoutBuilder<N, S>? layoutBuilder;
  final OnControllerCallback<N>? onInit, onAsyncInit, onInitialBuild;
  final VoidCallback? onDispose;

  const StateBuilder({
    Key? key,
    required this.provider,
    this.layoutBuilder,
    this.builder,
    this.onInit,
    this.onAsyncInit,
    this.onDispose,
    this.onInitialBuild,
    required this.type,
    this.asyncInitDelay = Duration.zero,
    // this.child,
  })  : assert(builder != null || layoutBuilder != null),
        super(key: key);

  final _BuilderType type;
  final Duration asyncInitDelay;
  // final Widget? child;

  factory StateBuilder.stream({
    Key? key,
    required _Builder<N, S> builder,
    required StateNotifierProvider<N, S> provider,
    OnControllerCallback<N>? onInit,
    OnControllerCallback<N>? onAsyncInit,
    VoidCallback? onDispose,
    OnControllerCallback<N>? onInitialBuild,
    Duration asyncInitDelay = Duration.zero,
  }) =>
      StateBuilder<S, N>(
        key: key,
        builder: builder,
        provider: provider,
        onInit: onInit,
        onAsyncInit: onAsyncInit,
        onDispose: onDispose,
        onInitialBuild: onInitialBuild,
        type: _BuilderType.stream,
        asyncInitDelay: asyncInitDelay,
        // child: child,
      );

  factory StateBuilder.watch({
    Key? key,
    required _Builder<N, S> builder,
    required StateNotifierProvider<N, S> provider,
    OnControllerCallback<N>? onInit,
    OnControllerCallback<N>? onAsyncInit,
    VoidCallback? onDispose,
    OnControllerCallback<N>? onInitialBuild,
    Duration asyncInitDelay = Duration.zero,
    // Widget? child,
  }) =>
      StateBuilder<S, N>(
        key: key,
        builder: builder,
        provider: provider,
        onInit: onInit,
        onAsyncInit: onAsyncInit,
        onDispose: onDispose,
        onInitialBuild: onInitialBuild,
        type: _BuilderType.watch,
        asyncInitDelay: asyncInitDelay,
        // child: child,
      );

  @override
  _StateBuilderState createState() {
    return _StateBuilderState<S, N>();
  }
}

class _StateBuilderState<S, N extends StateNotifier<S>>
    extends ConsumerState<StateBuilder<S, N>> with AfterLayoutMixin {
  // WidgetRef? _lastRef;
  // WidgetRef? get _latestRef => _lastRef;
  @override
  void initState() {
    super.initState();
    // _lastRef = ref;
    widget.onInit?.call(ref.read(widget.provider.notifier), ref);
    Future.delayed(
        Duration.zero,
        () =>
            widget.onAsyncInit?.call(ref.read(widget.provider.notifier), ref));
  }

  @override
  void afterFirstLayout(BuildContext context) {
    widget.onInitialBuild?.call(ref.read(widget.provider.notifier), ref);
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.onDispose != null) {
      widget.onDispose!(
          // _latestRef!.read(widget.provider.notifier),
          // _latestRef!,
          );
    }
  }

  Widget _builder(BuildContext ctx, S data, [LayoutData? layout]) =>
      layout != null && widget.layoutBuilder != null
          ? widget.layoutBuilder!.call(
              ctx,
              layout,
              ref,
              ref.read(widget.provider.notifier),
              data,
            )
          : widget.builder!.call(
              ctx,
              ref,
              ref.read(widget.provider.notifier),
              data,
            );

  Widget _builderWithData([LayoutData? layout]) {
    if (widget.type == _BuilderType.stream) {
      return StreamBuilder<S>(
        initialData: ref.read(widget.provider),
        stream: ref.watch(widget.provider.notifier).stream,
        builder: (ctx, snapshot) => _builder(ctx, snapshot.data!, layout),
      );
    }

    final state = ref.watch(widget.provider);
    return _builder(
      context,
      state,
      layout,
      // child: widget.child,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.layoutBuilder != null) {
      return AdaptiveLayout.maybeWhen(
        ref,
        builder: (ctx, layout) => _builderWithData(layout),
      );
    }

    return _builderWithData();
  }
}
