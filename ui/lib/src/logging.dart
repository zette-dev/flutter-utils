import 'package:ds_utils/ds_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:ms_map_utils/ms_map_utils.dart';

class ProviderLogger extends ProviderObserver {
  ProviderLogger(this.log, {Level level = Level.ALL}) {
    Logger.root.level = level;
    Logger.root.onRecord.listen((record) {
      print('${record.level.name}: ${record.time}: ${record.message}');
    });
  }
  final Logger log;

  @override
  void didAddProvider(
    ProviderBase provider,
    Object? value,
    ProviderContainer container,
  ) =>
      log.fine('ADDED (${provider.name ?? provider.runtimeType})');

  @override
  void didDisposeProvider(
    ProviderBase provider,
    ProviderContainer containers,
  ) =>
      log.fine('DISPOSED (${provider.name ?? provider.runtimeType})');

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
        log.fine(
            'UPDATE (${provider.name ?? provider.runtimeType}): BEFORE: $beforeDiff | AFTER: $afterDiff');
      }
    } else {
      log.fine(
          'UPDATE: (${provider.name ?? provider.runtimeType}) - use `with Serializable` to see state diff');
    }
  }
}

mixin Loggable {
  Map<String, dynamic> toLog();
}
