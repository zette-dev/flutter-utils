import 'package:dropsource_utils/dropsource_utils.dart';

import '../app_env.dart';

void main() async {
  await FlutterAppEnv(
    environment: AppEnvironment.staging,
    apiBaseUrl: 'https://my-api.com',
    appName: 'Flutter-App-QA',
    initializeCrashlytics: true,
  ).run();
}
