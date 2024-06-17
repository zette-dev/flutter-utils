import 'package:flutter/foundation.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:zette_ui/zette_ui.dart';

final $biometricsProvider = Provider<LocalAuthentication?>(
  (ref) => [TargetPlatform.iOS, TargetPlatform.android].contains(ref.watch($defaultTargetProvider))
      ? LocalAuthentication()
      : null,
  name: 'LocalAuthentication',
);

final $biometricsSupportedProvider = FutureProvider<bool>(
  (ref) => (!kIsWeb ? ref.watch($biometricsProvider)?.isDeviceSupported() : null) ?? Future.value(false),
  dependencies: [
    $biometricsProvider,
  ],
  name: 'BiometricsSupported',
);
