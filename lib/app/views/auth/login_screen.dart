import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../theme/app_colors.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  void _login(AuthController controller, String role) {
    if (role == 'admin') {
      controller.loginAsAdmin();
    } else if (role == 'employee') {
      controller.loginAsEmployee();
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();

    // متغير لتخزين الدور المختار (افتراضياً admin)
    final RxString selectedRole = 'admin'.obs;

    return Scaffold(
      body: Obx(() {
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primary.withOpacity(0.8),
                    AppColors.secondary,
                  ],
                ),
              ),
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.school,
                              color: AppColors.secondary,
                              size: 64,
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'university_management'.tr,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.secondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'admin_employee_portal'.tr,
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 32),
                            CustomTextField(
                              label: 'email'.tr,
                              hint: 'enter_email'.tr,
                              icon: Icons.email_outlined,
                              onChanged: (value) => controller.email.value = value,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              label: 'password'.tr,
                              hint: 'enter_password'.tr,
                              icon: Icons.lock_outline,
                              onChanged: (value) => controller.password.value = value,
                              isPassword: true,
                            ),
                            const SizedBox(height: 32),

                            // اختيار الدور مع إبراز الدور المحدد
                            Obx(() => Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('login_as'.tr + ': '),
                                TextButton(
                                  onPressed: () => selectedRole.value = 'admin',
                                  child: Text(
                                    'admin'.tr,
                                    style: TextStyle(
                                      color: selectedRole.value == 'admin'
                                          ? AppColors.primary
                                          : null,
                                      fontWeight: selectedRole.value == 'admin'
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => selectedRole.value = 'employee',
                                  child: Text(
                                    'employee'.tr,
                                    style: TextStyle(
                                      color: selectedRole.value == 'employee'
                                          ? AppColors.primary
                                          : null,
                                      fontWeight: selectedRole.value == 'employee'
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            )),

                            const SizedBox(height: 16),

                            // زر تسجيل الدخول
                            CustomButton(
                              text: 'login'.tr,
                              onPressed: () {
                                _login(controller, selectedRole.value);
                              },
                              backgroundColor: AppColors.secondary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (controller.isLoading.value)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        );
      }),
    );
  }
}
