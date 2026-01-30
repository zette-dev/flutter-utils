import 'package:app_links/app_links.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:rxdart/rxdart.dart';
import 'package:zette_utils/zette_utils.dart' show logger;

final $appLinksProvider = Provider<AppLinks?>((ref) => AppLinks());

final _$appLinksListener = Provider(
  (ref) => ref.read($appLinksProvider)?.uriLinkStream,
);

final $deepLinksProvider = Provider<BehaviorSubject<Uri>>((ref) {
  final controller = BehaviorSubject<Uri>();
  ref.read(_$appLinksListener)?.listen((uri) {
    logger.i('Deep link received: $uri');
    controller.add(uri);
  });
  return controller;
});

final $pendingDeepLinkProvider = StateProvider<Uri?>((ref) => null);
