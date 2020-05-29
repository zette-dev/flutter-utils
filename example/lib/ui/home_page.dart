import 'package:dropsource_utils/dropsource_utils.dart';
import 'package:flutter/material.dart';

import '../state/auth_manager.dart';

class HomePage extends StatefulWidget {
  static const String tag = 'home-page';

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: StatefulStreamBuilder<AuthManager, AuthModel>(
        stream: (manager) => manager.stream,
        initialData: (manager) => manager.model,
        onInit: (manager) => {
          // TODO: add initialization logic like running an API request, loading data, etc
        },
        onDispose: (manager) {
          // TODO: dispose of any state needed
        },
        builder: (_, manager, model) => Column(children: [
          Text(model.user?.email)
        ]),
      ),
    );
  }
}
