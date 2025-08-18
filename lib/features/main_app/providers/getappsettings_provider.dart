import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_mysale/features/main_app/models/main/getappsettings_model.dart';

import '../../../config/api_endpoints.dart';
import '../../../config/app_config.dart';
import '../../../config/app_http.dart';
import '../models/model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GetAppSettingsProvider extends ChangeNotifier {
  final AppHttp _http = AppHttp(baseUrl: dotenv.get("SETTINGS_ROOT"),
      headers: {
    'User-Agent': 'TODO'
  });
  // GetAppSettingsModel? _gasm;
  String? _json;
  bool isLoading = false;

  // GetAppSettingsModel get getAppSettingsResponse => _gasm!;
  String get json => _json!;

  void getPublicAppSettings() async {
    if (isLoading == true) {
      isLoading = false;
    }

    Response res = await _http
        .get(ApiEndpoint.getPublicAppSettings(), params: {'countryID': 'au'});
    if (res.statusCode == 200 && res.statusCode != 429) {
      // print(res);
      // _gasm = GetAppSettingsModel.fromJson(res.toString());
      _json = res.toString();
      isLoading = true;
      notifyListeners();
    }
  }
}
