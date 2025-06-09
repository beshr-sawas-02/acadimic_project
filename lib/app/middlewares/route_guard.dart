import 'package:acadimic_project/app/middlewares/role_middlewares.dart';
import 'package:get/get.dart';
import 'auth_middlewares.dart';

class RouteGuard {
  static List<GetMiddleware> auth() {
    return [AuthMiddleware()];
  }

  static List<GetMiddleware> admin() {
    return [
      AuthMiddleware(),
      RoleMiddleware(requireAdmin: true),
    ];
  }

  static List<GetMiddleware> employee() {
    return [
      AuthMiddleware(),
    ];
  }
}