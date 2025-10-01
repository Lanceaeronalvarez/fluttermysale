import 'package:flutter/material.dart';
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
      child: CheckoutContactSection(
        title: 'CONTACT INFORMATION',
        //contactInfo: (true, 'user@gmail.com'),
        contactInfo: null,
        onContinueShipping: (email) {
          print('continue to shipping $email');
          widget.onContinueToShipping?.call();
        },
        onLogin: () {
          print('login');
        },
        onSignup: () {
          print('signup');
        },
      ),
    );
  }
}
