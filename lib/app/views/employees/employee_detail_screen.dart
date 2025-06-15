import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/employee_controller.dart';
import '../../theme/app_colors.dart';
import '../../../widgets/custom_button.dart';
import '../../routes/app_pages.dart';

class EmployeeDetailScreen extends StatelessWidget {
  const EmployeeDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EmployeeController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('employee_details'.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Get.toNamed(Routes.ADD_EDIT_EMPLOYEE),
          ),
        ],
      ),
      body: Obx(() {
        final employee = controller.selectedEmployee.value;

        if (employee == null) {
          return Center(
            child: Text('no_employee_selected'.tr),
          );
        }

        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Employee header
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: AppColors.primary,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: Text(
                          employee.name.isNotEmpty ? employee.name[0].toUpperCase() : 'E',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppColors.tertiary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              employee.name,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.tertiary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              employee.email,
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.tertiary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                employee.role.toString().toUpperCase(),
                                style: TextStyle(
                                  color: AppColors.tertiary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Employee details
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
                      Text(
                        'employee_information'.tr,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildDetailRow(
                        icon: Icons.email,
                        title: 'email'.tr,
                        value: employee.email,
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        icon: Icons.calendar_today,
                        title: 'dob'.tr,
                        value: employee.dob,
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        icon: Icons.business,
                        title: 'role'.tr,
                        value: employee.role.toString().toUpperCase(),
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        icon: Icons.business,
                        title: 'isActive'.tr,
                        value: (employee.isActive ?? true) ? "Active" : "not Active",
                      ),

                      if(employee.endDate!=null)...[
                        const SizedBox(height: 12),
                        _buildDetailRow(
                          icon: Icons.business,
                          title: 'endDate'.tr,
                          value: employee.endDate.toString(),
                        ),
                      ]
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Actions
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
                      Text(
                        'actions'.tr,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              text: 'edit_employee'.tr,
                              onPressed: () => Get.toNamed(Routes.ADD_EDIT_EMPLOYEE),
                              backgroundColor: AppColors.secondary,
                              icon: Icons.edit,
                            ),
                          ),
                          const SizedBox(width: 16),
                          if((employee.isActive ?? true))
                          Expanded(
                            child: CustomButton(
                              text: 'delete_employee'.tr,
                              onPressed: () => _showDeleteConfirmation(context, controller, employee.id),
                              backgroundColor: AppColors.error,
                              icon: Icons.delete,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.secondary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppColors.secondary,
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showDeleteConfirmation(BuildContext context, EmployeeController controller, String employeeId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('delete_employee'.tr),
        content: Text('delete_employee_confirm'.tr),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel'.tr),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              controller.deleteEmployee(employeeId);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: Text('delete'.tr),
          ),
        ],
      ),
    );
  }
}
