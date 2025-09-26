import 'package:flutter/material.dart';
import 'package:flutter_mysale/features/main_app/Screens/universal/authentication.dart';

class LoginController extends StatelessWidget {
  const LoginController({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Title(
      title: 'Login Section',
      color: Colors.blue,
      child: const Authenthication(),
    );
  }
}
