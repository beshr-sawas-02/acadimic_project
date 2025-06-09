import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/student_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../theme/app_colors.dart';
import '../../../widgets/custom_button.dart';
import '../../routes/app_pages.dart';

class StudentDetailScreen extends StatelessWidget {
  const StudentDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StudentController>();
    final authController = Get.find<AuthController>();
    final isAdmin = authController.isAdmin;

    return Scaffold(
      appBar: AppBar(
        title: Text('student_details'.tr),
        actions: [
          if (isAdmin)
            IconButton(
              icon: const Icon(Icons.calculate),
              onPressed: () => Get.toNamed(Routes.STUDENT_GPA),
              tooltip: 'view_gpa'.tr,
            ),
        ],
      ),
      body: Obx(() {
        final student = controller.selectedStudent.value;

        if (student == null) {
          return Center(child: Text('no_student_selected'.tr));
        }

        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Student header
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
                          student.name.isNotEmpty ? student.name[0].toUpperCase() : 'S',
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
                              student.name,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.tertiary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${'university_id'.tr}: ${student.universityId}',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.tertiary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${'year'.tr} ${student.year.value}',
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

              // Student information
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
                        'student_information'.tr,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      _buildDetailRow(
                        icon: Icons.badge,
                        title: 'university_id'.tr,
                        value: student.universityId.toString(),
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        icon: Icons.school,
                        title: 'major'.tr,
                        value: student.major,
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        icon: Icons.calendar_today,
                        title: 'year'.tr,
                        value: '${'year'.tr} ${student.year.value}',
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Academic info
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
                        'academic_information'.tr,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              text: 'calculate_gpa'.tr,
                              onPressed: () => Get.toNamed(Routes.STUDENT_GPA),
                              backgroundColor: AppColors.secondary,
                              icon: Icons.calculate,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: CustomButton(
                              text: 'view_marks'.tr,
                              onPressed: () => Get.toNamed(
                                Routes.MARKS,
                                arguments: {'studentId': student.id},
                              ),
                              backgroundColor: AppColors.primary,
                              textColor: AppColors.tertiary,
                              icon: Icons.grade,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      CustomButton(
                        text: 'view_registered_courses'.tr,
                        onPressed: () => Get.toNamed(
                          Routes.COURSES,
                          arguments: {'studentId': student.id},
                        ),
                        backgroundColor: Colors.blue,
                        icon: Icons.menu_book,
                        width: double.infinity,
                      ),
                    ],
                  ),
                ),
              ),

              if (isAdmin) ...[
                const SizedBox(height: 24),
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
                          'admin_actions'.tr,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        CustomButton(
                          text: 'delete_student'.tr,
                          onPressed: () => _showDeleteConfirmation(context, controller, student.id),
                          backgroundColor: AppColors.error,
                          icon: Icons.delete,
                          width: double.infinity,
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
          child: Icon(icon, color: AppColors.secondary, size: 20),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          ],
        ),
      ],
    );
  }

  void _showDeleteConfirmation(BuildContext context, StudentController controller, String studentId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('delete_confirmation_title'.tr),
        content: Text('delete_confirmation_message'.tr),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel'.tr),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              controller.deleteStudent(studentId);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('delete'.tr),
          ),
        ],
      ),
    );
  }
}
