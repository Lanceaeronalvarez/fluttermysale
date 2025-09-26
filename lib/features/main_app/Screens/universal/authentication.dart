import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_mysale/core/helpers/login_helper.dart';
import 'package:flutter_mysale/core/helpers/style_helper.dart';
import 'package:flutter_mysale/core/widgets/toast_message.dart';
import 'package:flutter_mysale/features/main_app/providers/authentication_provider.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Authenthication extends StatefulWidget {
  const Authenthication({super.key});

  @override
  State<Authenthication> createState() => _AuthenthicationState();
}

class _AuthenthicationState extends State<Authenthication> {
  ValueNotifier<bool> isSignUp = ValueNotifier<bool>(false);
  ValueNotifier<bool> isShowError = ValueNotifier<bool>(false);

  WebViewController controller = WebViewController();

  TextEditingController emailTextField = TextEditingController();
  TextEditingController passwordTextField = TextEditingController();
  TextEditingController firstNameTextField = TextEditingController();
  TextEditingController lastNameTextField = TextEditingController();

  final String _recaptchaHtml = 'assets/recaptcha.html';

  final Color _beige = const Color.fromARGB(255, 196, 137, 81);

  @override
  void initState() {
    super.initState();
  }

  void login(String token, AuthenthicationProvider provider) {
    provider
        .callLoginViaEmail(
          emailTextField.value.text,
          passwordTextField.value.text,
          token,
        )
        .then((data) {
          provider.isLoading = false;
          doAuth(
            context,
            emailTextField.value.text,
            passwordTextField.value.text,
          );
          showMessage(context, 'Login Successful');
        })
        .catchError((error) {
          provider.isLoading = false;
          print("Error: $error");
        });
  }

  InputDecoration textDecoration(String title) {
    return InputDecoration(
      hintText: "Enter your $title",
      alignLabelWithHint: false,
      floatingLabelAlignment: FloatingLabelAlignment.start,
      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: _beige)),
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: _beige)),
      fillColor: const Color.fromARGB(30, 255, 188, 130),
      filled: true,
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

  Widget _createTitle() {
    return const Text(
      "Existing Customers",
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget _createDescription() {
    return const Text("Sign in for faster checkout and order history");
  }

  Widget _createFirstNameField() {
    return ValueListenableBuilder(
      valueListenable: isSignUp,
      builder: (context, value, child) {
        if (value) {
          return _createTextFieldWithLabel(
            'First Name',
            false,
            firstNameTextField,
          );
        } else {
          return SizedBox();
        }
      },
    );
  }

  Widget _createLastNameField() {
    return ValueListenableBuilder(
      valueListenable: isSignUp,
      builder: (context, value, child) {
        if (value) {
          return _createTextFieldWithLabel(
            'Last Name',
            false,
            lastNameTextField,
          );
        } else {
          return SizedBox();
        }
      },
    );
  }

  Widget _createUsernameOrEmailField() {
    return ValueListenableBuilder(
      valueListenable: isSignUp,
      builder: (context, value, child) {
        return _createTextFieldWithLabel(
          !value ? 'Username or Email' : 'Email',
          false,
          emailTextField,
        );
      },
    );
  }

  Widget _createPasswordField() {
    return _createTextFieldWithLabel('Password', true, passwordTextField);
  }

  Widget _createTextFieldWithLabel(
    String label,
    bool obscureText,
    TextEditingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        Container(
          margin: const EdgeInsets.fromLTRB(0, 10, 0, 25),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            decoration: textDecoration(label),
          ),
        ),
      ],
    );
  }

  Widget _createErrorText() {
    return ValueListenableBuilder(
      valueListenable: isShowError,
      builder: (context, value, child) {
        if (value) {
          return const Text(
            "Fill up all fields.",
            style: TextStyle(color: Colors.red),
          );
        } else {
          return SizedBox();
        }
      },
    );
  }

  Widget _createLogInButton(BuildContext context) {
    String signInText = "Sign In";
    String signUpText = "Sign Up";
    return Consumer<AuthenthicationProvider>(
      builder: (_, provider, __) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ValueListenableBuilder(
            valueListenable: isSignUp,
            builder: (context, isSignUpValue, child) {
              return ElevatedButton(
                onPressed: () {
                  if (isSignUpValue) {
                    //TODO: Register
                  } else {
                    if (!provider.isLoading) {
                      if (emailTextField.text.isNotEmpty ||
                          passwordTextField.text.isNotEmpty) {
                        _createCaptcha(provider);
                        provider.isLoading = true;
                      } else {
                        isShowError.value = true;
                      }
                    }
                  }
                },
                style: appElevatedButtonStyle,
                child: provider.isLoading
                    ? const CircularProgressIndicator(color: Colors.black)
                    : Text(isSignUpValue ? signUpText : signInText),
              );
            },
          ),
        );
      },
    );
  }

  Widget _createBottomText() {
    return ValueListenableBuilder(
      valueListenable: isSignUp,
      builder: (context, value, child) {
        if (value) {
          return _createAlreadyHaveAnAccountText();
        } else {
          return _createDontHaveAnAccountText();
        }
      },
    );
  }

  Widget _createAlreadyHaveAnAccountText() {
    return Padding(
      padding: const EdgeInsetsGeometry.fromLTRB(0, 10, 0, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Already have an account? "),
          GestureDetector(
            child: Text(
              "Sign in",
              style: TextStyle(
                color: _beige,
                decoration: TextDecoration.underline,
                decorationColor: _beige,
              ),
            ),
            onTap: () {
              isSignUp.value = false;
            },
          ),
        ],
      ),
    );
  }

  Widget _createDontHaveAnAccountText() {
    return Padding(
      padding: const EdgeInsetsGeometry.fromLTRB(0, 10, 0, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Don't have an account? "),
          GestureDetector(
            child: Text(
              "Create one",
              style: TextStyle(
                color: _beige,
                decoration: TextDecoration.underline,
                decorationColor: _beige,
              ),
            ),
            onTap: () {
              isSignUp.value = true;
            },
          ),
        ],
      ),
    );
  }

  Future<void> _createCaptcha(AuthenthicationProvider provider) async {
    controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    controller.addJavaScriptChannel(
      'Captcha',
      onMessageReceived: (data) {
        login(data.message, provider);
        Navigator.of(context).pop();
      },
    );

    loadHtmlAsset().then((String value) {
      controller.loadHtmlString(value, baseUrl: dotenv.get("SETTINGS_ROOT"));
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
                child: WebViewWidget(controller: controller),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 231, 231, 231),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _createTitle(),
          const SizedBox(height: 30),
          _createDescription(),
          const SizedBox(height: 40),
          _createFirstNameField(),
          _createLastNameField(),
          _createUsernameOrEmailField(),
          _createPasswordField(),
          _createErrorText(),
          _createLogInButton(context),
          _createBottomText(),
        ],
      ),
    );
  }
}
