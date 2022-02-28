import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../dropsource_ui.dart';

typedef _Builder<M, T> = Widget Function(
  BuildContext,
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
  final _Builder<N, S> builder;
  final OnControllerCallback<N>? onInit, onAsyncInit, onDispose, onInitialBuild;

  const StateBuilder({
    Key? key,
    required this.builder,
    required this.provider,
    this.onInit,
    this.onAsyncInit,
    this.onDispose,
    this.onInitialBuild,
    required this.type,
    this.asyncInitDelay = Duration.zero,
  }) : super(key: key);

  final _BuilderType type;
  final Duration asyncInitDelay;

  factory StateBuilder.stream({
    Key? key,
    required _Builder<N, S> builder,
    required StateNotifierProvider<N, S> provider,
    OnControllerCallback<N>? onInit,
    OnControllerCallback<N>? onAsyncInit,
    OnControllerCallback<N>? onDispose,
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
      );

  factory StateBuilder.watch({
    Key? key,
    required _Builder<N, S> builder,
    required StateNotifierProvider<N, S> provider,
    OnControllerCallback<N>? onInit,
    OnControllerCallback<N>? onAsyncInit,
    OnControllerCallback<N>? onDispose,
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
        type: _BuilderType.watch,
        asyncInitDelay: asyncInitDelay,
      );

  @override
  _StateBuilderState createState() {
    return _StateBuilderState<S, N>();
  }
}

class _StateBuilderState<S, N extends StateNotifier<S>>
    extends ConsumerState<StateBuilder<S, N>> with AfterLayoutMixin {
  @override
  void initState() {
    super.initState();
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
    widget.onDispose?.call(ref.read(widget.provider.notifier), ref);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.type == _BuilderType.stream) {
      return StreamBuilder<S>(
        initialData: ref.read(widget.provider),
        stream: ref.watch(widget.provider.notifier).stream,
        builder: (ctx, snapshot) => widget.builder(
          ctx,
          ref,
          ref.read(widget.provider.notifier),
          snapshot.data!,
        ),
      );
    }
    final state = ref.watch(widget.provider);
    return widget.builder(
      context,
      ref,
      ref.read(widget.provider.notifier),
      state,
    );
  }
}
