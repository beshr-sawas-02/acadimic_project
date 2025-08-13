import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../theme/app_colors.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  void _login(AuthController controller) {
    controller.login();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();

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
                            CustomButton(
                              text: 'login'.tr,
                              onPressed: () {
                                _login(controller);
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

            // زر تغيير اللغة (أيقونة فقط)
            Positioned(
              top: 40,
              right: 24,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary.withOpacity(0.8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(8),
                  elevation: 4,
                  minimumSize: const Size(40, 40),
                ),
                child: const Icon(Icons.language, size: 20, color: Colors.white),
                onPressed: () {
                  if (Get.locale?.languageCode == 'en') {
                    Get.updateLocale(const Locale('ar'));
                  } else {
                    Get.updateLocale(const Locale('en'));
                  }
                },
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
