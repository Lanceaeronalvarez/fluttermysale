import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_mysale/core/helpers/login_helper.dart';
import 'package:flutter_mysale/core/helpers/style_helper.dart';
import 'package:flutter_mysale/core/widgets/toast_message.dart';
import 'package:flutter_mysale/features/main_app/providers/authentication_provider.dart';
import 'package:flutter_mysale/features/main_app/utils/helpers.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AuthForm extends StatefulWidget {
  final String _pathCheckbox = 'assets/images/filterCheckbox.png';
  final String _pathCheckboxChecked = 'assets/images/filterCheckboxChecked.png';

  final bool inCheckout;
  final bool isSignUp;
  final VoidCallback? onGoToGuestCheckout;

  AuthForm({
    required this.inCheckout,
    required this.isSignUp,
    this.onGoToGuestCheckout,
  });

  @override
  State<StatefulWidget> createState() {
    return _AuthFormState();
  }
}

class _AuthFormState extends State<AuthForm> {
  //TODO: JCA move in a config file
  final String _recaptchaHtml = 'assets/recaptcha.html';
  WebViewController _webController = WebViewController();

  ValueNotifier<bool> _isSignUp = ValueNotifier<bool>(true);
  ValueNotifier<String?> _formError = ValueNotifier<String?>(null);
  ValueNotifier<bool> _isAgreeToTermsAndPrivacy = ValueNotifier<bool>(true);
  ValueNotifier<bool> _isAgreeToReceivePromotions = ValueNotifier<bool>(true);

  final _formKey = GlobalKey<FormState>();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  late final TapGestureRecognizer _termsRecognizer;
  late final TapGestureRecognizer _privacyRecognizer;
  late final TapGestureRecognizer _goToSigninFormRecognizer;
  late final TapGestureRecognizer _goToSignupFormRecognizer;
  late final TapGestureRecognizer _goToGuestCheckoutRecognizer;

  @override
  void dispose() {
    _isSignUp.dispose();
    _formError.dispose();
    _isAgreeToTermsAndPrivacy.dispose();
    _isAgreeToReceivePromotions.dispose();

    _termsRecognizer.dispose();
    _privacyRecognizer.dispose();
    _goToSigninFormRecognizer.dispose();
    _goToSignupFormRecognizer.dispose();
    _goToGuestCheckoutRecognizer.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _isSignUp.value = widget.isSignUp;

    _termsRecognizer = TapGestureRecognizer()
      ..onTap = () {
        //TODO: JCA show terms
      };
    _privacyRecognizer = TapGestureRecognizer()
      ..onTap = () {
        //TODO: JCA show privacy
      };
    _goToSigninFormRecognizer = TapGestureRecognizer()
      ..onTap = () {
        _isSignUp.value = false;
      };
    _goToSignupFormRecognizer = TapGestureRecognizer()
      ..onTap = () {
        _isSignUp.value = true;
      };
    _goToGuestCheckoutRecognizer = TapGestureRecognizer()
      ..onTap = () {
        widget.onGoToGuestCheckout?.call();
      };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: checkoutGrey,
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _createTitle(),
          const SizedBox(height: 8),
          _createDescription(),
          const SizedBox(height: 18),
          _createForm(),
          //_createBottomText(),
        ],
      ),
    );
  }

  Widget _createTitle() {
    return ValueListenableBuilder(
      valueListenable: _isSignUp,
      builder: (_, isSignupForm, _) {
        String title = isSignupForm ? 'New Customers' : 'Existing Customers';
        return Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        );
      },
    );
  }

  Widget _createDescription() {
    return ValueListenableBuilder(
      valueListenable: _isSignUp,
      builder: (_, isSignupForm, _) {
        String description = isSignupForm
            ? 'Sign up for faster checkout and order history'
            : 'Sign in for faster checkout and order history';
        return Text(
          description,
          style: TextStyle(color: Colors.black, fontSize: 12),
        );
      },
    );
  }

  Widget _createForm() {
    return ValueListenableBuilder(
      valueListenable: _isSignUp,
      builder: (_, isSignupForm, _) {
        final emailLabel = isSignupForm ? 'Email' : 'Username of Email';
        return Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: Column(
            children: [
              if (isSignupForm)
                _createTextFieldWithLabel(
                  controller: _firstNameController,
                  label: 'First Name',
                ),
              if (isSignupForm)
                _createTextFieldWithLabel(
                  controller: _lastNameController,
                  label: 'Last Name',
                ),
              _createTextFieldWithLabel(
                controller: _emailController,
                label: emailLabel,
                validator: (value) {
                  final t = value?.trim() ?? '';
                  if (t.isEmpty) {
                    return 'This field is required.';
                  } else if (isSignupForm && !t.isValidEmail) {
                    return 'Please enter email with correct format.';
                  } else {
                    return null;
                  }
                },
              ),
              _createTextFieldWithLabel(
                controller: _passwordController,
                label: 'Password',
                obscureText: true,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) {
                  _onButtonClick(
                    isSignupForm: isSignupForm,
                    provider: context.read<AuthenthicationProvider>(),
                  );
                },
              ),
              if (isSignupForm) _createTermsAndConditionContainer(),
              if (isSignupForm) _createPromotionContainer(),
              if (isSignupForm) _createErrorText(),
              SizedBox(height: 16),
              _createLogInButton(isSignupForm: isSignupForm),
              SizedBox(height: 16),
              _createFooter(),
            ],
          ),
        );
      },
    );
  }

  Widget _createTextFieldWithLabel({
    required TextEditingController controller,
    required String label,
    bool obscureText = false,
    TextInputType? textInputType,
    TextInputAction textInputAction = TextInputAction.next,
    String? Function(String?)? validator,
    void Function(String)? onFieldSubmitted,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(0, 4, 0, 16),
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            decoration: textfieldInputDecoration.copyWith(
              hintText: 'Enter your $label',
            ),
            keyboardType: textInputType,
            textInputAction: textInputAction,
            validator:
                validator ??
                (textValue) {
                  final t = textValue?.trim() ?? '';
                  if (t.isEmpty) {
                    return 'This field is required.';
                  } else {
                    return null;
                  }
                },
            onFieldSubmitted:
                onFieldSubmitted ??
                (_) {
                  FocusScope.of(context).nextFocus();
                },
          ),
        ),
      ],
    );
  }

  Widget _createErrorText() {
    return ValueListenableBuilder(
      valueListenable: _formError,
      builder: (_, haveError, _) {
        if (haveError != null && haveError.isNotEmpty) {
          return Container(
            margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
            constraints: BoxConstraints(minWidth: double.infinity),
            child: Text(
              haveError,
              style: const TextStyle(color: Color(0xffB3261E), fontSize: 12),
              textAlign: TextAlign.left,
              maxLines: 2,
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _createLogInButton({required bool isSignupForm}) {
    return Consumer<AuthenthicationProvider>(
      builder: (_, provider, __) {
        return ElevatedButton(
          onPressed: () {
            provider.isLoading
                ? null
                : _onButtonClick(
                    isSignupForm: isSignupForm,
                    provider: provider,
                  );
          },
          style: appElevatedButtonStyle,
          child: provider.isLoading
              ? const CircularProgressIndicator(color: Colors.black)
              : Text((isSignupForm) ? 'Signup' : 'Sign in'),
        );
      },
    );
  }

  Widget _createTermsAndConditionContainer() {
    return FormField<bool>(
      initialValue: false,
      validator: (v) {
        _formError.value = (v ?? false)
            ? null
            : 'Please agree to the Terms and Conditions and Privacy Policy.';
        return _formError.value;
      },
      builder: (state) {
        final isChecked = state.value ?? false;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                state.didChange(!isChecked);
              },
              child: _createTermsAndCondition(isChecked),
            ),
            SizedBox(height: 12),
          ],
        );
      },
    );
  }

  Widget _createTermsAndCondition(bool isChecked) {
    const baseStyle = TextStyle(color: Colors.black, fontSize: 12);
    final linkStyle = TextStyle(
      color: beigeColor,
      decoration: TextDecoration.underline,
      decorationThickness: 1.5,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: FittedBox(
            fit: BoxFit.contain,
            child: isChecked
                ? Image.asset(widget._pathCheckboxChecked)
                : Image.asset(widget._pathCheckbox),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: baseStyle,
              children: [
                const TextSpan(text: 'I agree to the '),
                TextSpan(
                  text: 'Terms and Conditions',
                  style: linkStyle,
                  recognizer: _termsRecognizer,
                ),
                const TextSpan(text: ' and '),
                TextSpan(
                  text: 'Privacy Policy',
                  style: linkStyle,
                  recognizer: _privacyRecognizer,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _createPromotionContainer() {
    return FormField<bool>(
      initialValue: false,
      builder: (state) {
        final isChecked = state.value ?? false;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                state.didChange(!isChecked);
              },
              child: _createPromotion(isChecked),
            ),
          ],
        );
      },
    );
  }

  Widget _createPromotion(bool isChecked) {
    const baseStyle = TextStyle(color: Colors.black, fontSize: 12);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: FittedBox(
            fit: BoxFit.contain,
            child: isChecked
                ? Image.asset(widget._pathCheckboxChecked)
                : Image.asset(widget._pathCheckbox),
          ),
        ),
        const SizedBox(width: 8),
        const Expanded(
          child: Text(
            'I agree to receive promotional communication featuring our hottest deals and smartest prices on leading brands',
            style: baseStyle,
            maxLines: null,
          ),
        ),
      ],
    );
  }

  Widget _createFooter() {
    const baseStyle = TextStyle(color: Colors.black, fontSize: 12);
    final linkStyle = TextStyle(
      color: beigeColor,
      decoration: TextDecoration.underline,
      decorationThickness: 1.5,
    );

    String initialText = (_isSignUp.value)
        ? 'Already have an account? '
        : 'Don\'t have an account? ';
    String actionText = (_isSignUp.value) ? 'Sign in' : 'Create one';

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: baseStyle,
        children: [
          TextSpan(text: initialText),
          TextSpan(
            text: actionText,
            style: linkStyle,
            recognizer: (_isSignUp.value)
                ? _goToSigninFormRecognizer
                : _goToSignupFormRecognizer,
          ),
          if (widget.inCheckout) const TextSpan(text: ' OR '),
          if (widget.inCheckout)
            TextSpan(
              text: 'Continue without an account',
              style: linkStyle,
              recognizer: _goToGuestCheckoutRecognizer,
            ),
        ],
      ),
    );
  }

  //----------------------------

  void _onButtonClick({
    required bool isSignupForm,
    required AuthenthicationProvider provider,
  }) {
    final form = _formKey.currentState!;
    if (form.validate()) {
      _createCaptcha(isSignupForm: isSignupForm, provider: provider);
      provider.isLoading = true;
    } else {
      //isShowError.value = true;
    }
  }

  Future<void> _createCaptcha({
    required bool isSignupForm,
    required AuthenthicationProvider provider,
  }) async {
    _webController.setJavaScriptMode(JavaScriptMode.unrestricted);
    _webController.addJavaScriptChannel(
      'Captcha',
      onMessageReceived: (data) {
        if (isSignupForm) {
          _register(data.message, provider);
        } else {
          _login(data.message, provider);
        }
        Navigator.of(context).pop();
      },
    );

    loadHtmlAsset().then((String value) {
      _webController.loadHtmlString(
        value,
        baseUrl: dotenv.get("SETTINGS_ROOT"),
      );
    });

    showModalBottomSheet(
      isDismissible: false,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 700,
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close, weight: 20),
                  onPressed: () {
                    provider.isLoading = false;
                    Navigator.pop(context);
                  },
                ),
              ),
              SizedBox(
                height: 600,
                child: WebViewWidget(controller: _webController),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<String> loadHtmlAsset() async {
    String captcha = await rootBundle.loadString(_recaptchaHtml);
    captcha = captcha.replaceAll(
      "CAPTCHA_SITE_KEY",
      "'${dotenv.get("FLAVOR_RECAPTCHA_SITE_KEY")}'",
    );
    return captcha;
  }

  void _login(String token, AuthenthicationProvider provider) {
    provider
        .callLoginViaEmail(
          _emailController.value.text,
          _passwordController.value.text,
          token,
        )
        .then((data) {
          provider.isLoading = false;
          doAuth(
            context,
            _emailController.value.text,
            _passwordController.value.text,
          );
          showMessage(context, 'Login Successful');
        })
        .catchError((error) {
          provider.isLoading = false;
          showMessage(context, error);
        });
  }

  void _register(String token, AuthenthicationProvider provider) {
    provider
        .callRegistration(
          _firstNameController.value.text,
          _lastNameController.value.text,
          _emailController.value.text,
          _passwordController.value.text,
          token,
          _isAgreeToTermsAndPrivacy.value,
          _isAgreeToReceivePromotions.value,
        )
        .then((data) {
          provider.isLoading = false;
          doAuth(
            context,
            _emailController.value.text,
            _passwordController.value.text,
          );
          showMessage(context, 'Login Successful');
        })
        .catchError((error) {
          provider.isLoading = false;
          showMessage(context, error);
        });
  }
}
