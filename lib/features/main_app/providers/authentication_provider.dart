import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_mysale/config/api_endpoints.dart';
import 'package:flutter_mysale/config/app_cache.dart';
import 'package:flutter_mysale/core/helpers/useragent_helper.dart';
import 'package:flutter_mysale/features/main_app/models/main/authentication_model.dart';

import '../../../config/app_http.dart';

class AuthenthicationProvider extends ChangeNotifier {
  BuildContext context;
  late UserAgentHelper _userAgentHelper;
  AppHttp? _http;

  bool isLoading = false;
  bool? isSuccess;

  AuthenthicationProvider({required this.context}) {
    _userAgentHelper = UserAgentHelper(context);
  }

  Future<String?> callLoginViaEmail(
    String email,
    String password,
    String token,
  ) async {
    isLoading = true;

    final userAgent = await _userAgentHelper.userAgent;
    _http ??= AppHttp(
      baseUrl: dotenv.get("SETTINGS_ROOT"),
      headers: {'User-Agent': userAgent},
    );

    LoginEmailRequest request = LoginEmailRequest(
      countryID: dotenv.get("SETTINGS_COUNTRY_ID"),
      userName: email,
      password: password,
      languageID: dotenv.get("SETTINGS_LANGUAGE_ID"),
      captchaResponse: token,
      clientID: 1,
    );

    Response res = await _http!.post(
      ApiEndpoint.loginEmail(),
      data: request.toJson(),
    );

    if (res.statusCode == 200 && res.statusCode != 429) {
      isLoading = false;

      LoginResponse response = LoginResponse.fromJson(
        jsonDecode(res.toString()),
      );

      String _loginTicket = response.d!.value!.Ticket!;

      AppCache ac = AppCache();
      ac.saveLoginTicket(_loginTicket);

      notifyListeners();
      return _loginTicket;
    }
  }
}
