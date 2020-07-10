import 'package:dropsource_utils/dropsource_utils.dart';

import '../app_env.dart';

void main() async {
  await FlutterAppEnv(
    environment: AppEnvironment.testing,
    apiBaseUrl: 'https://my-api.com',
    appName: 'Flutter-App-Testing',
    initializeCrashlytics: false,
  ).run();
}
