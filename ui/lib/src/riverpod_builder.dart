import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../dropsource_ui.dart';

typedef _Builder<M, T> = Widget Function(
  BuildContext,
  WidgetRef ref,
  M controller,
  T state,
);
typedef OnControllerCallback<M> = void Function(
  M controller,
);

class StateStreamBuilder<S, N extends StateNotifier<S>>
    extends ConsumerStatefulWidget {
  final StateNotifierProvider<N, S> notifier;
  final _Builder<N, S> builder;
  final OnControllerCallback<N>? onInit;
  final OnControllerCallback<N>? onDispose;
  final OnControllerCallback<N>? onInitialBuild;

  const StateStreamBuilder({
    Key? key,
    required this.builder,
    required this.notifier,
    this.onInit,
    this.onDispose,
    this.onInitialBuild,
  }) : super(key: key);

  @override
  _StateStreamBuilderState createState() {
    return _StateStreamBuilderState<S, N>();
  }
}

class _StateStreamBuilderState<S, N extends StateNotifier<S>>
    extends ConsumerState<StateStreamBuilder<S, N>> with AfterLayoutMixin {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero,
        () => widget.onInit?.call(ref.read(widget.notifier.notifier)));
  }

  @override
  void afterFirstLayout(BuildContext context) {
    widget.onInitialBuild?.call(ref.read(widget.notifier.notifier));
  }

  @override
  void dispose() {
    super.dispose();
    widget.onDispose?.call(ref.read(widget.notifier.notifier));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<S>(
      initialData: ref.read(widget.notifier),
      stream: ref.watch(widget.notifier.notifier).stream,
      builder: (ctx, snapshot) => widget.builder(
        ctx,
        ref,
        ref.read(widget.notifier.notifier),
        snapshot.data!,
      ),
    );
  }
}
