import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_mysale/core/helpers/style_helper.dart';
import 'package:flutter_mysale/core/widgets/toast_message.dart';
import 'package:flutter_mysale/features/main_app/providers/authentication_provider.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AuthenthicationWidget extends StatefulWidget {
  const AuthenthicationWidget({super.key});

  @override
  State<AuthenthicationWidget> createState() => _AuthenthicationWidgetState();
}

class _AuthenthicationWidgetState extends State<AuthenthicationWidget> {
  bool isSignUp = false;
  bool isShowError = false;

  WebViewController controller = WebViewController();

  TextEditingController emailTextField = TextEditingController();
  TextEditingController passwordTextField = TextEditingController();
  TextEditingController firstNameTextField = TextEditingController();
  TextEditingController lastNameTextField = TextEditingController();

  late AuthenthicationProvider provider;

  final Color _beige = const Color.fromARGB(255, 196, 137, 81);

  @override
  void initState() {
    super.initState();
  }

  void login(String token) {
    provider
        .callLoginViaEmail(
          emailTextField.value.text,
          passwordTextField.value.text,
          token,
        )
        .then((data) {
          showMessage(context, 'Login Successful');
        })
        .catchError((error) {
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
    String captcha = await rootBundle.loadString('assets/recaptcha.html');
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
    return _createTextFieldWithLabel('First Name', false, firstNameTextField);
  }

  Widget _createLastNameField() {
    return _createTextFieldWithLabel('Last Name', false, lastNameTextField);
  }

  Widget _createUsernameOrEmailField() {
    return _createTextFieldWithLabel(
      !isSignUp ? 'Username or Email' : 'Email',
      false,
      emailTextField,
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
    return const Text(
      "Fill up all fields.",
      style: TextStyle(color: Colors.red),
    );
  }

  Widget _createLogInButton(BuildContext context) {
    String text = "Sign In";
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: () {
          if (emailTextField.text.isNotEmpty ||
              emailTextField.text != "" && passwordTextField.text.isNotEmpty ||
              passwordTextField.text != "") {
            _createCaptcha();
          } else {
            setState(() {
              isShowError = true;
            });
          }
        },
        style: appElevatedButtonStyle,
        child: Text(text),
      ),
    );
  }

  Widget _createSignInButton() {
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
              setState(() {
                isSignUp = false;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _createSignUpButton() {
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
              setState(() {
                isSignUp = true;
              });
            },
          ),
        ],
      ),
    );
  }

  Future<void> _createCaptcha() async {
    controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    controller.addJavaScriptChannel(
      'Captcha',
      onMessageReceived: (data) {
        login(data.message);
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
                  onPressed: () => Navigator.pop(context),
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
    provider = Provider.of<AuthenthicationProvider>(context, listen: false);

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
          isSignUp ? _createFirstNameField() : const SizedBox(),
          isSignUp ? _createLastNameField() : const SizedBox(),
          _createUsernameOrEmailField(),
          _createPasswordField(),
          isShowError ? _createErrorText() : SizedBox(),
          _createLogInButton(context),
          !isSignUp ? _createSignUpButton() : _createSignInButton(),
        ],
      ),
    );
  }
}
