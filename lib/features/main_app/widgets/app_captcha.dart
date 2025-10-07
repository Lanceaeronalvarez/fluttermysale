import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

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
      enableDrag: false,
      useSafeArea: true,
      context: parentContext,
      builder: (ctx) {
        return Column(
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
            Expanded(child: AppCaptcha(onMessageReceived: onMessageReceived)),
          ],
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

  InAppWebViewController? _webController;
  late final Future<String> _htmlFuture;

  @override
  void initState() {
    super.initState();
    _htmlFuture = loadHtmlAsset();

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
      future: _htmlFuture,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return _createWebview(snapshot.data ?? '');
          }
        } else {
          return Center(child: CircularProgressIndicator(color: Colors.black));
        }

      },
    );
  }
  

  Widget _createWebview(String htmlString) {

    String baseUrl = dotenv.get(_settingsRoot);

    return InAppWebView(
      initialSettings: InAppWebViewSettings(
        incognito: true, //need to set to true for iPad iOS, having issues with persistence/cookies
        javaScriptEnabled: true,
      ),

      onWebViewCreated: (controller) async {
        _webController = controller;

        controller.addWebMessageListener(
          WebMessageListener(
            jsObjectName: "Captcha",
            allowedOriginRules: { '*' },
            onPostMessage: (message, sourceOrigin, isMainFrame, replyProxy) {
              final data = message?.data;
              if (data is String && data.isNotEmpty) {
                widget.onMessageReceived(data);
              }
            },
          ),
        );

        await controller.loadData(
          data: htmlString,
          baseUrl: WebUri(baseUrl),
          mimeType: 'text/html',
          encoding: 'utf-8',
          historyUrl: WebUri(baseUrl),
        );
      },
    );
  }

}
