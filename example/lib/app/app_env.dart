import 'dart:async';

import 'package:dropsource_utils/dropsource_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../state/app_state.dart';
import 'app.dart';

class FlutterAppEnv extends EnvConfig<AppState> {
  FlutterAppEnv({
    @required String appName,
    @required AppEnvironment environment,
    @required this.apiBaseUrl,
    bool initializeCrashlytics = true,
  }) : super(
          appName: appName,
          environment: environment,
          useCrashlytics: initializeCrashlytics,
        );

  final String apiBaseUrl;

  @override
  Future<AppState> loadState() async {
    // TODO: load state from any services your app uses
    return AppState();
  }

  @override
  Widget createApp() {
    return FlutterApp(this);
  }
}
