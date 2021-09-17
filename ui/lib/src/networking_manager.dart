import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dropsource_core/dropsource_core.dart';

import '../dropsource_ui.dart';
import 'networking.dart' show NetworkConnectionError;

class _GenericListNetorkingModel<T extends Identifiable>
    extends ListNetworkingModel<T> {
  _GenericListNetorkingModel({
    bool? isConnectedToNetwork,
    bool? isInProgress,
    bool? isLoadingMore,
    bool? canLoadMore,
    List<T>? listData,
    dynamic error,
  }) : super(
          isConnectedToNetwork: isConnectedToNetwork,
          isInProgress: isInProgress,
          isLoadingMore: isLoadingMore,
          canLoadMore: canLoadMore,
          listData: listData,
          error: error,
        );

  @override
  int get collectionSize => 25;

  @override
  String get errorMessage => '';
}

abstract class ListNetworkingModel<T extends Identifiable>
    extends NetworkingModel {
  ListNetworkingModel({
    bool? isConnectedToNetwork,
    bool? isInProgress,
    bool? isLoadingMore,
    bool? canLoadMore,
    List<T>? listData,
    dynamic error,
  })  : _isLoadingMore = isLoadingMore ?? false,
        _canLoadMore = canLoadMore ?? true,
        _listData = listData ?? [],
        super(
          isInProgress: isInProgress,
          isConnectedToNetwork: isConnectedToNetwork,
          error: error,
        );

  static ListNetworkingModel<T> generic<T extends Identifiable>({
    bool? isConnectedToNetwork,
    bool? isInProgress,
    bool? isLoadingMore,
    bool? canLoadMore,
    List<T>? listData,
    dynamic error,
  }) =>
      _GenericListNetorkingModel<T>(
        isConnectedToNetwork: isConnectedToNetwork,
        isInProgress: isInProgress,
        isLoadingMore: isLoadingMore,
        canLoadMore: canLoadMore,
        listData: listData,
        error: error,
      );

  List<T> _listData;
  List<T> get listData => _listData;

  // LOADING MORE
  bool _isLoadingMore;
  bool get isLoadingMore => _isLoadingMore;

  bool _canLoadMore;
  bool get canLoadMore => _canLoadMore;

  bool get shouldLoadMore =>
      canLoadMore && !isLoadingMore && itemCount >= collectionSize;
  int get collectionSize;
  int get itemCount => listData.length;
  bool get hasData => itemCount > 0;

  ListNetworkingModel<T> setData(
    List<T> newData, {
    MergeDirection mergeDirection = MergeDirection.replace,
  }) {
    _listData =
        listData.merge(direction: mergeDirection, newList: newData).toList();

    return this;
  }
}

extension ListNetworkingMutators on ListNetworkingModel {
  ListNetworkingModel startLoadingMore() {
    _isLoadingMore = true;
    return this;
  }

  ListNetworkingModel stopLoadingMore() {
    _isLoadingMore = false;
    return this;
  }

  ListNetworkingModel canLoadMoreData(bool canLoadMore) {
    _canLoadMore = canLoadMore;
    return this;
  }
}

abstract class NetworkingModel {
  NetworkingModel({
    bool? isConnectedToNetwork,
    bool? isInProgress,
    dynamic error,
  })  : _isConnectedToNetwork = isConnectedToNetwork ?? true,
        _isInProgress = isInProgress ?? false,
        _error = error;

  // PROGRESS
  bool _isInProgress;
  bool get isInProgress => _isInProgress;

  bool _isConnectedToNetwork = true;
  bool get isConnectedToNetwork => _isConnectedToNetwork;

  // ERROR HANDLING
  dynamic _error;
  dynamic get error => _error;
  bool get hasError => _error != null;
  String get errorMessage;
}

extension NetworkingMutators on NetworkingModel {
  // PROGRESS
  NetworkingModel startLoading() {
    _isInProgress = true;
    return this;
  }

  NetworkingModel stopLoading() {
    _isInProgress = false;
    return this;
  }

  // ERROR HANDLING
  NetworkingModel toError(dynamic err) {
    _error = err;
    return this;
  }

  NetworkingModel connectivityResult(ConnectivityResult result) {
    _isConnectedToNetwork = result != ConnectivityResult.none;
    return this;
  }

  NetworkingModel failedLoading(dynamic error) {
    final _isNetworkError = error is NetworkConnectionError;
    stopLoading();
    _error = _isNetworkError ? null : error;
    _isConnectedToNetwork = !_isNetworkError;
    return this;
  }

  NetworkingModel resetError() {
    _error = null;
    return this;
  }

  // NETWORK CONNECTIVTY

  NetworkingModel connectionResumed() {
    _isConnectedToNetwork = true;
    return this;
  }

  NetworkingModel connectionLost() {
    _isConnectedToNetwork = false;
    return this;
  }
}
