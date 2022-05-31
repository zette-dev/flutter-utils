// ignore_for_file: use_setters_to_change_properties

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum()
enum AppEnvironment {
  staging,
  production,
  automation,
}

final envProvider = StateNotifierProvider<EnvConfigNotifier, EnvConfigData?>(
  (ref) => EnvConfigNotifier(),
  name: 'AppEnv',
);

class EnvConfigNotifier extends StateNotifier<EnvConfigData?> {
  // Initialize with null and `AppConfigData` gets set on AppEnv.loadState
  EnvConfigNotifier() : super(null);

  void initialize(EnvConfigData config) => state = config;
  bool get isInitialized => state != null;
}

mixin EnvConfigData {
  AppEnvironment get environment;
}

mixin AppLoader<C extends EnvConfigData> {
  C get config;
  @mustCallSuper
  Future loadState(WidgetRef ref) => initializeCrashReporting();
  Future initializeCrashReporting();
  Widget createApp();
  Future onError(dynamic exception, StackTrace? stack);
  Future<void>? runGuarded() => runZonedGuarded<Future<void>>(() async {
        return runApp(createApp());
      }, (error, stackTrace) {
        print('runZonedGuarded: $error');
        onError(error, stackTrace);
      });
}

abstract class EnvConfig {
  const EnvConfig({
    required this.appName,
    required this.environment,
  });

  final String appName;
  final AppEnvironment environment;
}
