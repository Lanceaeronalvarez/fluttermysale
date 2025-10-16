import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_mysale/config/api_endpoints.dart';
import 'package:flutter_mysale/config/app_http.dart';
import 'package:flutter_mysale/core/helpers/useragent_helper.dart';

import '../models/model.dart';

class AddressProvider extends ChangeNotifier {
  List<AddressItem> addresses = [];
  List<AddressDecoration> decorations = [];
  String addressId = "";
  bool isLoading = false;
  AddressItem? selectedAddress;
  BuildContext context;
  late UserAgentHelper _userAgentHelper;
  AppHttp? _http;

  AddressProvider({required this.context}) {
    _userAgentHelper = UserAgentHelper.shared;
  }

  Future<(bool, String)> getAddresses() async {
    isLoading = true;
    String message = '';
    bool isSuccessful = false;
    notifyListeners();

    final userAgent = await _userAgentHelper.userAgent;
    _http ??= AppHttp(
      baseUrl: dotenv.get("SETTINGS_ROOT"),
      headers: {'User-Agent': userAgent},
    );

    Response res = await _http!.post(
      ApiEndpoint.getUserAddresses(),
      data: {'languageID': dotenv.get("SETTINGS_LANGUAGE_ID")},
    );

    if (res.statusCode == 200) {
      isLoading = false;

      final parsed = GetAddressesResponse.fromJson(res.data);

      addresses = parsed.addresses ?? [];
      decorations = parsed.addressDecorations ?? [];
      isLoading = false;
      isSuccessful = true;
      notifyListeners();
    }
    return (isSuccessful, message);
  }

  Future<(bool, String)> postAddress(
    Map<String, TextEditingController> controllers,
    String dropdownValue,
  ) async {
    isLoading = true;
    String message = '';
    bool isSuccessful = false;
    notifyListeners();

    Map<String, dynamic> myAddress = {};

    for (final decor in decorations) {
      final key = decor.name?.toLowerCase();
      if (key != null && key.isNotEmpty) {
        if (key == "addresslines") {
          myAddress["address_lines"] = controllers[key]?.text;
        } else if (key == "state") {
          myAddress[key] = dropdownValue;
        } else {
          myAddress[key] = controllers[key]?.text;
        }
      }
    }

    final userAgent = await _userAgentHelper.userAgent;
    _http ??= AppHttp(
      baseUrl: dotenv.get("SETTINGS_ROOT"),
      headers: {'User-Agent': userAgent},
    );

    Response res = await _http!.put(
      ApiEndpoint.setUserDeliveryAddress(),
      data: jsonEncode(myAddress),
    );

    if (res.statusCode == 200) {
      addressId = "$res";
      isLoading = false;
      isSuccessful = true;
    } else {
      final map = Map<String, dynamic>.from(res.data);
      message = (map['detail'] as String?) ?? "";
    }
    isLoading = false;
    notifyListeners();
    return (isSuccessful, message);
  }

  void selectAddress(AddressItem addr) {
    selectedAddress = addr;
    notifyListeners();
  }
}
