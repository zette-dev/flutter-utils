library ds_crashlytics;

// ignore_for_file: use_setters_to_change_properties

import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart'
    show FlutterExceptionHandler, kIsWeb, kReleaseMode;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final crashlyticsProvider = Provider<FirebaseCrashlytics?>(
  (ref) => !kIsWeb ? FirebaseCrashlytics.instance : null,
  name: 'FirebaseCrashlytics',
);

mixin CrashlyticsLoader {
  Future startCrashlytics(WidgetRef ref) async {
    // Wait for Firebase to initialize
    await Firebase.initializeApp();

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

  Widget createApp();

  Future<void>? runGuarded() => runZonedGuarded<Future<void>>(() async {
        return runApp(createApp());
      }, (error, stackTrace) {
        print('runZonedGuarded: $error');
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(error, stackTrace);
        }
      });

  void run() {
    try {
      runApp(createApp());
    } catch (e) {
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      }
    }
  }
}
