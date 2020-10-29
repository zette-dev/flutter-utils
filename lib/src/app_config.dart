import 'dart:async';

import 'package:dropsource_utils/src/helpers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;
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
    // Wait for Firebase to initialize
    await Firebase.initializeApp();

    if (initializeCrashlytics) {
      await FirebaseCrashlytics.instance
          .setCrashlyticsCollectionEnabled(kReleaseMode);
      // Pass all uncaught errors to Crashlytics.
      Function originalOnError = FlutterError.onError;
      FlutterError.onError = (FlutterErrorDetails errorDetails) async {
        await FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
        // Forward to original handler.
        originalOnError(errorDetails);
      };
    }
  }

  Future<S> loadState();

  Widget createApp();

  Future run() => runZonedGuarded(() async {
        runApp(createApp());
      }, (error, stackTrace) {
        print('runZonedGuarded: Caught error in my root zone.');
        FirebaseCrashlytics.instance.recordError(error, stackTrace);
      });
}
