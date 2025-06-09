import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/mark_controller.dart';
import '../../theme/app_colors.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/custom_button.dart';
import '../../data/enums/mark_status_enum.dart';
import '../../controllers/course_controller.dart';
import '../../controllers/student_controller.dart';

class AddEditMarkScreen extends StatelessWidget {
  const AddEditMarkScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MarkController>();
    final courseController = Get.find<CourseController>();
    final studentController = Get.find<StudentController>();

    final isEditing = controller.selectedMark.value != null;

    // Ensure courses and students are loaded
    if (courseController.courses.isEmpty) {
      courseController.fetchAllCourses();
    }

    if (studentController.students.isEmpty) {
      studentController.fetchAllStudents();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'edit_mark'.tr : 'add_mark'.tr),
      ),
      body: Obx(() {
        if (controller.isLoading.value ||
            courseController.isLoading.value ||
            studentController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                        'mark_information'.tr,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Course selection
                      Text(
                        'course'.tr,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: controller.courseId.value.isEmpty
                                ? null
                                : controller.courseId.value,
                            hint: Text('select_course'.tr),
                            items: courseController.courses.map((course) {
                              return DropdownMenuItem<String>(
                                value: course.id,
                                child: Text('${course.name} (${course.courseCode})'),
                              );
                            }).toList(),
                            onChanged: isEditing
                                ? null
                                : (value) {
                              if (value != null) {
                                controller.courseId.value = value;
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Student selection
                      Text(
                        'student'.tr,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: controller.studentId.value.isEmpty
                                ? null
                                : controller.studentId.value,
                            hint: Text('select_student'.tr),
                            items: studentController.students.map((student) {
                              return DropdownMenuItem<String>(
                                value: student.id,
                                child: Text('${student.name} (ID: ${student.universityId})'),
                              );
                            }).toList(),
                            onChanged: isEditing
                                ? null
                                : (value) {
                              if (value != null) {
                                controller.studentId.value = value;
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Mark & Type inputs
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: CustomTextField(
                              label: 'mark'.tr,
                              hint: 'enter_mark_hint'.tr,
                              icon: Icons.grade,
                              keyboardType: TextInputType.number,
                              controller:
                              controller.markController,
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  try {
                                    controller.mark.value = double.parse(value);
                                  } catch (e) {
                                    // Ignore invalid number input
                                  }
                                }
                              },
                              required: true,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 3,
                            child: CustomTextField(
                              label: 'type'.tr,
                              hint: 'type_hint'.tr,
                              icon: Icons.category,
                              controller: controller.typeController,
                              onChanged: (value) => controller.type.value = value,
                              required: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Status dropdown
                      Text(
                        'status'.tr,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<MarkStatus>(
                            isExpanded: true,
                            value: controller.status.value,
                            items: MarkStatus.values.map((status) {
                              return DropdownMenuItem<MarkStatus>(
                                value: status,
                                child: Text(_formatStatus(status)),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                controller.status.value = value;
                              }
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      CustomButton(
                        text: isEditing ? 'update_mark'.tr : 'save_mark'.tr,
                        onPressed: isEditing ? controller.updateMark : _addMarkToBulkImport,
                        backgroundColor: AppColors.secondary,
                        icon: isEditing ? Icons.save : Icons.add,
                        width: double.infinity,
                        height: 56,
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

  void _addMarkToBulkImport() {
    final controller = Get.find<MarkController>();
    controller.addMarkToBulkImport();
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
}
