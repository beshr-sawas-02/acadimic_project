import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../controllers/auth_controller.dart';
import '../../../widgets/custom_drawer.dart';
import '../../controllers/language_controller.dart';
import '../../controllers/theme_controller.dart';
import '../../theme/app_colors.dart';
import '../../routes/app_pages.dart';
import '../../../widgets/custom_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final isAdmin = authController.isAdmin;
    final isEmployee = authController.isEmployee;

    return Scaffold(
      appBar: AppBar(
        title: Text('home'.tr,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(
              Get.find<ThemeController>().isDarkMode
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              Get.find<ThemeController>().toggleTheme();
            },
          ),
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              Get.find<LanguageController>().toggleLanguage();
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: authController.logout,
          ),
        ],
      ),
      drawer: CustomDrawer(),
      body: Obx(() {
        final user = authController.user.value;

        if (user == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text(
                'quick_access'.tr,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  if (isAdmin)
                  CustomCard(
                    title: 'courses'.tr,
                    icon: Icons.menu_book,
                    color: Colors.blue,
                    onTap: () => Get.toNamed(Routes.COURSES),
                  ),
                  CustomCard(
                    title: 'students'.tr,
                    icon: Icons.school,
                    color: Colors.green,
                    onTap: () => Get.toNamed(Routes.STUDENTS),
                  ),
                  if (isAdmin)
                  CustomCard(
                    title: 'voting'.tr,
                    icon: Icons.how_to_vote,
                    color: Colors.purple,
                    onTap: () => Get.toNamed(Routes.VOTES),
                  ),
                  if (isEmployee)
                    CustomCard(
                      title: 'marks'.tr,
                      icon: Icons.grade,
                      color: Colors.orange,
                      onTap: () => Get.toNamed(Routes.MARKS),
                    ),
                  if (isAdmin)
                    CustomCard(
                      title: 'employees'.tr,
                      icon: Icons.people,
                      color: Colors.red,
                      onTap: () => Get.toNamed(Routes.EMPLOYEES),
                    ),
                ],
              ),
              const SizedBox(height: 24),
              if (isAdmin) ...[
                Text(
                  'admin_tools'.tr,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.secondary.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.settings,
                              color: AppColors.secondary,
                            ),
                          ),
                          title: Text(
                            'course_config_title'.tr,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('course_config_subtitle'.tr),
                          trailing:
                              const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () => Get.toNamed(Routes.VOTING_MANAGEMENT),
                        ),
                        const Divider(),
                        ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.secondary.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.add_circle_outline,
                              color: AppColors.secondary,
                            ),
                          ),
                          title: Text(
                            'create_employee_title'.tr,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('create_employee_subtitle'.tr),
                          trailing:
                              const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () => Get.toNamed(Routes.ADD_EDIT_EMPLOYEE),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      }),
    );
  }
}
