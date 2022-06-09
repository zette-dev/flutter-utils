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

abstract class AppLoader<C extends EnvConfigData> {
  AppLoader(this.config);
  final C config;
  Future init(WidgetRef ref);
  Widget appBuilder();
  void onError(Object error, StackTrace? stack);
  void onBeforeRunApp() {}
  Future<void>? runGuarded() => runZonedGuarded<Future<void>>(() async {
        onBeforeRunApp();
        return runApp(appBuilder());
      }, (error, stackTrace) {
        print('runZonedGuarded: $error');
        onError(error, stackTrace);
      });
}
