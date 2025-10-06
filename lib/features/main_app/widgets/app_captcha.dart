import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AppCaptcha extends StatefulWidget {
  final Function(String) onMessageReceived;

  AppCaptcha({required this.onMessageReceived});

  @override
  State<StatefulWidget> createState() {
    return _AppCatchState();
  }

  static void showCaptcha({
    required BuildContext parentContext,
    required Function(String) onMessageReceived,
    required VoidCallback onClose,
  }) {
    showModalBottomSheet(
      isDismissible: false,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      context: parentContext,
      builder: (ctx) {
        return SizedBox(
          height: 700,
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close, weight: 20),
                  onPressed: () {
                    onClose.call();
                  },
                ),
              ),
              SizedBox(
                height: 600,
                child: AppCaptcha(onMessageReceived: onMessageReceived),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AppCatchState extends State<AppCaptcha> {
  //TODO: JCA move in a config file
  final String _recaptchaHtml = 'assets/recaptcha.html';
  final String _captchaSiteKey = 'CAPTCHA_SITE_KEY';
  final String _appRecaptchaSiteKey = 'FLAVOR_RECAPTCHA_SITE_KEY';
  final String _settingsRoot = 'SETTINGS_ROOT';
  WebViewController _webController = WebViewController();

  @override
  void initState() {
    super.initState();

    _webController.setJavaScriptMode(JavaScriptMode.unrestricted);
    _webController.addJavaScriptChannel(
      'Captcha',
      onMessageReceived: (data) {
        widget.onMessageReceived.call(data.message);
      },
    );

    loadHtmlAsset().then((String value) {});
  }

  Future<String> loadHtmlAsset() async {
    String captcha = await rootBundle.loadString(_recaptchaHtml);
    captcha = captcha.replaceAll(
      _captchaSiteKey,
      "'${dotenv.get(_appRecaptchaSiteKey)}'",
    );
    return captcha;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: loadHtmlAsset(),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            _webController.loadHtmlString(
              snapshot.data ?? '',
              baseUrl: dotenv.get(_settingsRoot),
            );
            return SizedBox(
              height: 600,
              child: WebViewWidget(controller: _webController),
            );
          }
        } else {
          return Center(child: CircularProgressIndicator(color: Colors.black));
        }
      },
    );
  }
}
