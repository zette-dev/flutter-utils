import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

enum AppEnvironment {
  staging,
  production,
  automation,
}

abstract class EnvConfig<S> {
  EnvConfig({
    @required this.appName,
    @required this.environment,
    this.initializeCrashlytics = true,
    this.enableCrashlyiticsInDevMode = true,
  });

  final String appName;
  final AppEnvironment environment;
  final bool initializeCrashlytics, enableCrashlyiticsInDevMode;

  Future startCrashlytics() async {
    if (initializeCrashlytics) {
      await FirebaseCrashlytics.instance
          .setCrashlyticsCollectionEnabled(enableCrashlyiticsInDevMode);
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    }
  }

  Future<S> loadState();

  Widget createApp();

  Future run() async {
    await startCrashlytics();
    runApp(createApp());
  }
}
