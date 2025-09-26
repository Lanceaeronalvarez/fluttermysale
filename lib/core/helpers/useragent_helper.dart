import 'dart:io';

import 'package:device_marketing_names/device_marketing_names.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UserAgentHelper {

  static final shared = UserAgentHelper._();
  static String? _userAgent;
  MediaQueryData _mediaQueryData = MediaQueryData();

  UserAgentHelper._();

  void updateMediaQueryData(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
  }

  Future<String> get userAgent async {
    if (_userAgent == null) {
      await _prepare();
    }
    return _userAgent!;
  }


  Future<bool> _prepare() async {
    final deviceNames = DeviceMarketingNames();

    String appName = dotenv.get("FLAVOR_APP_NAME");
    String appVersion = "Flutter Version"; //TODO

    String deviceName, OSName, OSVersion, locale, interfaceIdiom, countryId;
    deviceName = await deviceNames.getSingleName();
    if (Platform.isIOS) {
      OSName = "iOS";
    } else if (Platform.isAndroid) {
      OSName = "Android";
    } else {
      OSName = "Unexpected";
    }
    OSVersion = Platform.operatingSystemVersion;
    locale = Platform.localeName;
    interfaceIdiom = await _getIsTablet() ? "07" : "06";
    countryId = dotenv.get("SETTINGS_COUNTRY_ID");

    _userAgent =
        appName +
        " " +
        appVersion +
        " (" +
        deviceName +
        "; " +
        OSName +
        "; " +
        OSVersion +
        "; " +
        locale +
        "; " +
        "APACSALE:" +
        interfaceIdiom +
        ":" +
        countryId +
        ")";
    return true;
  }

  Future<bool> _getIsTablet() async {
    bool isTab = false;
    if (Platform.isIOS) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      if(iosInfo.model.toLowerCase() == "ipad") {
        isTab = true;
      } else {
        isTab = false;
      }
      return isTab;
    } else {
      var shortestSide = _mediaQueryData.size.shortestSide;
      if(shortestSide > 600) {
        isTab = true;
      } else {
        isTab = false;
      }
      return isTab;
    }
  }
}
