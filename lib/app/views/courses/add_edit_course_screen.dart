import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/course_controller.dart';
import '../../data/enums/year_enum.dart';
import '../../theme/app_colors.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/custom_button.dart';

class AddEditCourseScreen extends StatelessWidget {
  const AddEditCourseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CourseController>();
    final isEditing = controller.selectedCourse.value != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'edit_course'.tr : 'add_course'.tr),
      ),
      body: Obx(() {
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
              // Course form
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
                        'course_information'.tr,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      CustomTextField(
                        label: 'course_name'.tr,
                        hint: 'enter_course_name'.tr,
                        icon: Icons.menu_book,
                        controller: controller.nameController,
                        onChanged: (value) => controller.name.value = value,
                        required: true,
                      ),
                      const SizedBox(height: 16),

                      CustomTextField(
                        label: 'course_code'.tr,
                        hint: 'enter_course_code'.tr,
                        icon: Icons.code,
                        controller: controller.courseCodeController,
                        onChanged: (value) => controller.courseCode.value = value,
                        required: true,
                      ),
                      const SizedBox(height: 16),

                      CustomTextField(
                        label: 'teacher'.tr,
                        hint: 'enter_teacher_name'.tr,
                        icon: Icons.person,
                        controller: controller.teacherController,
                        onChanged: (value) => controller.teacher.value = value,
                        required: true,
                      ),
                      const SizedBox(height: 16),

                      CustomTextField(
                        label: 'type'.tr,
                        hint: 'enter_course_type'.tr,
                        icon: Icons.category,
                        controller: controller.typeController,
                        onChanged: (value) => controller.type.value = value,
                        required: true,
                      ),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Text(
                            'year'.tr,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 16),
                          DropdownButton<int>(
                            value: controller.year.value.value,
                            items: List.generate(5, (index) {
                              final year = index + 1;
                              return DropdownMenuItem<int>(
                                value: year,
                                child: Text('year $year'.tr),
                              );
                            }),
                            onChanged: (value) {
                              if (value != null) {
                                controller.year.value = YearEnum.values.firstWhere(
                                      (e) => e.value == value,
                                  orElse: () => YearEnum.FIRST,
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      CustomTextField(
                        label: 'semester'.tr,
                        hint: 'enter_semester'.tr,
                        icon: Icons.calendar_today,
                        controller: controller.semesterController,
                        onChanged: (value) => controller.semester.value = value,
                        required: true,
                      ),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Checkbox(
                            value: controller.isOpen.value,
                            onChanged: (value) {
                              controller.isOpen.value = value ?? false;
                            },
                          ),
                          Text('course_is_open'.tr),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

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
                        'prerequisites'.tr,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      if (controller.prerequisites.isEmpty)
                        Text(
                          'no_prerequisites_added'.tr,
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey,
                          ),
                        )
                      else
                        Column(
                          children: controller.prerequisites.map((prereq) {
                            return ListTile(
                              title: Text(prereq),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => controller.removePrerequisite(prereq),
                              ),
                            );
                          }).toList(),
                        ),

                      const SizedBox(height: 16),

                      Center(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            final TextEditingController prereqController = TextEditingController();

                            Get.dialog(
                              AlertDialog(
                                title: Text('add_prerequisite'.tr),
                                content: TextField(
                                  controller: prereqController,
                                  decoration: InputDecoration(
                                    hintText: 'enter_course_code'.tr,
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Get.back(),
                                    child: Text('cancel'.tr),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      final value = prereqController.text.trim();
                                      if (value.isNotEmpty) {
                                        controller.addPrerequisite(value);
                                        Get.back();
                                      }
                                    },
                                    child: Text('add'.tr),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: const Icon(Icons.add),
                          label: Text('add_prerequisite'.tr),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              CustomButton(
                text: isEditing ? 'update_course'.tr : 'create_course'.tr,
                onPressed: isEditing ? controller.updateCourse : controller.createCourse,
                backgroundColor: AppColors.secondary,
                icon: isEditing ? Icons.save : Icons.add,
                width: double.infinity,
                height: 56,
              ),

              if (isEditing) ...[
                const SizedBox(height: 16),
                CustomButton(
                  text: 'cancel'.tr,
                  onPressed: () => Get.back(),
                  backgroundColor: Colors.grey,
                  width: double.infinity,
                  height: 56,
                ),
              ],
            ],
          ),
        );
      }),
    );
  }
}
