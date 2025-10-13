import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_mysale/config/api_endpoints.dart';
import 'package:flutter_mysale/config/app_http.dart';
import 'package:flutter_mysale/core/helpers/useragent_helper.dart';

import '../models/model.dart';

enum CheckoutShippingMode { add, view, list, loading }

class AddressProvider extends ChangeNotifier {
  List<AddressItem> addresses = [];
  List<AddressDecoration> decorations = [];
  String addressId = "";
  bool isLoading = false;
  AddressItem? selectedAddress;
  BuildContext context;
  late UserAgentHelper _userAgentHelper;
  AppHttp? _http;

  ValueNotifier<CheckoutShippingMode> mode = ValueNotifier(
    CheckoutShippingMode.add,
  );

  AddressProvider({required this.context}) {
    _userAgentHelper = UserAgentHelper.shared;
  }

  Future<void> getAddresses() async {
    isLoading = true;
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

    mode.value = CheckoutShippingMode.loading;

    if (res.statusCode == 200 && res.statusCode != 429) {
      isLoading = false;

      final parsed = GetAddressesResponse.fromJson(res.data);

      addresses = parsed.addresses ?? [];
      decorations = parsed.addressDecorations ?? [];
      if (addresses.isNotEmpty) {
        mode.value = CheckoutShippingMode.view;
      }
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> postAddress(AddressItem newAddress) async {
    isLoading = true;
    notifyListeners();

    final userAgent = await _userAgentHelper.userAgent;
    _http ??= AppHttp(
      baseUrl: dotenv.get("SETTINGS_ROOT"),
      headers: {'User-Agent': userAgent},
    );

    Response res = await _http!.put(
      ApiEndpoint.setUserDeliveryAddress(),
      data: newAddress.toJson(),
    );

    if (res.statusCode == 200 && res.statusCode != 429) {
      addressId = "$res";
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> applyAddress(ApplyAddressRequest request) async {
    isLoading = true;
    notifyListeners();

    final userAgent = await _userAgentHelper.userAgent;
    _http ??= AppHttp(
      baseUrl: dotenv.get("SETTINGS_ROOT"),
      headers: {'User-Agent': userAgent},
    );

    Response res = await _http!.post(
      ApiEndpoint.applyDeliveryAddress(),
      data: request.toJson(),
    );

    mode.value = CheckoutShippingMode.loading;

    if (res.statusCode == 200 && res.statusCode != 429) {
      isLoading = false;
      notifyListeners();
    }
  }

  void selectAddress(AddressItem addr) {
    selectedAddress = addr;
    notifyListeners();
  }
}
