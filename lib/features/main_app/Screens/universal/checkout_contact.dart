import 'package:flutter/material.dart';
import 'package:flutter_mysale/core/helpers/login_helper.dart';
import 'package:flutter_mysale/core/widgets/toast_message.dart';
import 'package:flutter_mysale/features/main_app/providers/authentication_provider.dart';
import 'package:flutter_mysale/features/main_app/widgets/app_captcha.dart';
import 'package:flutter_mysale/features/main_app/widgets/auth_form.dart';
import 'package:flutter_mysale/features/main_app/widgets/checkout_contact_section.dart';
import 'package:provider/provider.dart';

enum CheckoutContactMode { loggedIn, guestCheckoutForm, loginForm, signupForm }

class CheckoutContact extends StatefulWidget {
  final CheckoutContactMode mode;
  final VoidCallback? onContinueToShipping;

  CheckoutContact({required this.mode, required this.onContinueToShipping});

  @override
  State<StatefulWidget> createState() {
    return _CheckoutContact();
  }
}

class _CheckoutContact extends State<CheckoutContact> {
  ValueNotifier<CheckoutContactMode> _mode = ValueNotifier(
    CheckoutContactMode.guestCheckoutForm,
  );

  @override
  void initState() {
    super.initState();
    _mode.value = widget.mode;
  }

  @override
  void dispose() {
    _mode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: null,
      body: _createBody(context),
    );
  }

  Widget _createBody(BuildContext context) {
    return CustomScrollView(
      slivers: [SliverToBoxAdapter(child: _createCheckoutContactSection())],
    );
  }

  Widget _createCheckoutContactSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),

      child: ValueListenableBuilder(
        valueListenable: _mode,
        builder: (_, value, _) {
          switch (value) {
            case CheckoutContactMode.guestCheckoutForm:
              return _createGuestCheckoutForm(contactInfo: null);
            case CheckoutContactMode.loginForm:
              return _createAuthForm(false);
            case CheckoutContactMode.signupForm:
              return _createAuthForm(true);
            case CheckoutContactMode.loggedIn:
              return _createGuestCheckoutForm(
                contactInfo: CheckoutContactSectionInfo(
                  isGuestCheckout: true,
                  info: 'user@gmail.com',
                  showContinueToShippingButton: true,
                ),
              );
          }
        },
      ),
    );
  }

  Widget _createGuestCheckoutForm({
    required CheckoutContactSectionInfo? contactInfo,
  }) {
    return CheckoutContactSection(
      title: 'CONTACT INFORMATION',
      contactInfo: contactInfo,
      onContinueShipping: (email) {
        print('continue to shipping $email');
        widget.onContinueToShipping?.call();
      },
      onLogin: () {
        print('login');
        _mode.value = CheckoutContactMode.loginForm;
      },
      onSignup: () {
        print('signup');
        _mode.value = CheckoutContactMode.signupForm;
      },
    );
  }

  Widget _createAuthForm(bool isSignup) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'CONTACT INFORMATION',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        SizedBox(height: 8),
        Container(
          constraints: BoxConstraints(minWidth: double.infinity),
          child: AuthForm(
            inCheckout: true,
            isSignUp: isSignup,
            onLogin: (email, password) {
              _login(email: email, password: password);
            },
            onRegister: (email, password, firstname, lastname, termsAgree, promoAgree) {
              _register(email: email, password: password, firstname: firstname, lastname: lastname, termsAgree: termsAgree, promoAgree: promoAgree);
            },
            onGoToGuestCheckout: () {
              _mode.value = CheckoutContactMode.guestCheckoutForm;
            },
          ),
        ),
      ],
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
              showMessage(context, error);
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
              showMessage(context, error);
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
