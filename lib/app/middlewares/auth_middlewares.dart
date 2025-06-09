import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../routes/app_pages.dart';

class AuthMiddleware extends GetMiddleware {
  final AuthController _authController = Get.find<AuthController>();

  @override
  RouteSettings? redirect(String? route) {
    // Check if user is logged in
    if (_authController.user.value == null && route != Routes.LOGIN && route != Routes.SPLASH) {
      return const RouteSettings(name: Routes.LOGIN);
    }

    return null;
  }
}
