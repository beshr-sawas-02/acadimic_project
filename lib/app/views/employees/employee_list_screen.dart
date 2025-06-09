import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/employee_controller.dart';
import '../../theme/app_colors.dart';
import '../../../widgets/custom_drawer.dart';
import '../../routes/app_pages.dart';

class EmployeeListScreen extends StatelessWidget {
  const EmployeeListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EmployeeController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('employees'.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              controller.resetForm();
              Get.toNamed(Routes.ADD_EDIT_EMPLOYEE);
            },
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.employees.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.people,
                  size: 64,
                  color: AppColors.secondary.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'no_employees_found'.tr,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'start_by_adding'.tr,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    controller.resetForm();
                    Get.toNamed(Routes.ADD_EDIT_EMPLOYEE);
                  },
                  icon: const Icon(Icons.add),
                  label: Text('add_employee'.tr),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.employees.length,
          itemBuilder: (context, index) {
            final employee = controller.employees[index];

            return Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                onTap: () {
                  controller.setSelectedEmployee(employee);
                  Get.toNamed(Routes.EMPLOYEE_DETAIL);
                },
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: AppColors.primary,
                            child: Text(
                              employee.name.isNotEmpty ? employee.name[0].toUpperCase() : 'E',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.tertiary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  employee.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  employee.email,
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.secondary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppColors.secondary,
                              ),
                            ),
                            child: Text(
                              employee.role.toString().toUpperCase(),
                              style: TextStyle(
                                color: AppColors.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${'dob'.tr}: ${employee.dob}',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton.icon(
                            icon: const Icon(Icons.edit),
                            label: Text('edit'.tr),
                            onPressed: () {
                              controller.setSelectedEmployee(employee);
                              Get.toNamed(Routes.ADD_EDIT_EMPLOYEE);
                            },
                          ),
                          const SizedBox(width: 8),
                          TextButton.icon(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            label: Text(
                              'delete'.tr,
                              style: const TextStyle(color: Colors.red),
                            ),
                            onPressed: () => controller.deleteEmployee(employee.id),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.secondary,
        child: const Icon(Icons.add),
        onPressed: () {
          controller.resetForm();
          Get.toNamed(Routes.ADD_EDIT_EMPLOYEE);
        },
      ),
    );
  }
}
