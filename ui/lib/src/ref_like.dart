import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef ProviderReader<T> = T Function<T>(ProviderListenable<T> provider);

class RefLike<T> {
  final ProviderReader<T> read;
  final ProviderReader<T> watch;
  final T Function<T>(Refreshable<T>) refresh;
  final void Function(ProviderOrFamily provider) invalidate;
  final dynamic _originalRef;

  BuildContext? get context => _originalRef is WidgetRef ? _originalRef.context : null;

  const RefLike._(
    this._originalRef,
    this.read,
    this.watch,
    this.refresh,
    this.invalidate,
  );

  factory RefLike.fromWidget(WidgetRef ref) => RefLike._(
        ref,
        ref.read,
        ref.watch,
        ref.refresh,
        ref.invalidate,
      );

  factory RefLike.fromRef(Ref ref) => RefLike._(
        ref,
        ref.read,
        ref.read,
        ref.refresh,
        ref.invalidate,
      );

  factory RefLike.fromContainer(ProviderContainer ref) => RefLike._(
        ref,
        ref.read,
        ref.read,
        ref.refresh,
        ref.invalidate,
      );
}
