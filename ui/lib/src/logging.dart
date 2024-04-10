import 'dart:async';

import 'package:ds_utils/ds_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:ms_map_utils/ms_map_utils.dart' show diff;
import 'package:riverpod/riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

const kLogLevel = Level.all;
final logger = Logger(
  level: kLogLevel,
  output: _LogOutput(),
  printer: SimplePrinter(
    colors: false,
    printTime: false,
  ),
  filter: kReleaseMode ? ProductionFilter() : DevelopmentFilter(),
);

class _LogOutput extends LogOutput {
  _LogOutput() {
    Logger.level = kLogLevel;
  }

  @override
  void output(OutputEvent event) {
    if (kDebugMode) {
      event.lines.forEach(debugPrint);
    }

    final LogEvent record = event.origin;
    Map<String, dynamic> hintData = {
      'log_message': record.message,
      'log_level': record.level.name,
    };

    if (record.level.value >= Level.error.value) {
      final Object? error = record.error;

      if (error is ApiResponseError) {
        hintData.addAll(error.toJson());
      }

      unawaited(Sentry.captureException(
        record.error,
        stackTrace: record.stackTrace,
        hint: Hint.withMap(hintData),
      ));
    } else if (record.level == Level.warning) {
      unawaited(Sentry.captureEvent(
        SentryEvent(
          message: SentryMessage(record.message),
          throwable: record.error,
          level: SentryLevel.warning,
          timestamp: DateTime.now(),
        ),
        stackTrace: record.stackTrace,
        hint: Hint.withMap(hintData),
      ));
    } else if (record.level == Level.info) {
      unawaited(Sentry.addBreadcrumb(
        Breadcrumb.console(
          message: record.message,
          level: SentryLevel.fromName(record.level.name.toLowerCase()),
        ),
        hint: Hint.withMap(hintData),
      ));
    }
  }
}

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

  @override
  void providerDidFail(
    ProviderBase<Object?> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    log.e(
      'Provider Error (${provider.name ?? provider.runtimeType}): ${error.toString()}',
      error: error,
      stackTrace: stackTrace,
    );
  }
}

mixin Loggable {
  Map<String, dynamic> toLog();
}
