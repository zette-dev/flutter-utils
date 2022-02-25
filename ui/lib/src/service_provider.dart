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
  LocalizedErrorInterface? get error;
  bool get hasError {
    return error != null;
  }

  T load() => copyWith(isLoading: true);
  T loaded() => copyWith(isLoading: false);
  T copyWith({bool? isLoading, Object? error});
  T withError(Object error) => copyWith(error: error);
  T withoutError() => copyWith(error: ResetError());

  String localizedErrorMessage(WidgetRef ref);
}

mixin Serializable {
  Map<String, dynamic> toMap();
}