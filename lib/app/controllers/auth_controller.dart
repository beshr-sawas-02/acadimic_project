import 'package:get/get.dart';
import '../data/models/login_model.dart';
import '../data/models/user_model.dart';
import '../data/repositories/auth_repository.dart';
import '../utils/dialog_helper.dart';
import '../utils/constants.dart';
import '../routes/app_pages.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  final RxBool isLoading = false.obs;
  final Rx<User?> user = Rx<User?>(null);

  // Email and password for login form
  final RxString email = ''.obs;
  final RxString password = ''.obs;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  // Check if user is already logged in
  Future<void> checkLoginStatus() async {
    if (_authRepository.isLoggedIn) {
      final userData = _authRepository.getUserData();
      if (userData != null) {
        user.value = userData;
      }
    } else {
      user.value = null;
    }
  }

  // Getter to check if user is logged in
  bool get isLoggedIn => user.value != null;

  // Login as employee
  Future<void> loginAsEmployee() async {
    if (email.value.isEmpty || password.value.isEmpty) {
      DialogHelper.showErrorSnackbar(
        title: 'Error',
        message: 'Please enter email and password',
      );
      return;
    }

    try {
      isLoading.value = true;

      final loginRequest = LoginRequest(
        email: email.value.trim(),
        password: password.value,
      );

      final userData = await _authRepository.loginEmployee(loginRequest);
      user.value = userData;

      DialogHelper.showSuccessSnackbar(
        title: 'Success',
        message: AppConstants.loginSuccess,
      );

      // Navigate to dashboard
      Get.offAllNamed(Routes.DASHBOARD);
    } catch (e) {
      DialogHelper.showErrorSnackbar(
        title: 'Login Error',
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Login as admin
  Future<void> loginAsAdmin() async {
    if (email.value.isEmpty || password.value.isEmpty) {
      DialogHelper.showErrorSnackbar(
        title: 'Error',
        message: 'Please enter email and password',
      );
      return;
    }

    try {
      isLoading.value = true;

      final loginRequest = LoginAdminRequest(
        email: email.value.trim(),
        password: password.value,
      );

      final userData = await _authRepository.loginAdmin(loginRequest);
      user.value = userData;

      DialogHelper.showSuccessSnackbar(
        title: 'Success',
        message: AppConstants.loginSuccess,
      );

      // Navigate to dashboard
      Get.offAllNamed(Routes.DASHBOARD);
    } catch (e) {
      DialogHelper.showErrorSnackbar(
        title: 'Login Error',
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Logout
  Future<void> logout() async {
    DialogHelper.showConfirmDialog(
      title: 'logout_title'.tr,
      message: 'logout_message'.tr,
      confirmText: 'logout_confirm'.tr,
      cancelText: 'logout_cancel'.tr,
      onConfirm: () async {
        try {
          isLoading.value = true;
          await _authRepository.logout();
          user.value = null;

          DialogHelper.showSuccessSnackbar(
            title: 'success_title'.tr,
            message: 'logout_success'.tr,
          );

          // Navigate to login
          Get.offAllNamed(Routes.LOGIN);
        } catch (e) {
          DialogHelper.showErrorSnackbar(
            title: 'logout_error'.tr,
            message: e.toString(),
          );
        } finally {
          isLoading.value = false;
        }
      },
    );
  }

  // Check if user is admin
  bool get isAdmin => _authRepository.isAdmin;

  // Check if user is employee
  bool get isEmployee => _authRepository.isEmployee;

  // Get user role
  String? get userRole => _authRepository.getUserRole();
}
