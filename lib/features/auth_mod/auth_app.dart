import '../../core/classes/route_manager.dart';
import 'controllers/controllers.dart';

class AuthApp extends RouteManager {
  static const String name = '';
  static const String login = '${AuthApp.name}/login';

  AuthApp() {
    addRoute(AuthApp.login, (context) => const LoginController());
  }
}
