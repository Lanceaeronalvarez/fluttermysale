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

    // await Future.delayed(const Duration(seconds: 1));

    // // Mock API response TODO: jai - Replace with real API call
    // final responseJson = {
    //   "addresses": [
    //     {
    //       "id": "1a387cc34641452a8b01ccd7c6801704",
    //       "name": "jai hh",
    //       "forename": "jai",
    //       "surname": "hh",
    //       "address_lines": "mac",
    //       "suburb": "parr",
    //       "state": "NSW",
    //       "postcode": "1111",
    //       "phone": "+617555",
    //     },
    //     {
    //       "id": "be5e249325c74553ab1cc7a2cce7e900",
    //       "name": "jj hyh jk",
    //       "forename": "jj hyh",
    //       "surname": "jk",
    //       "address_lines": "jk",
    //       "suburb": "jj",
    //       "state": "NSW",
    //       "postcode": "5555",
    //       "phone": "+619877",
    //     },
    //     {
    //       "id": "e77cd4e8a0c848ceb42e8c9a66d06822",
    //       "name": "jj jl",
    //       "forename": "jj",
    //       "surname": "jl",
    //       "address_lines": "jj",
    //       "suburb": "ooo",
    //       "state": "NSW",
    //       "postcode": "8889",
    //       "phone": "+618777",
    //     },
    //   ],
    //   "address_decorations": [
    //     {
    //       "label": "Recipient's first name",
    //       "name": "Forename",
    //       "type": "text",
    //       "class": "field",
    //       "value": "Jai",
    //       "max_length": 50,
    //       "min_length": 2,
    //       "validate": "*",
    //       "read_only": false,
    //       "without_comma": false,
    //       "regexp": "^[A-Za-z]+(?:\\s[A-Za-z]+)*\$",
    //       "validate_consistency": false,
    //     },
    //     {
    //       "label": "Recipient's last name",
    //       "name": "Surname",
    //       "type": "text",
    //       "class": "field",
    //       "value": "Milyy",
    //       "max_length": 50,
    //       "min_length": 2,
    //       "validate": "*",
    //       "read_only": false,
    //       "without_comma": false,
    //       "regexp": "^[A-Za-z]+(?:\\s[A-Za-z]+)*\$",
    //       "validate_consistency": false,
    //     },
    //     {
    //       "label": "Address",
    //       "name": "AddressLines",
    //       "type": "text",
    //       "class": "field",
    //       "max_length": 200,
    //       "validate": "*",
    //       "read_only": false,
    //       "without_comma": false,
    //       "validate_consistency": true,
    //     },
    //     {
    //       "label": "Suburb",
    //       "name": "Suburb",
    //       "type": "text",
    //       "class": "field",
    //       "max_length": 100,
    //       "validate": "*",
    //       "read_only": false,
    //       "without_comma": true,
    //       "validate_consistency": true,
    //     },
    //     {
    //       "label": "State",
    //       "name": "State",
    //       "type": "select",
    //       "class": "field",
    //       "max_length": 100,
    //       "validate": "*",
    //       "read_only": false,
    //       "without_comma": false,
    //       "options": ["NSW", "ACT", "WA", "SA", "VIC", "QLD", "NT", "TAS"],
    //       "validate_consistency": true,
    //     },
    //     {
    //       "label": "Postcode",
    //       "name": "Postcode",
    //       "type": "numeric",
    //       "data_type": "Postcode",
    //       "class": "field",
    //       "max_length": 4,
    //       "min_length": 4,
    //       "validate": "*",
    //       "read_only": false,
    //       "without_comma": false,
    //       "regexp": "^\\d*\$",
    //       "validate_consistency": true,
    //     },
    //     {
    //       "label": "Phone",
    //       "name": "Phone",
    //       "type": "text",
    //       "data_type": "Phone",
    //       "class": "field",
    //       "max_length": 30,
    //       "validate": "*",
    //       "read_only": false,
    //       "without_comma": false,
    //       "regexp":
    //           "^(\\+|\\+\\d|\\d)(-)?(\\(|\\(\\d+|\\(\\d+\\)|\\d+)?(-)?(\\d+|\\d+-||\\d+-\\d+)*(\\d+)?\$",
    //       "validate_consistency": true,
    //     },
    //   ],
    // };

    // final parsed = GetAddressesResponse.fromJson(responseJson);

    // addresses = parsed.addresses ?? [];
    // decorations = parsed.addressDecorations ?? [];

    // isLoading = false;
    // notifyListeners();
  }

  Future<void> postAddress(String jsonEncode) async {
    isLoading = true;
    notifyListeners();

    final userAgent = await _userAgentHelper.userAgent;
    _http ??= AppHttp(
      baseUrl: dotenv.get("SETTINGS_ROOT"),
      headers: {'User-Agent': userAgent},
    );

    Response res = await _http!.put(
      ApiEndpoint.setUserDeliveryAddress(),
      data: jsonEncode,
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
