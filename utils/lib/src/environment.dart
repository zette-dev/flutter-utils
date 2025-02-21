// ignore_for_file: use_setters_to_change_properties

import 'package:riverpod/riverpod.dart';

const _$AppEnvironmentEnumValueMap = {
  'development': AppEnvironment.dev1,
  'dev': AppEnvironment.dev1,
  'dev1': AppEnvironment.dev1,
  'dev2': AppEnvironment.dev2,
  'staging': AppEnvironment.staging,
  'qa': AppEnvironment.qa,
  'production': AppEnvironment.prod,
  'prod': AppEnvironment.prod,
  'automation': AppEnvironment.automation,
};

enum AppEnvironment {
  dev1,
  dev2,
  staging,
  qa,
  prod,
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
