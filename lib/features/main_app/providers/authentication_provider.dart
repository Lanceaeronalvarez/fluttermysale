import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_mysale/config/api_endpoints.dart';
import 'package:flutter_mysale/config/app_cache.dart';
import 'package:flutter_mysale/core/helpers/useragent_helper.dart';
import 'package:flutter_mysale/features/main_app/models/main/authentication_model.dart';
import 'package:flutter_mysale/features/main_app/models/main/user_model.dart';

import '../../../config/app_http.dart';

class AuthenthicationProvider extends ChangeNotifier {
  Future<AppHttp> _http;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  AuthenthicationProvider._(this._http);
  factory AuthenthicationProvider() {
    Future<AppHttp> _createHttp() async {
      String userAgent = await UserAgentHelper.shared.userAgent;
      return AppHttp(
        baseUrl: dotenv.get("SETTINGS_ROOT"),
        headers: {'User-Agent': userAgent},
      );
    }

    final p = AuthenthicationProvider._(_createHttp());

    AppCache().loginTicket.then((loginTicket) {
      if (loginTicket != null && loginTicket.isNotEmpty) {
        p.callLoginTicket();
      } else {
        debugPrint('no login ticket');
      }
    });

    return p;
  }

  Future<void> _saveLoginTicket(AppCache ac, String? loginTicket) async {
    await ac.setLoginTicket(loginTicket);
  }

  Future<void> _saveUser(AppCache ac, User? user) async {
    await ac.setUser(user);
  }

  Future<void> callUserDetails() async {
    isLoading = true;

    AppHttp http = await _http;
    Response res = await http.post(ApiEndpoint.loadUserDetails(), data: {});

    if (res.statusCode == 200) {
      User user = User.fromJson(jsonDecode(res.toString()));
      await _saveUser(AppCache(), user);
    }

    isLoading = false;
  }

  Future<void> callLogout() async {
    isLoading = true;

    AppHttp http = await _http;
    Response res = await http.post(ApiEndpoint.logout(), data: {});

    if (res.statusCode == 200) {
      final ac = AppCache();
      await _saveLoginTicket(ac, null);
      await _saveUser(ac, null);
    }

    isLoading = false;
  }

  Future<String?> callLoginTicket() async {
    isLoading = true;

    AppCache ac = AppCache();
    String loginTicket = await ac.loginTicket ?? '';

    AppHttp http = await _http;

    Map<String, String> request = {
      'ticket': loginTicket,
      'countryID': dotenv.get("SETTINGS_COUNTRY_ID"),
    };

    Response res = await http.post(ApiEndpoint.loginTicket(), data: request);

    if (res.statusCode == 200) {
      LoginResponse response = LoginResponse.fromJson(
        jsonDecode(res.toString()),
      );

      String? loginTicket = response.d?.value?.Ticket;
      await _saveLoginTicket(ac, loginTicket);

      await _postLogin();
    }

    isLoading = false;
    return ac.loginTicket;
  }

  Future<(bool, String)> callLoginViaEmail(
    String email,
    String password,
    String token,
  ) async {
    isLoading = true;

    AppCache ac = AppCache();
    String message = '';
    bool isSuccessful = false;

    LoginEmailRequest request = LoginEmailRequest(
      countryID: dotenv.get("SETTINGS_COUNTRY_ID"),
      userName: email,
      password: password,
      languageID: dotenv.get("SETTINGS_LANGUAGE_ID"),
      captchaResponse: token,
      clientID: 1,
    );

    AppHttp http = await _http;
    Response res = await http.post(
      ApiEndpoint.loginEmail(),
      data: request.toJson(),
    );

    if (res.statusCode == 200) {
      isLoading = false;

      LoginResponse response = LoginResponse.fromJson(
        jsonDecode(res.toString()),
      );

      bool isAuthenticated = response.d?.isAuthenticated ?? false;
      bool result = response.d?.result ?? false;
      message = response.d?.message ?? '';
      if (isAuthenticated && result) {
        String? loginTicket = response.d?.value?.Ticket;
        await _saveLoginTicket(ac, loginTicket);
        isSuccessful = true;

        await _postLogin();
      }
    }

    isLoading = false;
    return (isSuccessful, message);
  }

  Future<(bool, String)> callRegistration(
    String firstname,
    String lastname,
    String email,
    String password,
    String token,
    bool tcAccepted,
    bool emailsAccepted,
  ) async {
    isLoading = true;
    bool isSuccessful = true;
    String message = '';

    AppCache ac = AppCache();

    Map<String, bool> parameters = {
      "tcAccepted": tcAccepted,
      "emailsAccepted": emailsAccepted,
    };

    RegisterRequest request = RegisterRequest(
      languageID: dotenv.get("SETTINGS_LANGUAGE_ID"),
      countryID: dotenv.get("SETTINGS_COUNTRY_ID"),
      email: email,
      password: password,
      foreName: firstname,
      surName: lastname,
      captchaResponse: token,
      clientType: 1,
      clientID: 1,
      parameters: parameters,
      referredBy: "android",
      invitedBy: "",
      voucherID: "00000000-0000-0000-0000-000000000000",
    );

    AppHttp http = await _http;
    Response res = await http.post(
      ApiEndpoint.registration(),
      data: request.toJson(),
    );

    if (res.statusCode == 200) {
      LoginResponse response = LoginResponse.fromJson(
        jsonDecode(res.toString()),
      );

      bool isAuthenticated = response.d?.isAuthenticated ?? false;
      bool result = response.d?.result ?? false;
      message = response.d?.message ?? '';
      if (isAuthenticated && result) {
        String? loginTicket = response.d?.value?.Ticket;
        await _saveLoginTicket(ac, loginTicket);
        isSuccessful = true;

        await _postLogin();
      }
    }

    isLoading = false;
    return (isSuccessful, message);
  }

  Future<void> _postLogin() async {
    final u = await AppCache().user;
    if (u == null) {
      await callUserDetails();
    }
  }

  Future<bool> isLoggedIn() async {
    final ac = AppCache();
    final loginTicket = await ac.loginTicket;
    final user = await ac.user;
    return (loginTicket != null &&
        loginTicket.isNotEmpty &&
        user != null &&
        user.id.isNotEmpty);
  }
}
