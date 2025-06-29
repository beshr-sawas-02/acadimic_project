import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/course_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../data/enums/year_enum.dart';
import '../../theme/app_colors.dart';
import '../../../widgets/custom_drawer.dart';
import '../../routes/app_pages.dart';
import '../../../widgets/custom_button.dart';

class CourseListScreen extends StatelessWidget {
  const CourseListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CourseController>();
    final authController = Get.find<AuthController>();
    final isAdmin = authController.isAdmin;

    return Scaffold(
      appBar: AppBar(
        title: Text('courses'.tr),
        actions: [
          if (isAdmin)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => Get.toNamed(Routes.ADD_EDIT_COURSE),
              tooltip: 'add_course'.tr,
            ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: Column(
        children: [
          // Search and filter section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // 🔹 فلتر السنة (للائحة المعروضة فقط)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Text(
                        'filter_by_year'.tr,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Obx(() {
                        return DropdownButton<int?>(
                          value: controller.filterYear.value?.value,
                          items: [
                            DropdownMenuItem<int?>(
                              value: null,
                              child: Text('all_years'.tr),
                            ),
                            ...List.generate(5, (index) {
                              final year = index + 1;
                              return DropdownMenuItem<int?>(
                                value: year,
                                child: Text('${'year'.tr} $year'),
                              );
                            }),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              controller.filterYear.value =
                              controller.filterYear.value?.value == value
                                  ? null
                                  : YearEnum.values.firstWhere(
                                    (e) => e.value == value,
                                orElse: () => YearEnum.FIRST,
                              );
                            } else {
                              controller.filterYear.value = null;
                            }
                          },
                        );
                      }),
                      const SizedBox(width: 16),
                      Obx(() {
                        return Row(
                          children: [
                            Checkbox(
                              value: controller.filterOpen.value,
                              onChanged: (value) {
                                controller.filterOpen.value = value ?? false;
                              },
                            ),
                            Text('open_courses_only'.tr),
                          ],
                        );
                      }),
                      const SizedBox(width: 16),
                      TextButton.icon(
                        onPressed: controller.clearFilters,
                        icon: const Icon(Icons.clear),
                        label: Text('clear'.tr),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 🔹 خاص بالمشرف: اختيار سنة منفصلة لفتح المقررات (غير مرتبطة بالفلترة)
                if (isAdmin)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.primary),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'admin_actions'.tr,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('open_all_courses_for_year'.tr),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Obx(() {
                              return DropdownButton<int>(
                                value: controller.openYear.value.value,
                                items: List.generate(5, (index) {
                                  final year = index + 1;
                                  return DropdownMenuItem<int>(
                                    value: year,
                                    child: Text('${'year'.tr} $year'),
                                  );
                                }),
                                onChanged: (value) {
                                  if (value != null) {
                                    final selectedYear = YearEnum.values.firstWhere(
                                          (e) => e.value == value,
                                      orElse: () => YearEnum.FIRST,
                                    );
                                    controller.openYear.value = selectedYear;
                                  }
                                },
                              );
                            }),
                            const SizedBox(width: 16),
                            CustomButton(
                              text: 'open_courses'.tr,
                              onPressed: () => controller.openCourseOfYear(controller.openYear.value),
                              backgroundColor: AppColors.secondary,
                              icon: Icons.lock_open,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // Courses list
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final filteredCourses = controller.getFilteredCourses();

              if (filteredCourses.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.menu_book,
                        size: 64,
                        color: AppColors.secondary.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'no_courses_found'.tr,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (isAdmin)
                        CustomButton(
                          text: 'add_course'.tr,
                          onPressed: () => Get.toNamed(Routes.ADD_EDIT_COURSE),
                          backgroundColor: AppColors.secondary,
                          icon: Icons.add,
                        ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filteredCourses.length,
                itemBuilder: (context, index) {
                  final course = filteredCourses[index];

                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      onTap: () {
                        controller.setSelectedCourse(course);
                        Get.toNamed(Routes.COURSE_DETAIL);
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        course.name,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${'code'.tr}: ${course.courseCode}',
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
                                    color: course.isOpen
                                        ? Colors.green.withOpacity(0.1)
                                        : Colors.red.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: course.isOpen
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ),
                                  child: Text(
                                    course.isOpen ? 'open'.tr : 'closed'.tr,
                                    style: TextStyle(
                                      color: course.isOpen
                                          ? Colors.green
                                          : Colors.red,
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
                                  Icons.person,
                                  size: 16,
                                  color: AppColors.textSecondary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${'teacher'.tr}: ${course.teacher}',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Icon(
                                  Icons.school,
                                  size: 16,
                                  color: AppColors.textSecondary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${'year'.tr}: ${course.year.value}',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Icon(
                                  Icons.book,
                                  size: 16,
                                  color: AppColors.textSecondary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${'semester'.tr}: ${course.semester}',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                  ),
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
          ),
        ],
      ),
    );
  }
}
