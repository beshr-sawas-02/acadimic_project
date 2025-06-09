import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app/controllers/auth_controller.dart';
import '../app/theme/app_colors.dart';
import '../app/routes/app_pages.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final isAdmin = authController.isAdmin;

    return Drawer(
      child: Obx(() {
        final user = authController.user.value;

        return Column(
          children: [
            // Drawer header with user info
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: AppColors.secondary,
              ),
              accountName: Text(
                user?.name ?? 'User',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: Text(
                user?.email ?? '',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: AppColors.primary,
                child: Text(
                  user?.name.isNotEmpty == true
                      ? user!.name[0].toUpperCase()
                      : 'U',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.tertiary,
                  ),
                ),
              ),
            ),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.dashboard, color: AppColors.secondary),
                      title: Text('home'.tr),
                      onTap: () {
                        Get.back();
                        Get.offAllNamed(Routes.DASHBOARD);
                      },
                    ),
                    const Divider(),

                    ListTile(
                      leading: Icon(Icons.menu_book, color: AppColors.secondary),
                      title: Text('courses'.tr),
                      onTap: () {
                        Get.back();
                        Get.toNamed(Routes.COURSES);
                      },
                    ),

                    if (isAdmin)
                      ListTile(
                        leading: Icon(Icons.add_circle_outline, color: AppColors.secondary),
                        title: Text('add_new_course'.tr),
                        onTap: () {
                          Get.back();
                          Get.toNamed(Routes.ADD_EDIT_COURSE);
                        },
                      ),

                    const Divider(),

                    ListTile(
                      leading: Icon(Icons.school, color: AppColors.secondary),
                      title: Text('students'.tr),
                      onTap: () {
                        Get.back();
                        Get.toNamed(Routes.STUDENTS);
                      },
                    ),

                    const Divider(),

                    ListTile(
                      leading: Icon(Icons.grade, color: AppColors.secondary),
                      title: Text('marks'.tr),
                      onTap: () {
                        Get.back();
                        Get.toNamed(Routes.MARKS);
                      },
                    ),

                    ListTile(
                      leading: Icon(Icons.upload_file, color: AppColors.secondary),
                      title: Text('bulk_import_marks'.tr),
                      onTap: () {
                        Get.back();
                        Get.toNamed(Routes.BULK_IMPORT_MARKS);
                      },
                    ),

                    const Divider(),

                    ListTile(
                      leading: Icon(Icons.how_to_vote, color: AppColors.secondary),
                      title: Text('voting'.tr),
                      onTap: () {
                        Get.back();
                        Get.toNamed(Routes.VOTES);
                      },
                    ),

                    if (isAdmin)
                      ListTile(
                        leading: Icon(Icons.settings, color: AppColors.secondary),
                        title: Text('voting_management'.tr),
                        onTap: () {
                          Get.back();
                          Get.toNamed(Routes.VOTING_MANAGEMENT);
                        },
                      ),

                    if (isAdmin) ...[
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text(
                          'administration'.tr,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.people, color: AppColors.secondary),
                        title: Text('employees'.tr),
                        onTap: () {
                          Get.back();
                          Get.toNamed(Routes.EMPLOYEES);
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.person_add, color: AppColors.secondary),
                        title: Text('add_new_employee'.tr),
                        onTap: () {
                          Get.back();
                          Get.toNamed(Routes.ADD_EDIT_EMPLOYEE);
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const Divider(),
            ListTile(
              leading: Icon(Icons.logout, color: AppColors.error),
              title: Text(
                'logout'.tr,
                style: TextStyle(
                  color: AppColors.error,
                ),
              ),
              onTap: authController.logout,
            ),
            const SizedBox(height: 16),
          ],
        );
      }),
    );
  }
}
