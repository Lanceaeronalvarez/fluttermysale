import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../features/features.dart';

/// In this file we will be writing all API Endpoints using this application

class ApiEndpoint {
  // News Server
  static const rapidUrl = 'https://free-news.p.rapidapi.com';
  static const news = '$rapidUrl/v1/search';

  // Server Links
  static const baseUrl = 'https://apps.shibajidebnath.com/';
  static const api = '${baseUrl}api/';

  // Enqueries Endpoints
  static const enqueries = '${api}enqueries?populate=*&sort[0]=id%3Adesc';
  static const enquery = '${api}enqueries';

  // Apps Internals Links
  static const appLoginUrl = AuthApp.login;
  static const appRegiaterUrl = AuthApp.register;
  static const appForgetUrl = AuthApp.forget;
  static const appProfileUrl = AuthApp.profile;

  //Mysale below

  static const _noAkamaiExtension = 'api.asmx/';
  static const _akamaiExtension = 'api.ashx/';
  static String _root = dotenv.get("SETTINGS_ROOT");

  static const _legacyApiVersion = '3.31';

  static const _handlerPrefix = 'handler.ashx/';

  static const _accountIdDelimiter = '_ACCOUNT_ID_DELIMETER_';

  static const int _serviceShop = 0;
  static const int _serviceSale = 1;
  static const int _serviceProduct = 2;
  static const int _serviceWishlist = 3;
  static const int _serviceSetting = 4;
  static const int _serviceEventing = 5;
  static const int _serviceRecently = 6;
  static const int _serviceAttachments = 7;
  static const int _serviceCustomer = 8;
  static const int _serviceLegacy = 9;
  static const int _serviceGenie = 10;
  static const int _serviceMyAccount = 11;

  static const _emptyVersion = '';
  static const _v1 = 'v1';
  static const _v2 = 'v2';
  static const _v3 = 'v3';
  static const _v4 = 'v4';
  static const _v5 = 'v5';

  static String _getFormattedUrl(int service, String url, String version) {
    String microServiceUrl = "";
    switch (service) {
      case _serviceShop:
        microServiceUrl = "api/shop/shop/" + version + "/accounts/";
        break;
      case _serviceSale:
        microServiceUrl = "api/sale/sale/" + version + "/accounts/";
        break;
      case _serviceProduct:
        microServiceUrl = "api/shop/product/" + version + "/accounts/";
        break;
      case _serviceWishlist:
        microServiceUrl = "api/shop/shop/" + version + "/wishlist/";
        break;
      case _serviceSetting:
        microServiceUrl = "api/shop/settings/" + version + "/";
        break;
      case _serviceEventing:
        microServiceUrl = "api/shop/EVENTING/" + version + "/";
        break;
      case _serviceRecently:
        microServiceUrl = "api/shop/shop/" + version + "/recently/";
        break;
      case _serviceAttachments:
        microServiceUrl = "api/shop/files/" + version + "/files/";
        break;
      case _serviceCustomer:
        microServiceUrl = "api/shop/customer/" + version + "/customer/";
        break;
      case _serviceLegacy:
        microServiceUrl = "papi/public/v" + _legacyApiVersion + "/";
        break;
      case _serviceGenie:
        microServiceUrl = _handlerPrefix;
        break;
      case _serviceMyAccount:
        microServiceUrl = "api/shop/myaccount/" + version + "/accounts/";
        break;
    }

    return _root + microServiceUrl + _processUrlString(url);
  }

  static String _processUrlString(String url) {
    String newUrlString = url;
    Map<String, String> replaceStrings = Map();
    replaceStrings[_accountIdDelimiter] = dotenv.get("SETTINGS_ACCOUNT_ID");

    replaceStrings.forEach((key, value) {
      newUrlString = newUrlString.replaceFirst(key, value);
    });
    return newUrlString;
  }

  static String getCategoryTree() {
    return _getFormattedUrl(
      _serviceShop,
      _accountIdDelimiter + "/categorytree",
      _v5,
    );
  }

  static String getTopBrands() {
    return _getFormattedUrl(
      _serviceShop,
      _accountIdDelimiter + "/brands/topbrands/",
      _v5,
    );
  }

  static String getSales() {
    return _getFormattedUrl(
      _serviceSale,
      _accountIdDelimiter + "/banners/grouped/",
      _v3,
    );
  }

  static String getSales2() {
    return _getFormattedUrl(
      _serviceSale,
      _accountIdDelimiter + "/banners/groups/",
      _v3,
    );
  }

  static String getSaleBannerDetails() {
    return _getFormattedUrl(
      _serviceShop,
      _accountIdDelimiter + "/sales/{sale_id}",
      _v2,
    );
  }

  static String getSaleBannerDetails2() {
    return _getFormattedUrl(
      _serviceSale,
      _accountIdDelimiter + "/sales/external/",
      _v3,
    );
  }

  static String getSorting() {
    return _getFormattedUrl(
      _serviceShop,
      _accountIdDelimiter + "/sorting/",
      _v2,
    );
  }

  static String getProducts() {
    return _getFormattedUrl(
      _serviceShop,
      _accountIdDelimiter + "/products",
      _v4,
    );
  }

  static String getProductDetailsWithoutSales() {
    return _getFormattedUrl(
      _serviceProduct,
      _accountIdDelimiter + "/products/{seo_identifier}",
      _v2,
    );
  }

  // note: sale_id is from a product list opened from banners
  static String getProductDetailsWithSales() {
    return _getFormattedUrl(
      _serviceProduct,
      _accountIdDelimiter + "/sales/{sale_id}/products/{seo_identifier}",
      _v2,
    );
  }

  static String getProductDetailsWithoutSalesNoSkuVariants() {
    return _getFormattedUrl(
      _serviceProduct,
      _accountIdDelimiter + "/products/{seo_identifier}/details",
      _v2,
    );
  }

  // note: sale_id is from a product list opened from banners
  static String getProductDetailsWithSalesNoSkuVariants() {
    return _getFormattedUrl(
      _serviceProduct,
      _accountIdDelimiter +
          "/sales/{sale_id}/products/{seo_identifier}/details",
      _v2,
    );
  }

  static String getProductDetailsFromCategories() {
    return _getFormattedUrl(
      _serviceProduct,
      _accountIdDelimiter + "/products/{seo_identifier}",
      _v2,
    );
  }

  static String getProductDetailDynamicDiscount() {
    return _getFormattedUrl(
      _serviceProduct,
      _accountIdDelimiter + "/price/label",
      _v2,
    );
  }

  static String getPromoInfo() {
    return _getFormattedUrl(
      _serviceProduct,
      _accountIdDelimiter + "/promo-info",
      _v3,
    );
  }

  static String getAddToCart() {
    return _getFormattedUrl(
      _serviceProduct,
      _accountIdDelimiter + "/basket/items",
      _v2,
    );
  }

  static String getBasketQuantity() {
    return _getFormattedUrl(
      _serviceProduct,
      _accountIdDelimiter + "/basket/items/quantity",
      _v2,
    );
  }

  static String getSearchEvent() {
    return _getFormattedUrl(_serviceEventing, "events", _v1);
  }

  static String getEventUser() {
    return _getFormattedUrl(_serviceEventing, "users/current", _v1);
  }

  static String getWishlistEvent() {
    return _getFormattedUrl(_serviceEventing, "events", _v1);
  }

  static String getFeatureUsageEvent() {
    return _getFormattedUrl(_serviceEventing, "events", _v1);
  }

  static String getDeliveryPriceViewEvent() {
    return _getFormattedUrl(_serviceEventing, "events", _v1);
  }

  static String getSellerLinkEvent() {
    return _getFormattedUrl(_serviceEventing, "events", _v1);
  }

  /* Account Data*/
  static String accountData() {
    return _getFormattedUrl(
      _serviceSetting,
      "settings/accountdata/" + _accountIdDelimiter,
      _v2,
    );
  }

  /*SMS VERIFICATION*/
  static String getSmsVerificationNormalizePhone() {
    return _getFormattedUrl(
      _serviceLegacy,
      _noAkamaiExtension + "NormalizePhone",
      _emptyVersion,
    );
  }

  static String getSmsVerificationCodeSend() {
    return _getFormattedUrl(
      _serviceLegacy,
      _noAkamaiExtension + "VerificationCodeSend",
      _emptyVersion,
    );
  }

  static String getSmsVerificationCodeConfirm() {
    return _getFormattedUrl(
      _serviceLegacy,
      _noAkamaiExtension + "VerificationCodeConfirm",
      _emptyVersion,
    );
  }

  /*GCM CALLS*/
  static String gcmRegisterDevice() {
    return _getFormattedUrl(
      _serviceLegacy,
      _noAkamaiExtension + "RegisterDevice",
      _emptyVersion,
    );
  }

  static String gcmNotificationEvent() {
    return _getFormattedUrl(
      _serviceLegacy,
      _akamaiExtension + "NotificationEvent",
      _emptyVersion,
    );
  }

  static String gcmRegisterSubscriber() {
    return _getFormattedUrl(
      _serviceLegacy,
      _akamaiExtension + "RegisterSubscriber",
      _emptyVersion,
    );
  }

  /*CONFIG CALLS*/
  static String getServerSettings() {
    return _getFormattedUrl(
      _serviceLegacy,
      _akamaiExtension + "GetServerSettings",
      _emptyVersion,
    );
  }

  static String getPublicAppSettings() {
    return _getFormattedUrl(
      _serviceLegacy,
      _akamaiExtension + "GetPublicAppSettings",
      _emptyVersion,
    );
  }

  static String getAppSettings() {
    return _getFormattedUrl(
      _serviceLegacy,
      _akamaiExtension + "GetAppSettings",
      _emptyVersion,
    );
  }

  static String getAppSettingsSection() {
    return _getFormattedUrl(
      _serviceLegacy,
      _akamaiExtension + "GetAppSettingsSection",
      _emptyVersion,
    );
  }

  static String getPublicAppSettingsSection() {
    return _getFormattedUrl(
      _serviceLegacy,
      _akamaiExtension + "GetPublicAppSettingsSection",
      _emptyVersion,
    );
  }

  static String getConsentData() {
    return _getFormattedUrl(
      _serviceLegacy,
      _noAkamaiExtension + "GetConsentData",
      _emptyVersion,
    );
  }

  static String saveConsentData() {
    return _getFormattedUrl(
      _serviceLegacy,
      _noAkamaiExtension + "SaveConsentData",
      _emptyVersion,
    );
  }

  static String saveReceiveSales() {
    return _getFormattedUrl(
      _serviceLegacy,
      _noAkamaiExtension + "SaveReceiveSales",
      _emptyVersion,
    );
  }

  static String getPublicPaymentToken() {
    return _getFormattedUrl(
      _serviceLegacy,
      _noAkamaiExtension + "GetPublicPaymentToken",
      _emptyVersion,
    );
  }

  static String getUserLanguages() {
    return _getFormattedUrl(
      _serviceLegacy,
      _noAkamaiExtension + "GetUserLanguages",
      _emptyVersion,
    );
  }

  static String setUserLanguages() {
    return _getFormattedUrl(
      _serviceLegacy,
      _noAkamaiExtension + "SetUserLanguage",
      _emptyVersion,
    );
  }

  /* Shops Controller */
  static String getShopBanners() {
    return _getFormattedUrl(
      _serviceGenie,
      "GetPublicSalesBanners",
      _emptyVersion,
    );
  }

  static String getSalesCategories() {
    return _getFormattedUrl(_serviceGenie, "GetSaleCategories", _emptyVersion);
  }

  /* Sale Items Controller */
  static String getPublicSaleItems() {
    return _getFormattedUrl(_serviceGenie, "GetPublicSaleItems", _emptyVersion);
  }

  /* Categories Controller */
  static String getShopCategories() {
    return _getFormattedUrl(
      _serviceGenie,
      "GetPublicSalesCategories",
      _emptyVersion,
    );
  }

  /* Sales Controller */
  static String getSaleItems() {
    return _getFormattedUrl(_serviceGenie, "GetSaleItems", _emptyVersion);
  }

  static String getSaleDetails() {
    return _getFormattedUrl(_serviceGenie, "GetSaleDetails", _emptyVersion);
  }

  static String getSaleCategories() {
    return _getFormattedUrl(_serviceGenie, "GetSaleCategories", _emptyVersion);
  }

  /* Sale Detail Controller */
  static String getSalesItemSaleDetails() {
    return _getFormattedUrl(
      _serviceGenie,
      "GetPublicSaleDetails",
      _emptyVersion,
    );
  }

  static String getSalesItemDetails() {
    return _getFormattedUrl(
      _serviceGenie,
      "GetPublicItemDetails",
      _emptyVersion,
    );
  }

  /* Voucher Controller */
  static String addVoucherByKey() {
    return _getFormattedUrl(
      _serviceLegacy,
      _noAkamaiExtension + "AddVoucherByKey",
      _emptyVersion,
    );
  }

  static String addAndApplyVoucher() {
    return _getFormattedUrl(
      _serviceLegacy,
      _noAkamaiExtension + "AddAndApplyVoucherByKey",
      _emptyVersion,
    );
  }

  static String removeVoucherByKey() {
    return _getFormattedUrl(
      _serviceLegacy,
      _noAkamaiExtension + "RemoveVoucherByKey",
      _emptyVersion,
    );
  }

  static String getUserVouchers() {
    return _getFormattedUrl(
      _serviceMyAccount,
      _accountIdDelimiter + "/my-account/vouchers",
      _v1,
    );
  }

  static String getVouchers() {
    return _getFormattedUrl(
      _serviceLegacy,
      _noAkamaiExtension + "GetVouchers",
      _emptyVersion,
    );
  }

  /* Invite Controller */
  static String setInvite() {
    return _getFormattedUrl(
      _serviceLegacy,
      _noAkamaiExtension + "SetInviteLink",
      _emptyVersion,
    );
  }

  static String getInvite() {
    return _getFormattedUrl(
      _serviceLegacy,
      _noAkamaiExtension + "GetInviteLink",
      _emptyVersion,
    );
  }

  /* Contact Controller */
  static String answerContact() {
    return _getFormattedUrl(
      _serviceMyAccount,
      _accountIdDelimiter + "/my-account/threads/number={number}/messages",
      _v1,
    );
  }

  static String createContactOld() {
    return _getFormattedUrl(
      _serviceLegacy,
      _noAkamaiExtension + "CreateContact",
      _emptyVersion,
    );
  }

  static String createContact() {
    return _getFormattedUrl(
      _serviceMyAccount,
      _accountIdDelimiter + "/my-account/threads",
      _v1,
    );
  }

  static String createContactPublic() {
    return _getFormattedUrl(
      _serviceMyAccount,
      _accountIdDelimiter + "/my-account/threads/public",
      _v1,
    );
  }

  static String getContactInvoices() {
    return _getFormattedUrl(
      _serviceMyAccount,
      _accountIdDelimiter + "/my-account/threads/invoices",
      _v1,
    );
  }

  static String getContact() {
    return _getFormattedUrl(
      _serviceMyAccount,
      _accountIdDelimiter + "/my-account/threads/number={number}/messages",
      _v1,
    );
  }

  static String getContacts() {
    return _getFormattedUrl(
      _serviceMyAccount,
      _accountIdDelimiter + "/my-account/threads",
      _v1,
    );
  }

  static String getContactSubjects() {
    return _getFormattedUrl(
      _serviceMyAccount,
      _accountIdDelimiter + "/my-account/threads/subjects?public={public}",
      _v1,
    );
  }

  static String getContactSubjectsTemplates() {
    return _getFormattedUrl(
      _serviceMyAccount,
      _accountIdDelimiter + "/my-account/threads/subjects/{id}/templates",
      _v1,
    );
  }

  static String escalateContact() {
    return _getFormattedUrl(
      _serviceMyAccount,
      _accountIdDelimiter + "/my-account/threads/number={number}:escalate",
      _v1,
    );
  }

  /* Return Controller */
  static String getReturns() {
    return _getFormattedUrl(
      _serviceMyAccount,
      _accountIdDelimiter + "/my-account/returns",
      _v1,
    );
  }

  static String getReturnOrders() {
    return _getFormattedUrl(
      _serviceMyAccount,
      _accountIdDelimiter + "/my-account/return-orders",
      _v1,
    );
  }

  static String getReturnOrderDetail() {
    return _getFormattedUrl(
      _serviceMyAccount,
      _accountIdDelimiter +
          "/my-account/return-orders/invoices/number={invoice_number}",
      _v1,
    );
  }

  static String getReturnDetails() {
    return _getFormattedUrl(
      _serviceMyAccount,
      _accountIdDelimiter + "/my-account/returns/{return_id}",
      _v1,
    );
  }

  static String setContactForReturns() {
    return _getFormattedUrl(
      _serviceMyAccount,
      _accountIdDelimiter +
          "/my-account/returns/{return_id}/threads/number={contact_number}",
      _v1,
    );
  }

  static String createReturn() {
    return _getFormattedUrl(
      _serviceMyAccount,
      _accountIdDelimiter + "/my-account/returns",
      _v1,
    );
  }

  static String callSetReturnReceived() {
    return _getFormattedUrl(
      _serviceMyAccount,
      _accountIdDelimiter + "/my-account/returns/{return_id}:received",
      _v1,
    );
  }

  static String callSetReturnNotReceived() {
    return _getFormattedUrl(
      _serviceMyAccount,
      _accountIdDelimiter + "/my-account/returns/{return_id}:not_received",
      _v1,
    );
  }

  static String callGetReturnReceivedSatisfaction() {
    return _getFormattedUrl(
      _serviceMyAccount,
      _accountIdDelimiter +
          "/my-account/returns/{return_id}:return_satisfaction",
      _v1,
    );
  }

  /* Address Controller */
  static String deleteUserDeliveryAddress() {
    return _getFormattedUrl(
      _serviceMyAccount,
      _accountIdDelimiter + "/my-account/addresses/{addressId}",
      _v1,
    );
  }

  static String getUserAddresses() {
    return _getFormattedUrl(
      _serviceMyAccount,
      _accountIdDelimiter + "/my-account/addresses",
      _v1,
    );
  }

  static String setUserDeliveryAddress() {
    return _getFormattedUrl(
      _serviceMyAccount,
      _accountIdDelimiter + "/my-account/addresses",
      _v1,
    );
  }

  static String applyDeliveryAddress() {
    return _getFormattedUrl(
      _serviceLegacy,
      _noAkamaiExtension + "ApplyDeliveryAddress",
      _emptyVersion,
    );
  }

  /* Orders Controller*/
  static String getOrders() {
    return _getFormattedUrl(
      _serviceMyAccount,
      _accountIdDelimiter + "/my-account/orders",
      _v1,
    );
  }

  static String getOrdersHistory() {
    return _getFormattedUrl(
      _serviceMyAccount,
      _accountIdDelimiter +
          "/my-account/orders?from={from_date}&months={months}",
      _v1,
    );
  }

  static String getOrderDetails() {
    return _getFormattedUrl(
      _serviceMyAccount,
      _accountIdDelimiter + "/my-account/orders/number={order_number}",
      _v1,
    );
  }

  static String getOrderTracking() {
    return _getFormattedUrl(
      _serviceMyAccount,
      _accountIdDelimiter +
          "/my-account/orders/number={order_id}/invoices/number={invoice_number}/tracking",
      _v1,
    );
  }

  static String changeDeliveryAddress() {
    return _getFormattedUrl(
      _serviceMyAccount,
      _accountIdDelimiter +
          "/my-account/orders/{order_id}/invoices/number={invoice_number}/addresses/{address_id}",
      _v2,
    );
  }

  static String cancelInvoice() {
    return _getFormattedUrl(
      _serviceMyAccount,
      _accountIdDelimiter +
          "/my-account/orders/{order_id}/invoices/number={invoice_number}",
      _v1,
    );
  }

  static String cancelInvoiceItem() {
    return _getFormattedUrl(
      _serviceMyAccount,
      _accountIdDelimiter +
          "/my-account/orders/{order_id}/invoices/number={invoice_number}/ordered/{order_item_id}?qty={quantity}",
      _v1,
    );
  }

  static String callSetOrderReceived() {
    return _getFormattedUrl(
      _serviceMyAccount,
      _accountIdDelimiter +
          "/my-account/orders/{order_id}/invoices/number={invoice_number}:received",
      _v1,
    );
  }

  static String callSetOrderNotReceived() {
    return _getFormattedUrl(
      _serviceMyAccount,
      _accountIdDelimiter +
          "/my-account/orders/{order_id}/invoices/number={invoice_number}:not_received",
      _v1,
    );
  }

  static String callGetOrderReceivedSatisfaction() {
    return _getFormattedUrl(
      _serviceMyAccount,
      _accountIdDelimiter +
          "/my-account/orders/{order_id}/invoices/number={invoice_number}:received_satisfaction",
      _v1,
    );
  }

  /* Checkout Endpoints*/
  static String getCurrentOrder() {
    return _getFormattedUrl(
      _serviceLegacy,
      _noAkamaiExtension + "GetCurrentOrder",
      _emptyVersion,
    );
  }

  static String getUserPaymentMethods() {
    return _getFormattedUrl(
      _serviceLegacy,
      _noAkamaiExtension + "GetUserPaymentMethods",
      _emptyVersion,
    );
  }

  static String createPaymentMethod() {
    return _getFormattedUrl(
      _serviceLegacy,
      _noAkamaiExtension + "CreatePaymentMethod",
      _emptyVersion,
    );
  }

  static String getPaymentToken() {
    return _getFormattedUrl(
      _serviceLegacy,
      _noAkamaiExtension + "GetPaymentToken",
      _emptyVersion,
    );
  }

  static String decreaseOrderItem() {
    return _getFormattedUrl(
      _serviceLegacy,
      _noAkamaiExtension + "DecreaseOrderItem",
      _emptyVersion,
    );
  }

  static String increaseOrderItem() {
    return _getFormattedUrl(
      _serviceLegacy,
      _noAkamaiExtension + "IncreaseOrderItem",
      _emptyVersion,
    );
  }

  static String applyVouchers() {
    return _getFormattedUrl(
      _serviceLegacy,
      _noAkamaiExtension + "ApplyVouchers",
      _emptyVersion,
    );
  }

  static String clearVouchers() {
    return _getFormattedUrl(
      _serviceLegacy,
      _noAkamaiExtension + "ClearVouchers",
      _emptyVersion,
    );
  }

  static String clearOrder() {
    return _getFormattedUrl(
      _serviceLegacy,
      _noAkamaiExtension + "ClearOrder",
      _emptyVersion,
    );
  }

  static String createPaymentTransaction() {
    return _getFormattedUrl(
      _serviceLegacy,
      _noAkamaiExtension + "CreatePaymentTransaction",
      _emptyVersion,
    );
  }

  static String createPaymentTransactionForGPay() {
    return _getFormattedUrl(
      _serviceLegacy,
      _noAkamaiExtension + "CreatePaymentTransaction",
      _emptyVersion,
    );
  }

  static String removeUserPaymentMethod() {
    return _getFormattedUrl(
      _serviceLegacy,
      _noAkamaiExtension + "RemoveUserPaymentMethod",
      _emptyVersion,
    );
  }

  static String getDeliveryServicePackageDetails() {
    return _getFormattedUrl(
      _serviceLegacy,
      _noAkamaiExtension + "GetDeliveryServicePackageDetails",
      _emptyVersion,
    );
  }

  static String setDeliveryOption() {
    return _getFormattedUrl(
      _serviceLegacy,
      _noAkamaiExtension + "SetDeliveryOption",
      _emptyVersion,
    );
  }

  /* Legalities Endpoint*/
  static String getLegalitiesText() {
    return _getFormattedUrl(
      _serviceLegacy,
      _noAkamaiExtension + "GetTemplateText",
      _emptyVersion,
    );
  }

  static String getTemplateTexts() {
    return _getFormattedUrl(
      _serviceLegacy,
      _noAkamaiExtension + "GetTemplateTexts",
      _emptyVersion,
    );
  }

  /* Login Controller */
  static String forgotPassword() {
    return _getFormattedUrl(
      _serviceLegacy,
      _noAkamaiExtension + "ForgotPassword",
      _emptyVersion,
    );
  }

  static String loginEmail() {
    return _getFormattedUrl(
      _serviceLegacy,
      _noAkamaiExtension + "Signin",
      _emptyVersion,
    );
  }

  static String loginFb() {
    return _getFormattedUrl(
      _serviceLegacy,
      _noAkamaiExtension + "LoginFacebook",
      _emptyVersion,
    );
  }

  static String loginTicket() {
    return _getFormattedUrl(
      _serviceLegacy,
      _noAkamaiExtension + "LoginTicket",
      _emptyVersion,
    );
  }

  static String logout() {
    return _getFormattedUrl(
      _serviceLegacy,
      _noAkamaiExtension + "Logout",
      _emptyVersion,
    );
  }

  static String registration() {
    return _getFormattedUrl(
      _serviceLegacy,
      _noAkamaiExtension + "Signup",
      _emptyVersion,
    );
  }

  /* User Details */

  static String saveUserDetails() {
    return _getFormattedUrl(
      _serviceMyAccount,
      _accountIdDelimiter + "/my-account/details",
      _v1,
    );
  }

  static String loadUserDetails() {
    return _getFormattedUrl(
      _serviceMyAccount,
      _accountIdDelimiter + "/my-account/details",
      _v1,
    );
  }

  static String accountDeletion() {
    return _getFormattedUrl(
      _serviceMyAccount,
      _accountIdDelimiter +
          "/my-account/customers/{customer_id}/account:deactivate",
      _v1,
    );
  }

  static String upddateEmailSubscription() {
    return _getFormattedUrl(
      _serviceMyAccount,
      _accountIdDelimiter + "/my-account/notifications/email/subscription",
      _v1,
    );
  }

  static String updateEmailSubscriptionV2() {
    return _getFormattedUrl(
      _serviceMyAccount,
      _accountIdDelimiter + "/my-account/notifications/email/preference",
      _v1,
    );
  }

  static String getEmailSubscriptionTemplates() {
    return _getFormattedUrl(
      _serviceMyAccount,
      _accountIdDelimiter +
          "/my-account/notifications/email/subscription/templates",
      _v2,
    );
  }

  /* Summary */
  static String getSummaryMenu() {
    return _getFormattedUrl(_serviceGenie, "menu", _emptyVersion);
  }

  static String getSummaryDashboards() {
    return _getFormattedUrl(_serviceGenie, "summary/dashboards", _emptyVersion);
  }

  static String getSummaryFilters() {
    return _getFormattedUrl(
      _serviceGenie,
      "summary/{dashboardName}/filters",
      _emptyVersion,
    );
  }

  static String getSummaryMeasures() {
    return _getFormattedUrl(
      _serviceGenie,
      "summary/{dashboardName}/measures",
      _emptyVersion,
    );
  }

  static String getSummaryData() {
    return _getFormattedUrl(
      _serviceGenie,
      "summary/{dashboardName}/data",
      _emptyVersion,
    );
  }

  static String getSummaryDataFilters() {
    return _getFormattedUrl(
      _serviceGenie,
      "summary/{dashboardName}/data/{period?}{measure}{&filters}",
      _emptyVersion,
    );
  }

  /* Overview */
  static String getOverviewMenu() {
    return _getFormattedUrl(_serviceGenie, "menu", _emptyVersion);
  }

  static String getOverviewDashboards() {
    return _getFormattedUrl(_serviceGenie, "revenue/dashboards", _emptyVersion);
  }

  static String getOverviewFilters() {
    return _getFormattedUrl(
      _serviceGenie,
      "revenue/overview/filters",
      _emptyVersion,
    );
  }

  static String getOverviewData() {
    return _getFormattedUrl(
      _serviceGenie,
      "revenue/overview/data",
      _emptyVersion,
    );
  }

  static String getOverviewDataFilters() {
    return _getFormattedUrl(
      _serviceGenie,
      "revenue/overview/data?{period}{&filters}",
      _emptyVersion,
    );
  }

  /* Masterpass */
  static String masterpassPayment() {
    return _getFormattedUrl(
      _serviceLegacy,
      _noAkamaiExtension + "MasterPassPayment",
      _emptyVersion,
    );
  }

  static String masterpassPostTransaction() {
    return _getFormattedUrl(
      _serviceLegacy,
      _noAkamaiExtension + "MasterPassPostTransaction",
      _emptyVersion,
    );
  }

  /* 3DS */
  static String getPaymentMethodNonce() {
    return _getFormattedUrl(
      _serviceLegacy,
      _noAkamaiExtension + "GetPaymentMethodNonce",
      _emptyVersion,
    );
  }

  static String createAfterpayOrder() {
    return _getFormattedUrl(
      _serviceLegacy,
      _noAkamaiExtension + "CreateAfterpayOrder",
      _emptyVersion,
    );
  }

  static String callAfterPayCreatePayment() {
    return _getFormattedUrl(
      _serviceLegacy,
      _noAkamaiExtension + "AfterPayCreatePayment",
      _emptyVersion,
    );
  }

  static String callGetAfterpayData() {
    return _getFormattedUrl(
      _serviceProduct,
      _accountIdDelimiter + "/afterpay?amount={amount}",
      _v2,
    );
  }

  static String callCreateLPayOrder() {
    return _getFormattedUrl(
      _serviceLegacy,
      _noAkamaiExtension + "CreateLPayOrder",
      _emptyVersion,
    );
  }

  static String callConfirmLPayTransaction() {
    return _getFormattedUrl(
      _serviceLegacy,
      _noAkamaiExtension + "ConfirmLPayTransaction",
      _emptyVersion,
    );
  }

  static String callCreateKlarnaSession() {
    return _getFormattedUrl(
      _serviceLegacy,
      _noAkamaiExtension + "CreateKlarnaSession",
      _emptyVersion,
    );
  }

  static String callCreateKlarnaOrder() {
    return _getFormattedUrl(
      _serviceLegacy,
      _noAkamaiExtension + "CreateKlarnaOrder",
      _emptyVersion,
    );
  }

  static String callCreateZipCheckout() {
    return _getFormattedUrl(
      _serviceLegacy,
      _noAkamaiExtension + "CreateZipCheckout",
      _emptyVersion,
    );
  }

  static String callCreateZipCharge() {
    return _getFormattedUrl(
      _serviceLegacy,
      _noAkamaiExtension + "CreateZipCharge",
      _emptyVersion,
    );
  }

  static String callCreatePublicZipCheckout() {
    return _getFormattedUrl(
      _serviceLegacy,
      _noAkamaiExtension + "CreatePublicZipCheckout",
      _emptyVersion,
    );
  }

  static String callCreatePublicZipCharge() {
    return _getFormattedUrl(
      _serviceLegacy,
      _noAkamaiExtension + "CreatePublicZipCharge",
      _emptyVersion,
    );
  }

  static String callCreateZipPayNzOrder() {
    return _getFormattedUrl(
      _serviceLegacy,
      _noAkamaiExtension + "CreateZipPayNzOrder",
      _emptyVersion,
    );
  }

  static String callConfirmZipPayNzOrder() {
    return _getFormattedUrl(
      _serviceLegacy,
      _noAkamaiExtension + "ConfirmZipPayNzOrder",
      _emptyVersion,
    );
  }

  /*VISA CHECKOUT*/
  static String visaCheckoutLogin() {
    return _getFormattedUrl(
      _serviceLegacy,
      _noAkamaiExtension + "LoginVisa",
      _emptyVersion,
    );
  }

  static String getWishlistIdsOnly() {
    return _getFormattedUrl(_serviceWishlist, "ids", _v4);
  }

  static String getWishlistAll() {
    return _getFormattedUrl(
      _serviceShop,
      _accountIdDelimiter + "/wishlist",
      _v4,
    );
  }

  static String getWishlistPaginated() {
    return _getFormattedUrl(
      _serviceShop,
      _accountIdDelimiter + "/wishlist/search?limit={limit}&offset={offset}",
      _v5,
    );
  }

  static String addToWishlist() {
    return _getFormattedUrl(_serviceWishlist, "", _v4);
  }

  static String removeFromWishlist() {
    return _getFormattedUrl(_serviceWishlist, "{product_id}", _v4);
  }

  static String setAttachment() {
    return _getFormattedUrl(
      _serviceMyAccount,
      _accountIdDelimiter + "/my-account/returns/{return_id}/attachments",
      _v1,
    );
  }

  static String setAttachmentForContact() {
    return _getFormattedUrl(
      _serviceMyAccount,
      _accountIdDelimiter +
          "/my-account/threads/number={number}/messages/{id}/attachments",
      _v1,
    );
  }

  static String uploadImage() {
    return _getFormattedUrl(_serviceAttachments, "attachment/", _v1);
  }

  static String fileSettings() {
    return _getFormattedUrl(_serviceAttachments, "settings", _v1);
  }

  static String recommendedItems() {
    return _getFormattedUrl(
      _serviceProduct,
      _accountIdDelimiter + "/recommendations/hrnn",
      _v4,
    );
  }

  static String callYouMakeAlsoLike() {
    return _getFormattedUrl(
      _serviceProduct,
      _accountIdDelimiter + "/recommendations/sims/{sku_id}",
      _v4,
    );
  }

  static String bestSellers() {
    return _getFormattedUrl(
      _serviceProduct,
      _accountIdDelimiter + "/recommendations/popularitycount",
      _v5,
    );
  }

  static String addToRecentlyViewedItems() {
    return _getFormattedUrl(_serviceRecently, "", _v4);
  }

  static String recentlyViewedItems() {
    return _getFormattedUrl(
      _serviceShop,
      _accountIdDelimiter + "/recently",
      _v5,
    );
  }

  static String getTicketSatisfaction() {
    return _getFormattedUrl(
      _serviceMyAccount,
      _accountIdDelimiter +
          "/my-account/threads/number={number}:ticket_satisfaction",
      _v1,
    );
  }

  static String closeTicketSatisfaction() {
    return _getFormattedUrl(
      _serviceMyAccount,
      _accountIdDelimiter + "/my-account/threads/number={number}:close",
      _v1,
    );
  }

  static String getPostcodeDefault() {
    return _getFormattedUrl(_serviceEventing, "users/current", _v2);
  }

  static String getPostcodeShippingPrice() {
    return _getFormattedUrl(
      _serviceProduct,
      _accountIdDelimiter +
          "/products/delivery?postCode={postcode}&skuId={skuid}&weight={weight}&height={height}&length=&width={width}&price={price}",
      _v1,
    );
  }

  static String saveAgeRestrictedConsentData() {
    return _getFormattedUrl(
      _serviceLegacy,
      _noAkamaiExtension + "SaveAgeRestrictedConsentData",
      _emptyVersion,
    );
  }

  static String getNZCommissionTemplateText() {
    return _getFormattedUrl(
      _serviceSetting,
      "settings/accounts/" +
          _accountIdDelimiter +
          "/templates?templateTypes=1,2",
      _v1,
    );
  }

  static String getBuyboxTemplateTexts() {
    return _getFormattedUrl(
      _serviceSetting,
      "settings/accounts/" + _accountIdDelimiter + "/templates?templateTypes=3",
      _v2,
    );
  }

  static String callGetNotifications() {
    return _getFormattedUrl(
      _serviceCustomer,
      "accounts/" + _accountIdDelimiter + "/notifications",
      _v2,
    );
  }
}
