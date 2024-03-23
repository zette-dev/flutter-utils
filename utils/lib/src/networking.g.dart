// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'networking.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dioClientHash() => r'ed3de7fa78985363e184fafeff23ebab34285d89';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [dioClient].
@ProviderFor(dioClient)
const dioClientProvider = DioClientFamily();

/// See also [dioClient].
class DioClientFamily extends Family<Dio> {
  /// See also [dioClient].
  const DioClientFamily();

  /// See also [dioClient].
  DioClientProvider call({
    required String baseUrl,
  }) {
    return DioClientProvider(
      baseUrl: baseUrl,
    );
  }

  @override
  DioClientProvider getProviderOverride(
    covariant DioClientProvider provider,
  ) {
    return call(
      baseUrl: provider.baseUrl,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'dioClientProvider';
}

/// See also [dioClient].
class DioClientProvider extends Provider<Dio> {
  /// See also [dioClient].
  DioClientProvider({
    required String baseUrl,
  }) : this._internal(
          (ref) => dioClient(
            ref as DioClientRef,
            baseUrl: baseUrl,
          ),
          from: dioClientProvider,
          name: r'dioClientProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$dioClientHash,
          dependencies: DioClientFamily._dependencies,
          allTransitiveDependencies: DioClientFamily._allTransitiveDependencies,
          baseUrl: baseUrl,
        );

  DioClientProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.baseUrl,
  }) : super.internal();

  final String baseUrl;

  @override
  Override overrideWith(
    Dio Function(DioClientRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DioClientProvider._internal(
        (ref) => create(ref as DioClientRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        baseUrl: baseUrl,
      ),
    );
  }

  @override
  ProviderElement<Dio> createElement() {
    return _DioClientProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DioClientProvider && other.baseUrl == baseUrl;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, baseUrl.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin DioClientRef on ProviderRef<Dio> {
  /// The parameter `baseUrl` of this provider.
  String get baseUrl;
}

class _DioClientProviderElement extends ProviderElement<Dio> with DioClientRef {
  _DioClientProviderElement(super.provider);

  @override
  String get baseUrl => (origin as DioClientProvider).baseUrl;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
