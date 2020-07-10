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
    this.supportedLanguages = const [
      Locale('en', 'US'),
    ],
  });

  final String appName;
  final AppEnvironment environment;
  final bool initializeCrashlytics, enableCrashlyiticsInDevMode;
  final List<Locale> supportedLanguages;

  Future startCrashlytics() async {
    if (this.initializeCrashlytics) {
      Crashlytics.instance.enableInDevMode = enableCrashlyiticsInDevMode;
      FlutterError.onError = (FlutterErrorDetails details) {
        Crashlytics.instance.recordFlutterError(details);
      };
    }
  }

  Future<S> loadState();

  Widget createApp();

  Future run() async {
    await startCrashlytics();
    runApp(createApp());
  }
}
