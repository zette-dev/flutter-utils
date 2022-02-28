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
);

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
  }) : super(key: key);

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
    widget.onInit?.call(ref.read(widget.provider.notifier));
    Future.delayed(Duration.zero,
        () => widget.onAsyncInit?.call(ref.read(widget.provider.notifier)));
  }

  @override
  void afterFirstLayout(BuildContext context) {
    widget.onInitialBuild?.call(ref.read(widget.provider.notifier));
  }

  @override
  void dispose() {
    super.dispose();
    widget.onDispose?.call(ref.read(widget.provider.notifier));
  }

  @override
  Widget build(BuildContext context) {
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
}
