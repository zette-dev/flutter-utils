// ignore_for_file: use_setters_to_change_properties

import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart'
    show FlutterExceptionHandler, kIsWeb, kReleaseMode;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppEnvironment {
  staging,
  production,
  automation,
}

final envProvider = StateNotifierProvider<EnvConfigNotifier, EnvConfig?>(
  (ref) => EnvConfigNotifier(),
  name: 'AppEnv',
);

final analyticsProvider = Provider<FirebaseAnalytics?>(
  (_) => FirebaseAnalytics.instance,
  name: 'FirebaseAnalytics',
);

final crashlyticsProvider = Provider<FirebaseCrashlytics?>(
  (ref) => !kIsWeb ? FirebaseCrashlytics.instance : null,
  name: 'FirebaseCrashlytics',
);

class EnvConfigNotifier extends StateNotifier<EnvConfig?> {
  // Initialize with null and `EnvConfig` gets set on AppEnv.loadState
  EnvConfigNotifier() : super(null);

  void initialize(EnvConfig config) => state = config;
}

abstract class EnvConfig {
  EnvConfig({
    required this.appName,
    required this.environment,
    this.useCrashlytics = true,
  });

  final String appName;
  final AppEnvironment environment;
  final bool useCrashlytics;

  Future startCrashlytics(WidgetRef ref) async {
    // Wait for Firebase to initialize
    await Firebase.initializeApp();

    if (useCrashlytics) {
      final crashlytics = ref.read(crashlyticsProvider);
      await crashlytics!.setCrashlyticsCollectionEnabled(kReleaseMode);
      // Pass all uncaught errors to Crashlytics.
      FlutterExceptionHandler? originalOnError = FlutterError.onError;
      FlutterError.onError = (FlutterErrorDetails errorDetails) async {
        await crashlytics.recordFlutterError(errorDetails);
        // Forward to original handler.
        if (originalOnError != null) {
          originalOnError(errorDetails);
        }
      };
    }
  }

  Future loadState(WidgetRef ref);

  Widget createApp();

  Future<void>? runGuarded() => runZonedGuarded<Future<void>>(() async {
        return runApp(createApp());
      }, (error, stackTrace) {
        print('runZonedGuarded: $error');
        if (useCrashlytics) {
          FirebaseCrashlytics.instance.recordError(error, stackTrace);
        }
      });

  void run() {
    try {
      runApp(createApp());
    } catch (e) {
      if (useCrashlytics) {
        FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      }
    }
  }
}
