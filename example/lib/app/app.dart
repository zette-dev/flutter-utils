import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../state/auth_manager.dart';
import '../themes/default_theme.dart' show theme;
import '../ui/home_page.dart';
import 'app_env.dart';

class FlutterApp extends StatefulWidget {
  FlutterApp(this.env);
  final FlutterAppEnv env;

  @override
  State<StatefulWidget> createState() {
    return FlutterAppState();
  }
}

class FlutterAppState extends State<FlutterApp> {
  AppState _state;

  @override
  void initState() {
    super.initState();
    widget.env.loadState().then((state) {
      setState(() => _state = state);
    });
    // TODO: Initialize any global services
    // - Push Notifications
    // - Crash Reporting (Firebase crashlytics)
    // - Connectivity monitoring
  }

  Widget determineHomeScreen(AppState appState) {
    // TODO: Add logic to determine the home screen of the app
    // if (appState)
    return HomePage();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // TODO: Add providers for app data
        Provider<AuthManager>.value(value: _state.authManager),
      ],
      child: MaterialApp(
        title: widget.env.appName,
        theme: theme,
        home: determineHomeScreen(_state),
        routes: {
          HomePage.tag: (_) => HomePage(),
        },
        navigatorKey: AppState.navigatorKey,
        navigatorObservers: [],
      ),
    );
  }

  @override
  void dispose() async {
    // TODO: dispose of any global services that were initialized
    super.dispose();
  }
}
