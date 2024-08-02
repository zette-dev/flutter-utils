// ignore_for_file: use_setters_to_change_properties

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:zette_ui/zette_ui.dart';

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

final $envProvider = Provider<EnvConfigData?>(
  (ref) => null,
  name: 'AppEnvProvider',
);

mixin EnvConfigData {
  AppEnvironment get environment;
  String? get sentryDsn;
  String get buildName;
  String get buildVersion;
  String get buildNumber;
}

abstract class AppLoader<C extends EnvConfigData> with SentryInitializer {
  AppLoader(this.config);
  final C config;
  List<Override> get providerOverrides;

  /// Initialize the app before launching any UI
  Future preLaunchInit(WidgetRef ref);

  /// Initialize the app after launching the UI
  /// Commonly used for loading session data
  Future postLaunchInit(BuildContext context, WidgetRef ref);
  Widget appBuilder();
  Widget loadingBuilder();
  Future<void>? runGuarded() => initSentry(
        config.sentryDsn,
        config.environment,
        config.buildName,
        config.buildVersion,
        config.buildNumber,
        runner: () => runApp(
          ProviderScope(
            key: UniqueKey(),
            overrides: providerOverrides,
            observers: [
              ProviderLogger(logger),
            ],
            child: Consumer(
              builder: (context, ref, child) {
                final initFuture = preLaunchInit(ref);
                return FutureBuilder(
                  future: initFuture,
                  builder: (context, snapshot) => snapshot.hasData ? child! : loadingBuilder(),
                );
              },
              child: appBuilder(),
            ),
          ),
        ),
      );
}

abstract class BaseMobileAppLoader<C extends EnvConfigData> extends AppLoader<C> {
  BaseMobileAppLoader(C config, {Color? statusBarColor, Brightness? statusBarBrightness, bool ensureBindingInit = true})
      : super(config) {
    if (ensureBindingInit) {
      WidgetsFlutterBinding.ensureInitialized();
    }

    if (statusBarBrightness != null || statusBarColor != null) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: statusBarColor,
          statusBarBrightness: statusBarBrightness,
        ),
      );
    }
  }
}

mixin SentryInitializer {
  Future<void> initSentry(String? dns, AppEnvironment env, String buildName, String release, String buildNumber,
      {required AppRunner runner}) {
    if (dns != null && !kDebugMode) {
      return SentryFlutter.init(
        (options) {
          options
            ..dsn = dns
            ..environment = env.name
            ..release = '$buildName@$release'
            ..dist = buildNumber
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
