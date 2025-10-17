import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_mysale/config/api_endpoints.dart';
import 'package:flutter_mysale/config/app_http.dart';
import 'package:flutter_mysale/core/helpers/useragent_helper.dart';
import 'package:flutter_mysale/features/main_app/models/main/productdetail_model.dart';
import 'package:flutter_mysale/features/main_app/models/main/productitem_model.dart';

class PaymentKeys {
  static const afterpay = 'Afterpay';
  static const enabled = 'Enabled';
  static const d = 'd';
  static const value = 'Value';
  static const payments = 'Payments';
}

class ProductDetailProvider extends ChangeNotifier {
  final BuildContext context;
  late final UserAgentHelper _userAgentHelper;
  AppHttp? _http;

  bool isLoading = false;
  String? error;

  ProductDetail? product;
  bool isAfterpayEnabled = false;

  ProductDetailProvider({required this.context}) {
    _userAgentHelper = UserAgentHelper.shared;
  }

  void preloadData(ProductItem item) {
    product = ProductDetailMapper.fromProductItem(item);
    notifyListeners();
  }

  Future<void> getProductDetail({
    required String seoIdentifier,
    String? saleId,
    bool includeSkuVariants = true,
    void Function(ProductDetail?)? completion,
  }) async {
    if (isLoading) return;

    error = null;
    if (product == null) {
      isLoading = true;
      notifyListeners();
    }

    try {
      final userAgent = await _userAgentHelper.userAgent;
      _http ??= AppHttp(
        baseUrl: dotenv.get("SETTINGS_ROOT"),
        headers: {'User-Agent': userAgent},
      );

      final result = await _fetchProductDetail(
        seoIdentifier: seoIdentifier,
        saleId: saleId,
        includeSkuVariants: includeSkuVariants,
      );

      final paymentMethods = await _fetchPaymentMethods();

      isAfterpayEnabled = paymentMethods[PaymentKeys.afterpay] ?? false;

      product = result;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      completion?.call(product);
      notifyListeners();
    }
  }

  Future<ProductDetail?> _fetchProductDetail({
    required String seoIdentifier,
    String? saleId,
    bool includeSkuVariants = true,
  }) async {
    String url;
    if (saleId != null && saleId.isNotEmpty) {
      url = includeSkuVariants
          ? ApiEndpoint.getProductDetailsWithSales()
                .replaceAll("{sale_id}", saleId)
                .replaceAll("{seo_identifier}", seoIdentifier)
          : ApiEndpoint.getProductDetailsWithSalesNoSkuVariants()
                .replaceAll("{sale_id}", saleId)
                .replaceAll("{seo_identifier}", seoIdentifier);
    } else {
      url = includeSkuVariants
          ? ApiEndpoint.getProductDetailsWithoutSales().replaceAll(
              "{seo_identifier}",
              seoIdentifier,
            )
          : ApiEndpoint.getProductDetailsWithoutSalesNoSkuVariants().replaceAll(
              "{seo_identifier}",
              seoIdentifier,
            );
    }

    final response = await _http!.get(url);
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch product: ${response.statusCode}');
    }

    final data = jsonDecode(json.encode(response.data)) as Map<String, dynamic>;
    return ProductDetail.fromJson(data);
  }

  Future<Map<String, bool>> _fetchPaymentMethods() async {
    final response = await _http!.get(
      ApiEndpoint.getPublicAppSettings(),
      params: {'countryID': dotenv.get("SETTINGS_COUNTRY_ID")},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch payment settings');
    }

    final map = Map<String, dynamic>.from(response.data);
    final payments =
        map[PaymentKeys.d]?[PaymentKeys.value]?[PaymentKeys.payments] ?? {};

    return {
      PaymentKeys.afterpay.toLowerCase():
          payments[PaymentKeys.afterpay]?[PaymentKeys.enabled] ?? false,
    };
  }
}
