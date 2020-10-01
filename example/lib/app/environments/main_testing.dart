import 'package:dropsource_utils/dropsource_utils.dart';

import '../app_env.dart';

void main() async {
  await FlutterAppEnv(
    environment: AppEnvironment.automation,
    apiBaseUrl: 'https://my-api.com',
    appName: 'Flutter-App-Testing',
    initializeCrashlytics: false,
  ).run();
}
