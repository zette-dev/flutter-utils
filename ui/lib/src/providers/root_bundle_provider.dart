import 'package:flutter/services.dart' show AssetBundle, rootBundle;

import 'package:riverpod/riverpod.dart';

final $rootBundleProvider = Provider<AssetBundle>((ref) => rootBundle);
