import 'dart:convert';

import '../core/classes/cache_manager.dart';

class AppCache {
  Map<String, String>? udata;
  String _loginTicket = "login_ticket";

  void doLogin(String username, String password) {
    udata = {'user': username, 'pass': password};
    Cache.saveData('auth_data', jsonEncode(udata));
  }

  Future<Map<String, String>> auth() async {
    var data = await Cache.readData('auth_data');
    return udata = jsonDecode(data);
  }

  Future<bool> isLogin() async {
    var data = await Cache.readData('auth_data');
    if (data != null) {
      return true;
    }
    return false;
  }

  void doLogout() {
    Cache.deleteData('auth_data');
    Cache.deleteData('login_ticket');
  }

  Future<bool> isLogout() async {
    var data = await Cache.readData('auth_data');
    if (data == null) {
      return true;
    }
    return false;
  }

  void saveLoginTicket(String ticket) {
    Cache.saveData(_loginTicket, ticket);
  }

  Future<String> retrieveLoginTicket() async {
    var data = await Cache.readData(_loginTicket);
    return data.toString();
  }
}
