import 'dart:async';

import 'package:dropsource_ui/src/networking_manager.dart';
import 'package:rxdart/rxdart.dart';

abstract class DataStreamManager<D, M> extends StreamManager<M> {
  DataStreamManager(D Function() api, M model, {List<Stream>? dependencies})
      : _api = api,
        super(model, dependencies: dependencies);
  final D Function() _api;
  D get api => _api();
}

abstract class StreamManager<M> {
  StreamManager(M model, {List<Stream>? dependencies})
      : _lastUpdatedModel = model {
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

  Stream<M> get stream => _streamController.stream;
  StreamSubscription? _streamSubscription;
  M? _latestModel;
  M _lastUpdatedModel;


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
    _streamController.close();
    _streamSubscription?.cancel();
  }
}

extension StreamManagerExtensions<T extends NetworkingModel>
    on StreamManager<T> {
  Future executeWithLoading<V>(
    Future<V> future, {
    bool startLoading = true,
    bool resetErrors = true,
    Function(V)? then,
  }) {
    if (resetErrors) {
      model = model.resetError() as T;
    }
    if (startLoading) {
      model = model.startLoading() as T;
    }

    update(model);

    return future
        .then(then ?? (_) => null)
        .catchError((err) => model = model.toError(err) as T)
        .whenComplete(() => update(startLoading ? model.stopLoading() as T : model));
  }

  Future<V?> executeWithLoadingReturn<V>(
    Future<V> future, {
    bool startLoading = true,
    bool resetErrors = true,
    Future<V?> Function(V)? then,
  }) {
    if (resetErrors) {
      model = model.resetError() as T;
    }
    if (startLoading) {
      model = model.startLoading() as T;
    }

    update(model);

    return future.then(then ?? (_) async => null).catchError((err) {
      model = model.toError(err) as T;
      return null;
    }).whenComplete(() => update(startLoading ? model.stopLoading() as T : model));
  }
}
