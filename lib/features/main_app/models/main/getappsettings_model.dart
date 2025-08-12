import 'dart:convert';

import 'package:flutter/foundation.dart';

class GetAppSettingsModel {
  ResponseD? d;

  // factory GetAppSettingsModel.fromJson(String source) =>
  //     GetAppSettingsModel.fromMap(json.decode(source));
}

class ResponseD {
  Value? value;
}

class Value {
  Checkout? checkout;
  // MyAccount? myAccount;
  // Payments? payments;
  // Search? search;
  // Shop? shop;
  // Access? access;
  // ProductPage? productPage;
}

class Checkout {
  int? appView;
  int? siteView;
  String? roktID;
  String? pickupPointsServiceID;
  TermsAndConditions? termsAndConditions;
  bool? showAuthToLeave;
  bool? addressSuggestionEnabled;
  String? pcaID;
  bool? phoneVerificationEnabled;
  bool? shippingByPostcodeEnabled;
}

class TermsAndConditions {
  int? mode;
}