import 'package:flutter/foundation.dart' show defaultTargetPlatform;

import 'package:riverpod/riverpod.dart';

final $defaultTargetProvider = Provider((_) => defaultTargetPlatform);
