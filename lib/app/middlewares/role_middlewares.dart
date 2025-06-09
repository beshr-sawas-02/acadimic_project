import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../routes/app_pages.dart';
import '../utils/dialog_helper.dart';

class RoleMiddleware extends GetMiddleware {
  final bool requireAdmin;

  RoleMiddleware({this.requireAdmin = false});

  final AuthController _authController = Get.find<AuthController>();

  @override
  RouteSettings? redirect(String? route) {
    // Check if user has the required role
    if (requireAdmin && !_authController.isAdmin) {
      DialogHelper.showErrorSnackbar(
        title: 'Access Denied',
        message: 'You do not have permission to access this page.',
      );
      return const RouteSettings(name: Routes.DASHBOARD);
    }

    return null;
  }
}