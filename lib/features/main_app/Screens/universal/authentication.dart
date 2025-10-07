import 'package:flutter/material.dart';
import 'package:flutter_mysale/core/helpers/login_helper.dart';
import 'package:flutter_mysale/core/widgets/toast_message.dart';
import 'package:flutter_mysale/features/main_app/providers/authentication_provider.dart';
import 'package:flutter_mysale/features/main_app/widgets/app_captcha.dart';
import 'package:flutter_mysale/features/main_app/widgets/auth_form.dart';
import 'package:provider/provider.dart';

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
    return AuthForm(
      inCheckout: false,
      isSignUp: true,
      onLogin: (email, password) {
        _login(email: email, password: password);
      },
      onRegister:
          (email, password, firstname, lastname, termsAgree, promoAgree) {
            _register(
              email: email,
              password: password,
              firstname: firstname,
              lastname: lastname,
              termsAgree: termsAgree,
              promoAgree: promoAgree,
            );
          },
    );
  }

  void _login({required String email, required String password}) {
    AuthenthicationProvider p = context.read<AuthenthicationProvider>();
    p.isLoading = true;
    AppCaptcha.showCaptcha(
      parentContext: context,
      onMessageReceived: (captchaToken) {
        Navigator.of(context).pop();
        p
            .callLoginViaEmail(email, password, captchaToken)
            .then((data) {
              doAuth(context, email, password);
              showMessage(context, 'Login Successful');
              p.isLoading = false;
            })
            .catchError((error) {
              showMessage(context, error.toString());
              p.isLoading = false;
            });
      },
      onClose: () {
        Navigator.of(context).pop();
        p.isLoading = false;
      },
    );
  }

  void _register({
    required String email,
    required String password,
    required String firstname,
    required String lastname,
    required bool termsAgree,
    required bool promoAgree,
  }) {
    AuthenthicationProvider p = context.read<AuthenthicationProvider>();
    p.isLoading = true;
    AppCaptcha.showCaptcha(
      parentContext: context,
      onMessageReceived: (captchaToken) {
        Navigator.of(context).pop();
        p
            .callRegistration(
              firstname,
              lastname,
              email,
              password,
              captchaToken,
              termsAgree,
              promoAgree,
            )
            .then((data) {
              doAuth(context, email, password);
              showMessage(context, 'Registration Successful');
              p.isLoading = false;
            })
            .catchError((error) {
              showMessage(context, error.toString());
              p.isLoading = false;
            });
      },
      onClose: () {
        Navigator.of(context).pop();
        p.isLoading = false;
      },
    );
  }

}
