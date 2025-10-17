import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_mysale/architect.dart';
import 'package:flutter_mysale/core/helpers/app_response_extension.dart';
import 'package:flutter_mysale/core/helpers/useragent_helper.dart';
import 'package:flutter_mysale/features/main_app/models/main/addresses_model.dart';
import 'package:flutter_mysale/features/main_app/models/main/cart/cart_model.dart';
import 'package:flutter_mysale/features/main_app/models/main/cart/request/add_to_cart_request_model.dart';
import 'package:flutter_mysale/features/main_app/models/main/cart/request/cart_request_model.dart';

class CheckoutProvider extends ChangeNotifier {
  Future<AppHttp> _http;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  String _languageId = '';

  String? targetItemID;

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
    p._languageId = dotenv.get("SETTINGS_LANGUAGE_ID");
    p.callCart();

    return p;
  }

  bool _responseSuccess(Response response) {
    return response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300;
  }

  Future<String?> callAddToCart({
    required String skuID,
    required int userClientType,
  }) async {
    isLoading = true;
    targetItemID = null;

    String? errorMessage;

    AppHttp http = await _http;

    AddToCartRequest request = AddToCartRequest(
      skuID: skuID,
      userClientType: userClientType,
    );

    try {
      Response res = await http.post(
        ApiEndpoint.getAddToCart(),
        data: request.toJson(),
      );

      if (_responseSuccess(res)) {
        errorMessage = null;
        await callCart(modifyLoading: false);
      } else if (res.data is String) {
        errorMessage =
            (res.data as String?) ?? 'Please select a different size';
      } else {
        errorMessage = 'Please select a different size';
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      return errorMessage;
    }
  }

  Future<String?> callIncreasePublicOrderItem(String itemID) async {
    isLoading = true;
    targetItemID = itemID;

    String? errorMessage;

    AppHttp http = await _http;

    CartRequest request = CartRequest(itemID: itemID, languageID: _languageId);
    Response res = await http.post(
      ApiEndpoint.increaseOrderItem(),
      data: request.toJson(),
    );

    if (_responseSuccess(res)) {
      final obj = res.asAppResponse<CartValue>((e) {
        return CartValue.fromJson(e as Map<String, dynamic>);
      });

      if (obj.d.result) {
        cart = obj.d.value;
        errorMessage = null;
      } else {
        errorMessage = obj.d.message;
      }
    }

    targetItemID = null;
    isLoading = false;
    return errorMessage;
  }

  Future<String?> callDecreasePublicOrderItem(String itemID) async {
    isLoading = true;
    targetItemID = itemID;

    String? errorMessage;

    AppHttp http = await _http;

    CartRequest request = CartRequest(itemID: itemID, languageID: _languageId);
    Response res = await http.post(
      ApiEndpoint.decreaseOrderItem(),
      data: request.toJson(),
    );

    if (_responseSuccess(res)) {
      final obj = res.asAppResponse<CartValue>((e) {
        return CartValue.fromJson(e as Map<String, dynamic>);
      });

      if (obj.d.result) {
        cart = obj.d.value;
        errorMessage = null;
      } else {
        errorMessage = obj.d.message;
      }
    }

    targetItemID = null;
    isLoading = false;
    return errorMessage;
  }

  Future<String?> callDeletePublicOrderItem(String itemID) async {
    isLoading = true;
    targetItemID = itemID;

    String? errorMessage;

    AppHttp http = await _http;

    CartRequest request = CartRequest(itemID: itemID, languageID: _languageId);
    Response res = await http.post(
      ApiEndpoint.deleteOrderItem(),
      data: request.toJson(),
    );

    if (_responseSuccess(res)) {
      final obj = res.asAppResponse<CartValue>((e) {
        return CartValue.fromJson(e as Map<String, dynamic>);
      });

      if (obj.d.result) {
        cart = obj.d.value;
        errorMessage = null;
      } else {
        errorMessage = obj.d.message;
      }
    }

    targetItemID = null;
    isLoading = false;
    return errorMessage;
  }

  //TODO: JCA should be called on any login
  Future<String?> callCart({bool modifyLoading = false}) async {
    if (modifyLoading) isLoading = true;
    targetItemID = null;

    String? errorMessage;

    AppHttp http = await _http;

    Response res = await http.post(
      ApiEndpoint.getCurrentOrder(),
      data: CartRequest(languageID: _languageId).toJson(),
    );

    if (_responseSuccess(res)) {
      final obj = res.asAppResponse<CartValue>((e) {
        return CartValue.fromJson(e as Map<String, dynamic>);
      });

      if (obj.d.result) {
        cart = obj.d.value;
        errorMessage = null;
      } else {
        errorMessage = obj.d.message;
      }
    }

    if (modifyLoading) isLoading = false;
    return errorMessage;
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
