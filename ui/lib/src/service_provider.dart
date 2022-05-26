import 'dart:async';

import 'package:flutter/widgets.dart' show protected;
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class ManagedStateNotifier<T> extends StateNotifier<T> {
  ManagedStateNotifier(this.ref, T state) : super(state);
  @protected
  final Ref ref;
}

mixin LoadableProvider<S extends Loadable<S>> {
  S get state;
  set state(S s);

  Future serviceCall<V>(
    Future<V> future, {
    bool showLoading = true,
    bool resetErrors = true,
    Function(V)? onData,
  }) {
    if (resetErrors && showLoading) {
      state = state.load().withoutError();
    } else if (resetErrors && !showLoading) {
      state = state.withoutError();
    } else if (!resetErrors && showLoading) {
      state = state.load();
    }

    return future.then(onData ?? (_) => null).catchError((err) {
      state = state.withError(err);
      return null;
    }).whenComplete(() {
      if (showLoading) {
        state = state.loaded();
      }
    });
  }

  Future<V?> serviceCallWithReturn<V>(
    Future<V> future, {
    bool showLoading = true,
    bool resetErrors = true,
    Future<V?> Function(V)? onData,
  }) {
    if (resetErrors && showLoading) {
      state = state.load().withoutError();
    } else if (resetErrors && !showLoading) {
      state = state.withoutError();
    } else if (!resetErrors && showLoading) {
      state = state.load();
    }

    return future.then(onData ?? (_) async => null).catchError((err) {
      state = state.withError(err);
      return null;
    }).whenComplete(() {
      if (showLoading) {
        state = state.loaded();
      }
    });
  }
}

abstract class LocalizedErrorInterface implements Exception {
  LocalizedErrorInterface({
    required this.code,
    this.exception,
  });
  final String code;
  final Object? exception;
}

class ResetError {}

mixin Loadable<T> {
  bool get isLoading;
  Object? get error;

  bool get hasError => error != null;

  T load() => _loadableCopyWith(this, isLoading: true);
  T loaded() => _loadableCopyWith(this, isLoading: false);
  T withError(Object error) =>
      _loadableCopyWith(this, error: error, isLoading: false);
  T withoutError() => _loadableCopyWith(this, error: ResetError());
}

T _loadableCopyWith<T>(Loadable<T> self, {bool? isLoading, Object? error}) {
  try {
    final copyWith = (self as dynamic).copyWith;
    isLoading = isLoading ?? self.isLoading;
    error = error is ResetError ? null : error ?? self.error;
    return copyWith(isLoading: isLoading, error: error);
  } on NoSuchMethodError catch (_) {
    // ignore: avoid_print
    print('ERROR: Object ${self.runtimeType} has no copyWith() method!');
    rethrow;
  }
}
