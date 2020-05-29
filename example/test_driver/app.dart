import '../lib/app/environments/main_testing.dart' as app;
import 'package:flutter_driver/flutter_driver.dart';
void main() {
  // This line enables the extension
  enableFlutterDriverExtension();

  // Call the `main()` function of your app or call `runApp` with any widget you
  // are interested in testing.
  app.main();
}

// flutter drive --target=test_driver/app.dart --flavor testing
