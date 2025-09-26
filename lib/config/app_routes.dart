import '../core/classes/route_manager.dart';
import '../features/auth_mod/auth_app.dart';
import '../features/main_app/app.dart';

class Routes extends RouteManager {
  Routes() {
    addAll(App().routes);
    addAll(AuthApp().routes);
  }
}
