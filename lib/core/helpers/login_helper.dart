import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../config/config.dart';
import '../core.dart';

void shouldNavigateToLogin(
  BuildContext context,
  bool shouldCheckAuthentication,
) async {
  if (shouldCheckAuthentication) {
    bool _isLoggedIn = await isLoggedIn();
    if (!_isLoggedIn) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Nav.to(context, ApiEndpoint.appLoginUrl);
      });
    }
  }
}

Future<bool> isLoggedIn() async {
  String lt = await AppCache().loginTicket ?? '';
  return lt.isNotEmpty;
}
