import 'dart:async';

import 'package:rxdart/rxdart.dart';

abstract class DataStreamManager<D, M> extends StreamManager<M> {
  DataStreamManager(D Function() api, M model, {List<Stream> dependencies})
      : _api = api,
        super(model, dependencies: dependencies);
  final D Function() _api;
  D get api => _api();
}

abstract class StreamManager<M> {
  StreamManager(M model, {List<Stream> dependencies}) {
    update(model);
    if (dependencies != null && dependencies.isNotEmpty) {
      final _dependencyStreams = dependencies.where((s) => s != null);
      if (_dependencyStreams.isNotEmpty) {
        _streamSubscription =
            Rx.merge(_dependencyStreams).listen(dependenciesUpdated);
      }
    }
  }

  final BehaviorSubject<M> _streamController = BehaviorSubject<M>();

  // final StreamController<M> _streamController = StreamController<M>.broadcast();
  Stream<M> get stream => _streamController.stream;
  StreamSubscription _streamSubscription;
  M _latestModel, _lastUpdatedModel;

  // bool get isDirty => _dirtyModel != null;

  // override if you want to intercept any updates to streams
  // the manager is listening to
  void dependenciesUpdated(dynamic data) {}

  M get model => _latestModel ?? _lastUpdatedModel;

  // Dirty model is the most updated model that has not been streamed
  M get lastUpdatedModel => _lastUpdatedModel;
  set model(M newModel) {
    _latestModel = newModel;
  }

  void update(M model) {
    _latestModel = null;
    _lastUpdatedModel = model;
    _streamController.sink.add(model);
  }

  void dispose() {
    _streamController?.close();
    _streamSubscription?.cancel();
  }
}
