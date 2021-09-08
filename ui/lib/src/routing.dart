import 'package:flutter/widgets.dart' show BuildContext, Route;

typedef DeepLinkHandler<M> = Future<Route?> Function(
  BuildContext ctx,
  Map<String, List<String>> params,
  M manager,
);
