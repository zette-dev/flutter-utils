import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;
import 'package:flutter/widgets.dart';

bool isTablet(BuildContext context) {
  var shortestSide = MediaQuery.sizeOf(context).shortestSide;
  var useMobileLayout = shortestSide < 600;
  return !useMobileLayout;
}

final bool kIsWebMobile =
    kIsWeb && (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android);

final bool kIsWebDesktop = kIsWeb && !kIsWebMobile;
