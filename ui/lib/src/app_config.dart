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

final envProvider = StateNotifierProvider<EnvConfigNotifier, AppConfigData?>(
  (ref) => EnvConfigNotifier(),
  name: 'AppEnv',
);

class EnvConfigNotifier extends StateNotifier<AppConfigData?> {
  // Initialize with null and `AppConfigData` gets set on AppEnv.loadState
  EnvConfigNotifier() : super(null);

  void initialize(AppConfigData config) => state = config;
  bool get isInitialized => state != null;
}

mixin AppConfigData {
  AppEnvironment get environment;
}

mixin AppLoader {
  AppConfigData get config;
  @mustCallSuper
  Future loadState(WidgetRef ref) => initializeCrashReporting();
  Future initializeCrashReporting();
  Widget createApp();
  Future recordCrash(dynamic exception, StackTrace? stack);
  Future<void>? runGuarded() => runZonedGuarded<Future<void>>(() async {
        return runApp(createApp());
      }, (error, stackTrace) {
        print('runZonedGuarded: $error');
        recordCrash(error, stackTrace);
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
