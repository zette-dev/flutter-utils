import 'package:app_links/app_links.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';

final $appLinksProvider = Provider<AppLinks?>((ref) => AppLinks());

final _$appLinksListener = Provider((ref) => ref.read($appLinksProvider)?.uriLinkStream);

final $deepLinksProvider = Provider<BehaviorSubject<Uri>>((ref) {
  final controller = BehaviorSubject<Uri>();
  ref.read(_$appLinksListener)?.listen((e) {
    print(e);
    controller.add(e);
  });
  return controller;
});

final $pendingDeepLinkProvider = StateProvider<Uri?>((ref) => null);
