// ignore_for_file: use_setters_to_change_properties

import 'package:riverpod/riverpod.dart';

const _$AppEnvironmentEnumValueMap = {
  'development': AppEnvironment.development,
  'staging': AppEnvironment.staging,
  'production': AppEnvironment.production,
  'automation': AppEnvironment.automation,
};

enum AppEnvironment {
  development,
  staging,
  production,
  automation;

  static AppEnvironment? fromString(String value) => _$AppEnvironmentEnumValueMap[value];
}

final $envProvider = Provider<EnvConfigData?>(
  (ref) => null,
  name: 'AppEnvProvider',
);

mixin EnvConfigData {
  AppEnvironment get environment;
  String? get sentryDsn;
  String get buildName;
  String get buildVersion;
  String get buildNumber;
}
