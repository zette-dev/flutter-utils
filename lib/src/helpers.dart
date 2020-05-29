import 'dart:async';

import 'package:flutter/foundation.dart' as flutter show compute;
import 'package:flutter/foundation.dart' show ComputeCallback;
import 'package:flutter/widgets.dart';

bool isInDebugMode() {
  bool inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}

// WORKAROUND FOR NOW - isolates don't work with flutter driver
// https://github.com/flutter/flutter/issues/24703
Future<R> compute<Q, R>(ComputeCallback<Q, R> callback, Q message) async {
  if (isInDebugMode()) {
    return callback(message);
  }

  return await flutter.compute(callback, message);
}

bool isTablet(BuildContext context) {
  var shortestSide = MediaQuery.of(context).size.shortestSide;
  var useMobileLayout = shortestSide < 600;
  return !useMobileLayout;
}

int currentTimestamp() {
  return DateTime.now().millisecondsSinceEpoch ~/ 1000;
}
