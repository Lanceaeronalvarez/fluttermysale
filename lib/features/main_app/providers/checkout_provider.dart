import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_mysale/architect.dart';
import 'package:flutter_mysale/core/helpers/app_response_extension.dart';
import 'package:flutter_mysale/core/helpers/useragent_helper.dart';
import 'package:flutter_mysale/features/main_app/models/main/addresses_model.dart';
import 'package:flutter_mysale/features/main_app/models/main/cart/cart_model.dart';

class CheckoutProvider extends ChangeNotifier {
  Future<AppHttp> _http;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  CartValue? cart;

  CheckoutProvider._(this._http);
  factory CheckoutProvider() {
    Future<AppHttp> _createHttp() async {
      String userAgent = await UserAgentHelper.shared.userAgent;
      return AppHttp(
        baseUrl: dotenv.get('SETTINGS_ROOT'),
        headers: {'User_agent': userAgent},
      );
    }

    final p = CheckoutProvider._(_createHttp());

    p.callCart();

    return p;
  }

  //TODO: JCA should be called on any login
  Future<CartValue?> callCart() async {
    isLoading = true;

    AppHttp http = await _http;

    //TODO: JCA hardcoded params
    dynamic data = {
      "deliveryDetails": {"PickupPoint": null, "Postcode": null},
      "imageSize": 100,
      "languageID": "EN",
    };
    Response res = await http.post(ApiEndpoint.getCurrentOrder(), data: data);

    if (res.statusCode == 200) {
      final obj = res.asAppResponse<CartValue>((e) {
        return CartValue.fromJson(e as Map<String, dynamic>);
      });

      cart = obj.d.value;
    }

    isLoading = false;
    return cart;
  }

  Future<(bool, String)> applyAddress(String addressId) async {
    isLoading = true;
    String message = 'Something went wrong!';
    bool isSuccessful = false;
    notifyListeners();

    AppHttp http = await _http;

    ApplyAddressRequest _request = ApplyAddressRequest(
      countryID: dotenv.get("SETTINGS_COUNTRY_ID"),
      languageID: dotenv.get("SETTINGS_LANGUAGE_ID"),
      imageSize: "100",
      deliveryAddressID: addressId,
    );

    Response res = await http.post(
      ApiEndpoint.applyDeliveryAddress(),
      data: _request.toJson(),
    );

    if (res.statusCode == 200) {
      isSuccessful = true;
      final obj = res.asAppResponse<CartValue>((e) {
        return CartValue.fromJson(e as Map<String, dynamic>);
      });
      cart = obj.d.value;
    } else {
      final map = Map<String, dynamic>.from(res.data);
      message = (map['Message'] as String?) ?? "";
    }

    isLoading = false;
    return (isSuccessful, message);
  }

  //TODO: JCA should be called on logout
  void clearSession() {
    cart = null;
  }
}
