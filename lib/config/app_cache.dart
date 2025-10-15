import 'dart:convert';

import 'package:flutter_mysale/features/main_app/models/main/user_model.dart';

import '../core/classes/cache_manager.dart';

class _Keys {
  static String loginTicket = 'login_ticket';
  static String user = 'user';
}

class AppCache {
  Future<String?> get loginTicket async {
    return await Cache.readData(_Keys.loginTicket) as String?;
  }

  Future<void> setLoginTicket(String? loginTicket) async {
    if (loginTicket != null && loginTicket.isNotEmpty) {
      Cache.saveData(_Keys.loginTicket, loginTicket);
    } else {
      await Cache.deleteData(_Keys.loginTicket);
    }
  }

  Future<User?> get user async {
    final userString = await Cache.readData(_Keys.user) as String?;
    if (userString == null || userString.isEmpty) {
      return null;
    } else {
      try {
        final map = jsonDecode(userString) as Map<String, dynamic>;
        return User.fromJson(map);
      } catch (_) {
        return null;
      }
    }
  }

  Future<void> setUser(User? user) async {
    if (user != null && user.id.isNotEmpty) {
      final userString = jsonEncode(user.toJson());
      Cache.saveData(_Keys.user, userString);
    } else {
      await Cache.deleteData(_Keys.user);
    }
  }
}
