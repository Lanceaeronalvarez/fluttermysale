import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mysale/core/helpers/style_helper.dart';
import 'package:flutter_mysale/features/main_app/utils/helpers.dart';

class CheckoutContactSectionInfo {
  bool isGuestCheckout;
  String info;
  bool showContinueToShippingButton;

  CheckoutContactSectionInfo({
    required this.isGuestCheckout,
    required this.info,
    required this.showContinueToShippingButton,
  });
}

class CheckoutContactSection extends StatelessWidget {
  final String title;
  final CheckoutContactSectionInfo? contactInfo;
  final Function(String)? onContinueShipping;
  final VoidCallback? onLogin;
  final VoidCallback? onSignup;

  CheckoutContactSection({
    required this.title,
    required this.contactInfo,
    required this.onContinueShipping,
    required this.onLogin,
    required this.onSignup,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = (contactInfo == null)
        ? _createForm()
        : _createInfoContainer(contactInfo: contactInfo!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        SizedBox(height: 8),
        Container(
          constraints: BoxConstraints(minWidth: double.infinity),
          child: Padding(padding: const EdgeInsets.all(16.0), child: content),
          decoration: BoxDecoration(
            color: checkoutGrey,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }

  Widget _createInfoContainer({
    required CheckoutContactSectionInfo contactInfo,
  }) {
    return Column(
      children: [
        Container(
          constraints: BoxConstraints(minWidth: double.infinity),
          child: _createInfoText(contactInfo: contactInfo),
        ),
        if (contactInfo.showContinueToShippingButton)
          const SizedBox(height: 16),
        if (contactInfo.showContinueToShippingButton) _createInfoButton(),
      ],
    );
  }

  Widget _createInfoText({required CheckoutContactSectionInfo contactInfo}) {
    if (contactInfo.isGuestCheckout) {
      return Text(
        contactInfo.info,
        style: TextStyle(fontWeight: FontWeight.bold),
      );
    } else {
      return RichText(
        text: TextSpan(
          style: TextStyle(color: Colors.black),
          children: [
            TextSpan(text: 'Signed in as: '),
            TextSpan(
              text: contactInfo.info,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    }
  }

  Widget _createInfoButton() {
    return ElevatedButton(
      onPressed: () {
        onContinueShipping?.call('');
      },
      style: appElevatedButtonStyle,
      child: Text('CONTINUE TO SHIPPING'),
    );
  }

  Widget _createForm() {
    return _GuestCheckoutForm(
      onContinueShipping: onContinueShipping,
      onLogin: onLogin,
      onSignup: onSignup,
    );
  }
}

class _GuestCheckoutForm extends StatefulWidget {
  final Function(String)? onContinueShipping;
  final VoidCallback? onLogin;
  final VoidCallback? onSignup;

  _GuestCheckoutForm({
    required this.onContinueShipping,
    required this.onLogin,
    required this.onSignup,
  });

  @override
  State<StatefulWidget> createState() {
    return _GuestCheckoutFormState();
  }
}

class _GuestCheckoutFormState extends State<_GuestCheckoutForm> {
  late final Function(String)? _onContinueShipping;
  late final TextEditingController _emailController;
  ValueNotifier<String?> _error = ValueNotifier<String?>(null);
  late final TapGestureRecognizer _onLoginTap;
  late final TapGestureRecognizer _onSignupTap;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _onContinueShipping = widget.onContinueShipping;
    _onLoginTap = TapGestureRecognizer()..onTap = widget.onLogin;
    _onSignupTap = TapGestureRecognizer()..onTap = widget.onSignup;
  }

  @override
  void dispose() {
    _error.dispose();
    _emailController.dispose();
    _onLoginTap.dispose();
    _onSignupTap.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double spacing = 8;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Guest Checkout',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        SizedBox(height: spacing / 2),
        const Text(
          'Continue without an account',
          style: TextStyle(color: Colors.black, fontSize: 12),
        ),
        SizedBox(height: spacing * 2),
        const Text(
          'Email',
          style: TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: spacing / 2),
        _createEmailField(),
        SizedBox(height: spacing * 2),
        _createContinueToShippingButton(),
        SizedBox(height: spacing),
        _createFooter(),
      ],
    );
  }

  Widget _createEmailField() {
    return ValueListenableBuilder(
      valueListenable: _error,
      builder: (_, emailError, _) {
        return TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          autofillHints: const [AutofillHints.email],
          style: textfieldStyle,
          decoration: textfieldInputDecoration.copyWith(
            hintText: 'Enter your email',
            errorText: emailError,
          ),
        );
      },
    );
  }

  Widget _createContinueToShippingButton() {
    return ElevatedButton(
      onPressed: () {
        String emailText = _emailController.text.trim();
        if (emailText.isEmpty) {
          _error.value = 'This field is required.';
        } else if (emailText.isValidEmail) {
          print('CONTINUE TO SHIPPING');
          _error.value = null;
          _onContinueShipping?.call(emailText);
        } else {
          _error.value = 'Please enter email with correct format.';
        }
      },
      style: appElevatedButtonStyle,
      child: Text('CONTINUE TO SHIPPING'),
    );
  }

  Widget _createFooter() {
    return Container(
      constraints: BoxConstraints(minWidth: double.infinity),
      child: RichText(
        textAlign: TextAlign.center,
        maxLines: 2,
        text: TextSpan(
          style: TextStyle(color: Colors.black, fontSize: 12, height: 2),
          children: [
            TextSpan(text: 'Have an account? '),
            TextSpan(
              text: 'Sign in',
              style: TextStyle(
                color: beigeColor,
                decoration: TextDecoration.underline,
                decorationColor: beigeColor,
                decorationThickness: 1,
                decorationStyle: TextDecorationStyle.solid,
              ),
              recognizer: _onLoginTap,
            ),
            TextSpan(text: ' OR '),
            TextSpan(
              text: 'Create one',
              style: TextStyle(
                color: beigeColor,
                decoration: TextDecoration.underline,
                decorationColor: beigeColor,
                decorationThickness: 1,
                decorationStyle: TextDecorationStyle.solid,
              ),
              recognizer: _onSignupTap,
            ),
          ],
        ),
      ),
    );
  }
}
