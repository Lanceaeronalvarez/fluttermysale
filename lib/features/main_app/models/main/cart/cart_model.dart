import 'package:flutter_mysale/features/main_app/models/main/cart/cart_afterpay_model.dart';
import 'package:flutter_mysale/features/main_app/models/main/cart/cart_available_payment_option_model.dart';
import 'package:flutter_mysale/features/main_app/models/main/cart/cart_decoration_info_model.dart';
import 'package:flutter_mysale/features/main_app/models/main/cart/cart_delivery_address_model.dart';
import 'package:flutter_mysale/features/main_app/models/main/cart/cart_delivery_option_model.dart';
import 'package:flutter_mysale/features/main_app/models/main/cart/cart_delivery_service_package_detail_model.dart';
import 'package:flutter_mysale/features/main_app/models/main/cart/cart_item_model.dart';
import 'package:flutter_mysale/features/main_app/models/main/cart/cart_phone_verification_model.dart';
import 'package:flutter_mysale/features/main_app/models/main/cart/cart_promo_code_model.dart';
import 'package:flutter_mysale/features/main_app/models/main/cart/cart_summary_model.dart';
import 'package:flutter_mysale/features/main_app/models/main/cart/cart_voucher_model.dart';
import 'package:json_annotation/json_annotation.dart';

import 'cart_shipment_model.dart';

part 'cart_model.g.dart';

@JsonSerializable()
class CartValue {
  @JsonKey(name: 'IsEmpty', defaultValue: false)
  final bool isEmpty;

  @JsonKey(name: 'ItemsCount', defaultValue: 0)
  final int itemsCount;

  @JsonKey(name: 'IsAgeRestricted', defaultValue: false)
  final bool isAgeRestricted;

  @JsonKey(name: 'ThreeDSecureRequired', defaultValue: false)
  final bool threeDSecureRequired;

  @JsonKey(name: 'Shipments')
  final List<CartShipment>? shipments;

  @JsonKey(name: 'Summary')
  final CartSummary? summary;

  @JsonKey(name: 'DeliveryAddress')
  final CartDeliveryAddress? deliveryAddress;

  @JsonKey(name: 'DeliveryOptions')
  final List<CartDeliveryOption>? deliveryOptions;

  @JsonKey(name: 'DeliveryServicePackageDetail')
  final CartDeliveryServicePackageDetail? deliverySerivePackageDetail;

  @JsonKey(name: 'AvailablePaymentOptions')
  final List<CartAvailablePaymentOption>? availablePaymentOptions;

  @JsonKey(name: 'Afterpay')
  final CartAfterpay? afterpay;

  @JsonKey(name: 'DecorationInfoList')
  final List<CartDecorationInfo>? decorationInfoList;

  @JsonKey(name: 'Vouchers')
  final List<CartVoucher>? vouchers;

  @JsonKey(name: 'PromoCodeList')
  final List<CartPromoCode>? promoCodeList;

  @JsonKey(name: 'VoucherID')
  final String? appliedVoucherId;

  @JsonKey(name: 'PhoneVerification')
  final CartPhoneVerification? phoneVerification;

  CartValue({
    this.isEmpty = false,
    this.itemsCount = 0,
    this.isAgeRestricted = false,
    this.threeDSecureRequired = false,
    this.shipments,
    this.summary,
    this.deliveryAddress,
    this.deliveryOptions,
    this.deliverySerivePackageDetail,
    this.availablePaymentOptions,
    this.afterpay,
    this.decorationInfoList,
    this.vouchers,
    this.promoCodeList,
    this.appliedVoucherId,
    this.phoneVerification,
  });

  factory CartValue.fromJson(Map<String, dynamic> json) {
    final normalized = _expandShipmentItems(json);
    return _$CartValueFromJson(normalized);
  }

  Map<String, dynamic> toJson() => _$CartValueToJson(this);
}

// transform content of Value.Shipments[].Items to Object(retrieved from Value.Items
Map<String, dynamic> _expandShipmentItems(Map<String, dynamic> json) {

  String kShipments = 'Shipments';
  String kItems = 'Items';
  String kID = 'ID';

  final value = Map<String, dynamic>.from(json);

  final shipmentsRaw = (value[kShipments] as List?)?.cast<Map<String, dynamic>>() ?? const [];
  final shipments = <Map<String, dynamic>>[
    for (final s in shipmentsRaw) Map<String, dynamic>.from(s),
  ];

  final itemsList =
      (value[kItems] as List?)?.cast<Map<String, dynamic>>() ?? const [];
  final Map<String, Map<String, dynamic>> byId = {};
  for (final item in itemsList) {
    final id = item[kID];
    if (id is String && id.isNotEmpty) {
      byId[id] = item;
    }
  }

  final transformed = <Map<String, dynamic>>[];
  for (final s in shipments) {
    final raw = s[kItems];
    if (raw is List && raw.isNotEmpty && raw.first is String && byId.isNotEmpty) {
      final ids = raw.cast<String>();
      s[kItems] = [
        for (final id in ids)
          if (byId.containsKey(id)) byId[id]!,
      ];
    }
    transformed.add(s);
  }

  value[kShipments] = transformed;
  value.remove('items');
  return value;
}
