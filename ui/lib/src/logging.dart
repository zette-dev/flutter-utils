import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:ms_map_utils/ms_map_utils.dart';
import 'package:riverpod/riverpod.dart';

class ProviderLogger extends ProviderObserver {
  ProviderLogger(this.log);
  final Logger log;

  @override
  void didAddProvider(
    ProviderBase provider,
    Object? value,
    ProviderContainer container,
  ) =>
      log.d('ADDED (${provider.name ?? provider.runtimeType})');

  @override
  void didDisposeProvider(
    ProviderBase provider,
    ProviderContainer containers,
  ) =>
      log.d('DISPOSED (${provider.name ?? provider.runtimeType})');

  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    if (previousValue is Loggable && newValue is Loggable) {
      final before = previousValue.toLog();
      final after = newValue.toLog();
      final beforeDiff = diff(after, before).filterOutNullsOrEmpty();
      final afterDiff = diff(before, after).filterOutNullsOrEmpty();

      if (!mapEquals(beforeDiff, afterDiff)) {
        log.d('UPDATE (${provider.name ?? provider.runtimeType}): BEFORE: $beforeDiff | AFTER: $afterDiff');
      }
    } else {
      log.d('UPDATE: (${provider.name ?? provider.runtimeType}) - use `with Serializable` to see state diff');
    }
  }
}

mixin Loggable {
  Map<String, dynamic> toLog();
}

extension _MapMethods<K, T> on Map {
  Map<K, T> filterOutNullsOrEmpty() {
    final Map<K, T> filtered = <K, T>{};
    forEach((key, value) {
      if (value != null && value is! Map && value is! Iterable) {
        filtered[key] = value;
      } else if (value is Map<dynamic, dynamic> && value.isNotEmpty) {
        filtered[key] = value as T;
      } else if (value is Iterable && value.isNotEmpty) {
        filtered[key] = value as T;
      }
    });
    return filtered;
  }
}
