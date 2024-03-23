// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_loader.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

const _$AppEnvironmentEnumMap = {
  AppEnvironment.development: 'development',
  AppEnvironment.staging: 'staging',
  AppEnvironment.production: 'production',
  AppEnvironment.automation: 'automation',
};

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$envHash() => r'8ded257019ffd11147516ed5409afb8218ba86e7';

/// See also [env].
@ProviderFor(env)
final envProvider = Provider<EnvConfigData?>.internal(
  env,
  name: r'envProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$envHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef EnvRef = ProviderRef<EnvConfigData?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
