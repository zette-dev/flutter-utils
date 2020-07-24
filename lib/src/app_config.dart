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
    this.supportedLocales = const [
      Locale('en', 'US'),
    ],
  });

  final String appName;
  final AppEnvironment environment;
  final bool initializeCrashlytics, enableCrashlyiticsInDevMode;
  final List<Locale> supportedLocales;

  Future startCrashlytics() async {
    if (initializeCrashlytics) {
      Crashlytics.instance.enableInDevMode = enableCrashlyiticsInDevMode;
      FlutterError.onError = Crashlytics.instance.recordFlutterError;
    }
  }

  Future<S> loadState();

  Widget createApp();

  Future run() async {
    await startCrashlytics();
    runApp(createApp());
  }
}
