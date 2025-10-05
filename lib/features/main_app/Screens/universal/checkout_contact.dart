import 'package:flutter/material.dart';
import 'package:flutter_mysale/features/main_app/widgets/auth_form.dart';
import 'package:flutter_mysale/features/main_app/widgets/checkout_contact_section.dart';

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
            onGoToGuestCheckout: () {
              _mode.value = CheckoutContactMode.guestCheckoutForm;
            },
          ),
        ),
      ],
    );
  }
}
