// import 'dart:async';

// import 'package:flutter/widgets.dart';
// import 'package:provider/provider.dart';

// typedef OnInitCallback<M> = void Function(M manager);
// typedef InitialDataCreator<M, T> = T Function(M manager);
// typedef StreamCreator<M, T> = Stream<T> Function(M manager);
// typedef IgnoreChangeTest<T> = bool Function(T model);

// typedef _Builder<M, T> = Widget Function(
//   BuildContext,
//   M manager,
//   T model,
// );
// typedef OnDisposeCallback<M> = void Function(
//   M manager,
// );
// typedef OnWillChangeCallback<M> = void Function(M manager);
// typedef OnInitialBuildCallback<M> = void Function(M manager);

// class StatefulStreamBuilder<M, T> extends StatelessWidget {
//   final _Builder<M, T> builder;
//   final InitialDataCreator<M, T> initialData;
//   final StreamCreator<M, T> stream;
//   final IgnoreChangeTest<T>? ignoreChange;
//   final OnInitCallback<M>? onInit;
//   final OnDisposeCallback<M>? onDispose;
//   final OnWillChangeCallback<M>? onWillChange;
//   final OnInitialBuildCallback<M>? onInitialBuild;
//   StatefulStreamBuilder({
//     Key? key,
//     required this.builder,
//     required this.stream,
//     required this.initialData,
//     this.ignoreChange,
//     this.onInit,
//     this.onDispose,
//     this.onWillChange,
//     this.onInitialBuild,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return _StatefulLifecycleManager<M, T>(
//       builder: builder,
//       manager: Provider.of<M>(context, listen: false),
//       stream: stream,
//       ignoreChange: ignoreChange,
//       initialData: initialData,
//       onInit: onInit,
//       onDispose: onDispose,
//       onWillChange: onWillChange,
//       onInitialBuild: onInitialBuild,
//     );
//   }
// }

// class _StatefulLifecycleManager<M, T> extends StatefulWidget {
//   final M manager;
//   final _Builder<M, T> builder;
//   final InitialDataCreator<M, T> initialData;
//   final StreamCreator<M, T> stream;
//   final IgnoreChangeTest<T>? ignoreChange;
//   final OnInitCallback<M>? onInit;
//   final OnDisposeCallback<M>? onDispose;
//   final OnWillChangeCallback<M>? onWillChange;
//   final OnInitialBuildCallback<M>? onInitialBuild;

//   _StatefulLifecycleManager({
//     Key? key,
//     required this.builder,
//     required this.stream,
//     required this.manager,
//     required this.initialData,
//     this.onInit,
//     this.onDispose,
//     this.onWillChange,
//     this.ignoreChange,
//     this.onInitialBuild,
//   }) : super(key: key);

//   @override
//   State<StatefulWidget> createState() {
//     return _StatefulLifecycleManagerState<M, T>();
//   }
// }

// class _StatefulLifecycleManagerState<M, T>
//     extends State<_StatefulLifecycleManager<M, T>> {
//   @override
//   void initState() {
//     super.initState();
//     if (widget.onInitialBuild != null) {
//       WidgetsBinding.instance?.addPostFrameCallback((_) {
//         widget.onInitialBuild!(widget.manager);
//       });
//     }

//     if (widget.onInit != null) {
//       widget.onInit!(widget.manager);
//     }
//   }

//   @override
//   void dispose() {
//     super.dispose();

//     if (widget.onDispose != null) {
//       widget.onDispose!(widget.manager);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<T>(
//       initialData: widget.initialData(widget.manager),
//       stream: _createStream(),
//       builder: (ctx, snapshot) =>
//           widget.builder(ctx, widget.manager, snapshot.data!),
//     );
//   }

//   bool _ignoreChange(T model) {
//     if (widget.ignoreChange != null) {
//       return !widget.ignoreChange!(model);
//     }

//     return true;
//   }

//   Stream<T> _createStream() =>
//       widget.stream(widget.manager).where(_ignoreChange);
//   // .map(_mapConverter)
//   // Don't use `Stream.distinct` because it cannot capture the initial
//   // ViewModel produced by the `converter`.
//   // .where(_whereDistinct)
//   // After each ViewModel is emitted from the Stream, we update the
//   // latestValue. Important: This must be done after all other optional
//   // transformations, such as ignoreChange.
//   // .transform(StreamTransformer.fromHandlers(handleData: _handleChange));

//   void _handleChange(T model, EventSink<T> sink) {
//     // latestValue = vm;

//     if (widget.onWillChange != null) {
//       widget.onWillChange!(widget.manager);
//     }

//     // if (widget.onDidChange != null) {
//     //   WidgetsBinding.instance.addPostFrameCallback((_) {
//     //     widget.onDidChange(latestValue);
//     //   });
//     // }

//     // sink.add(vm);
//   }
// }

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'widget_extensions.dart';

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
typedef OnInitialBuildCallback<M> = void Function(M manager);

class StatefulStreamBuilder<M, T> extends StatefulWidget {
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
    this.onInit,
    this.onDispose,
    this.ignoreChange,
    this.onInitialBuild,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _StatefulStreamBuilderState<M, T>();
  }
}

class _StatefulStreamBuilderState<M, T>
    extends State<StatefulStreamBuilder<M, T>> {
  M manager(BuildContext ctx) => ctx.provider<M>();
  @override
  void initState() {
    super.initState();
    if (widget.onInitialBuild != null) {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        widget.onInitialBuild!(manager(context));
      });
    }

    widget.onInit?.call(manager(context));
  }

  @override
  void dispose() {
    super.dispose();

    widget.onDispose?.call(manager(context));
  }

  @override
  Widget build(BuildContext context) {
    final _manager = manager(context);
    return StreamBuilder<T>(
      initialData: widget.initialData(_manager),
      stream: _createStream(_manager),
      builder: (ctx, snapshot) => widget.builder(ctx, _manager, snapshot.data!),
    );
  }

  bool _ignoreChange(T model) {
    if (widget.ignoreChange != null) {
      return !widget.ignoreChange!(model);
    }

    return true;
  }

  Stream<T> _createStream(M manager) =>
      widget.stream(manager).where(_ignoreChange);
}
