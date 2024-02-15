// ignore_for_file: use_setters_to_change_properties

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

part 'app_loader.g.dart';

const _$AppEnvironmentEnumValueMap = {
  'development': AppEnvironment.development,
  'staging': AppEnvironment.staging,
  'production': AppEnvironment.production,
  'automation': AppEnvironment.automation,
};

@JsonEnum(alwaysCreate: true)
enum AppEnvironment {
  development,
  staging,
  production,
  automation;

  static AppEnvironment? fromString(String value) => _$AppEnvironmentEnumValueMap[value];
}

final envProvider = Provider<EnvConfigData?>(
  (ref) => null,
  name: 'AppEnvProvider',
);

mixin EnvConfigData {
  AppEnvironment get environment;
  String? get sentryDsn;
}

abstract class AppLoader<C extends EnvConfigData> with SentryInitializer {
  AppLoader(this.config);
  final C config;
  Future init(BuildContext context, WidgetRef ref);
  Widget appBuilder();
  void onError(Object error, StackTrace? stack);
  Future<void>? runGuarded() => initSentry(
        config.sentryDsn,
        config.environment,
        runner: () => runApp(appBuilder()),
      );
}

mixin SentryInitializer {
  Future<void> initSentry(String? dns, AppEnvironment env, {required AppRunner runner}) {
    if (dns != null && !kDebugMode) {
      return SentryFlutter.init(
        (options) {
          options
            ..dsn = dns
            ..environment = env.name
            ..tracesSampleRate = 1.0;
          // ..beforeSend = (event, {hint}) {
          //   // Ignore handled exceptions
          //   if (event.exceptions != null && event.exceptions!.isNotEmpty
          //       // event.exceptions![0].mechanism != null &&
          //       // event.exceptions![0].mechanism!.handled == true
          //       ) {
          //     return null;
          //   }
          //   return event;
          // };
        },
        appRunner: runner,
      );
    }

    return Future.value(runner());
  }
}
