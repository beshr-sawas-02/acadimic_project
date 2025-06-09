import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/mark_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../theme/app_colors.dart';
import '../../../widgets/custom_drawer.dart';
import '../../routes/app_pages.dart';
import '../../data/enums/mark_status_enum.dart';

class MarkListScreen extends StatelessWidget {
  const MarkListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MarkController>();
    final authController = Get.find<AuthController>();
    final isAdmin = authController.isAdmin;
    final isEmployee = authController.isEmployee;

    // Check if we have a studentId argument to filter by student
    final studentId = Get.arguments != null ? Get.arguments['studentId'] as String? : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(studentId != null ? 'student_marks'.tr : 'all_marks'.tr),
        actions: [
          if (isEmployee || isAdmin)
            IconButton(
              icon: const Icon(Icons.upload_file),
              onPressed: () => Get.toNamed(Routes.BULK_IMPORT_MARKS),
              tooltip: 'bulk_import'.tr,
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

        // Filter marks if studentId is provided
        final marksToDisplay = studentId != null
            ? controller.marks.where((mark) => mark.studentId == studentId).toList()
            : controller.marks;

        if (marksToDisplay.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.grade,
                  size: 64,
                  color: AppColors.secondary.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'no_marks_found'.tr,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                if (isEmployee || isAdmin) ...[
                  Text(
                    'start_importing'.tr,
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => Get.toNamed(Routes.BULK_IMPORT_MARKS),
                    icon: const Icon(Icons.upload_file),
                    label: Text('bulk_import_marks'.tr),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                    ),
                  ),
                ] else
                  Text(
                    'no_marks_assigned'.tr,
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: marksToDisplay.length,
          itemBuilder: (context, index) {
            final mark = marksToDisplay[index];

            return Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                onTap: () {
                  controller.setSelectedMark(mark);
                  Get.toNamed(Routes.ADD_EDIT_MARK);
                },
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  mark.courseName ?? '${'course'.tr}: ${mark.courseId}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  mark.studentName ?? '${'student'.tr}: ${mark.studentId}',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: _getMarkColor(mark.mark).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: _getMarkColor(mark.mark),
                                width: 2,
                              ),
                            ),
                            child: Text(
                              _formatMark(mark.mark),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: _getMarkColor(mark.mark),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(
                            Icons.category,
                            size: 16,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${'type'.tr}: ${mark.type}',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.info_outline,
                            size: 16,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${'status'.tr}: ${_formatStatus(mark.status)}',
                            style: TextStyle(
                              color: _getStatusColor(mark.status),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      if (isEmployee || isAdmin) ...[
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              color: AppColors.secondary,
                              onPressed: () {
                                controller.setSelectedMark(mark);
                                Get.toNamed(Routes.ADD_EDIT_MARK);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              color: AppColors.error,
                              onPressed: () => controller.deleteMark(mark.id),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: (isEmployee || isAdmin)
          ? FloatingActionButton(
        backgroundColor: AppColors.secondary,
        child: const Icon(Icons.add),
        onPressed: () {
          controller.resetForm();
          Get.toNamed(Routes.ADD_EDIT_MARK);
        },
      )
          : null,
    );
  }

  Color _getMarkColor(double mark) {
    if (mark >= 90) return Colors.green;
    if (mark >= 80) return Colors.blue;
    if (mark >= 70) return Colors.amber.shade700;
    if (mark >= 60) return Colors.orange;
    return Colors.red;
  }

  String _formatMark(double mark) {
    return mark.toInt().toString();
  }

  String _formatStatus(MarkStatus status) {
    switch (status) {
      case MarkStatus.NORMAL:
        return 'normal'.tr;
      case MarkStatus.DEPRIVED:
        return 'deprived'.tr;
      case MarkStatus.WITHDRAW:
        return 'withdrawn'.tr;
      case MarkStatus.PATCHY:
        return 'incomplete'.tr;
      default:
        return 'unknown'.tr;
    }
  }

  Color _getStatusColor(MarkStatus status) {
    switch (status) {
      case MarkStatus.NORMAL:
        return Colors.green;
      case MarkStatus.DEPRIVED:
        return Colors.red;
      case MarkStatus.WITHDRAW:
        return Colors.orange;
      case MarkStatus.PATCHY:
        return Colors.amber.shade700;
      default:
        return Colors.grey;
    }
  }
}
