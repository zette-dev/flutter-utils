import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter/material.dart';

enum AppEnvironment {
  staging,
  production,
  automation,
}

abstract class EnvConfig<S> {
  EnvConfig({
    @required this.appName,
    @required this.environment,
    this.useCrashlytics = true,
  });

  final String appName;
  final AppEnvironment environment;
  final bool useCrashlytics;

  Future startCrashlytics() async {
    // Wait for Firebase to initialize
    await Firebase.initializeApp();

    if (useCrashlytics) {
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
        print('runZonedGuarded: $error');
        if (useCrashlytics) {
          FirebaseCrashlytics.instance.recordError(error, stackTrace);
        }
      });
}
