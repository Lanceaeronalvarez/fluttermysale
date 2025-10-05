import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_mysale/core/helpers/login_helper.dart';
import 'package:flutter_mysale/core/helpers/style_helper.dart';
import 'package:flutter_mysale/core/widgets/toast_message.dart';
import 'package:flutter_mysale/features/main_app/providers/authentication_provider.dart';
import 'package:flutter_mysale/features/main_app/utils/helpers.dart';
import 'package:flutter_mysale/features/main_app/widgets/auth_form.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Authenthication extends StatefulWidget {
  const Authenthication({super.key});

  @override
  State<Authenthication> createState() => _AuthenthicationState();
}

class _AuthenthicationState extends State<Authenthication> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AuthForm(inCheckout: false, isSignUp: true);
  }
}
