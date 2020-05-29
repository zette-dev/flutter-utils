import 'dart:async';

import 'package:rxdart/rxdart.dart';

abstract class DataStreamManager<D, M> extends StreamManager<M> {
  DataStreamManager(D api, M model, {List<Stream> streams})
      : _api = api,
        super(model, streams: streams);
  final D _api;
  D get api => _api;
}

abstract class StreamManager<M> {
  StreamManager(M model, {List<Stream> streams}) {
    update(model);
    if (streams != null && streams.isNotEmpty)
      _streamSubscription =
          Rx.merge(streams.where((s) => s != null)).listen(streamsUpdated);
  }

  final StreamController<M> _streamController = StreamController<M>.broadcast();
  Stream<M> get stream => _streamController.stream;
  StreamSubscription _streamSubscription;
  M _model;

  bool _isDirty;
  bool get isDirty => _isDirty;

  // override if you want to intercept any updates to streams
  // the manager is listening to
  void streamsUpdated(dynamic data) {}

  M get model => _model;
  set model(M newModel) {
    _model = newModel;
    _isDirty = true;
  }

  void update(M model) {
    _model = model;
    _isDirty = false;
    _streamController.sink.add(_model);
  }

  void dispose() {
    _streamController?.close();
    _streamSubscription?.cancel();
  }
}
