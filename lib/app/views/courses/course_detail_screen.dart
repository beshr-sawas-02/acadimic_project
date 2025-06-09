import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/course_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../theme/app_colors.dart';
import '../../../widgets/custom_button.dart';
import '../../routes/app_pages.dart';

class CourseDetailScreen extends StatelessWidget {
  const CourseDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CourseController>();
    final authController = Get.find<AuthController>();
    final isAdmin = authController.isAdmin;

    return Scaffold(
      appBar: AppBar(
        title: Text('course_details'.tr),
        actions: [
          if (isAdmin)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => Get.toNamed(Routes.ADD_EDIT_COURSE),
            ),
        ],
      ),
      body: Obx(() {
        final course = controller.selectedCourse.value;

        if (course == null) {
          return Center(
            child: Text('no_course_selected'.tr),
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
              // Course header (العنوان وحالة الكورس)
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: AppColors.primary,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              course.name,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.tertiary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'course_code: ${course.courseCode}'.tr,
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.tertiary,
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
                          color: course.isOpen
                              ? Colors.green.withOpacity(0.2)
                              : Colors.red.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: course.isOpen ? Colors.green : Colors.red,
                            width: 2,
                          ),
                        ),
                        child: Text(
                          course.isOpen ? 'open'.tr : 'closed'.tr,
                          style: TextStyle(
                            color: course.isOpen ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Course details (تفاصيل الكورس)
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
                        'course_details'.tr,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildDetailRow(
                        icon: Icons.person,
                        title: 'teacher'.tr,
                        value: course.teacher,
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        icon: Icons.category,
                        title: 'type'.tr,
                        value: course.type,
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        icon: Icons.school,
                        title: 'year'.tr,
                        value: 'year ${course.year.value}'.tr,
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        icon: Icons.calendar_today,
                        title: 'semester'.tr,
                        value: course.semester,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Prerequisites (المتطلبات السابقة)
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
                        'prerequisites'.tr,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (course.prerequisites == null ||
                          course.prerequisites!.isEmpty)
                        Text(
                          'no_prerequisites'.tr,
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey,
                          ),
                        )
                      else
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: course.prerequisites!.map((prereq) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.arrow_right,
                                    color: AppColors.secondary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(prereq),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Admin actions (أزرار الإدارة)
              if (isAdmin)
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
                                text: 'edit_course'.tr,
                                onPressed: () =>
                                    Get.toNamed(Routes.ADD_EDIT_COURSE),
                                backgroundColor: AppColors.secondary,
                                icon: Icons.edit,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: CustomButton(
                                text: course.isOpen
                                    ? 'close_course'.tr
                                    : 'open_course'.tr,
                                onPressed: () async {
                                  // عكس حالة isOpen في controller
                                  controller.isOpen.value = !course.isOpen;

                                  // تحديث الكورس
                                  await controller.updateCourse();

                                  // تحديث الحالة المحلية للـ selectedCourse
                                  final updatedCourse = course.copyWith(
                                      isOpen: controller.isOpen.value);
                                  controller.selectedCourse.value =
                                      updatedCourse;
                                },
                                backgroundColor:
                                    course.isOpen ? Colors.red : Colors.green,
                                icon: course.isOpen
                                    ? Icons.lock
                                    : Icons.lock_open,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        CustomButton(
                          text: 'delete_course'.tr,
                          onPressed: () => controller.deleteCourse(course.id),
                          backgroundColor: AppColors.error,
                          icon: Icons.delete,
                          width: double.infinity,
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
}
