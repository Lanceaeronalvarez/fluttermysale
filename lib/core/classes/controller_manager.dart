import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_mysale/features/main_app/providers/authentication_provider.dart';
import 'package:provider/provider.dart';

import '../../config/config.dart';
import '../core.dart';

// ignore: must_be_immutable
abstract class StatelessController extends StatelessWidget {
  const StatelessController({Key? key}) : super(key: key);

  bool get shouldCheckAuthentication => false;

  String get loginUrl => ApiEndpoint.appLoginUrl;

  Display view(BuildContext context);

  @override
  Widget build(BuildContext context) {
    shouldNavigateToLogin(context, shouldCheckAuthentication);
    return view(context);
  }
}

// ignore: must_be_immutable
abstract class StatefulController extends StatefulWidget {
  const StatefulController({Key? key}) : super(key: key);
}

abstract class ControllerState<T extends StatefulController> extends State<T> {
  bool get shouldCheckAuthentication => false;

  String get loginUrl => ApiEndpoint.appLoginUrl;

  Display view(BuildContext context);

  @override
  Widget build(BuildContext context) {
    shouldNavigateToLogin(context, shouldCheckAuthentication);
    return view(context);
  }
}
