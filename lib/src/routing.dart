import 'package:flutter/widgets.dart' show BuildContext, Route;

typedef DeepLinkHandler = Future<Route?> Function(
    BuildContext ctx, Map<String, List<String>> params);
