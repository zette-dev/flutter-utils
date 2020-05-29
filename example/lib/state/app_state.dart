import 'package:flutter/widgets.dart';

import 'auth_manager.dart';

class AppState {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
      AppState({this.authManager});
      final AuthManager authManager;

  void dispose() {
    authManager?.dispose();
  }
}
