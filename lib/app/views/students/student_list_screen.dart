import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/student_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../theme/app_colors.dart';
import '../../../widgets/custom_drawer.dart';
import '../../routes/app_pages.dart';
import '../../data/enums/year_enum.dart';

class StudentListScreen extends StatelessWidget {
  const StudentListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StudentController>();
    final authController = Get.find<AuthController>();
    final isAdmin = authController.isAdmin;


    return Scaffold(
      appBar: AppBar(
        title: Text('students_title'.tr),
      ),
      drawer: const CustomDrawer(),
      body: Column(
        children: [
          // Search and filter section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Search bar
                TextField(
                  decoration: InputDecoration(
                    hintText: 'search_by_name'.tr,
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        controller.searchQuery.value = '';
                        controller.fetchAllStudents();
                      },
                    ),
                  ),
                  onChanged: (value) {
                    controller.searchQuery.value = value;
                  },
                  onSubmitted: (value) {
                    controller.searchStudentsByName();
                  },
                ),

                const SizedBox(height: 16),

                // Year filter
                Row(
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
                              child: Text('${'year_label'.tr} $year'),
                            );
                          }),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            controller.filterYear.value = controller.filterYear.value?.value == value
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
                    const Spacer(),
                    TextButton.icon(
                      onPressed: controller.clearFilters,
                      icon: const Icon(Icons.clear),
                      label: Text('clear_filters'.tr),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Students list
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final filteredStudents = controller.getFilteredStudents();

              if (filteredStudents.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.school,
                        size: 64,
                        color: AppColors.secondary.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'no_students_found'.tr,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'adjust_filters'.tr,
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
                itemCount: filteredStudents.length,
                itemBuilder: (context, index) {
                  final student = filteredStudents[index];

                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      onTap: () {
                        controller.setSelectedStudent(student);
                        Get.toNamed(Routes.STUDENT_DETAIL);
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
                                // Student avatar
                                CircleAvatar(
                                  radius: 24,
                                  backgroundColor: AppColors.primary,
                                  child: Text(
                                    student.name.isNotEmpty ? student.name[0].toUpperCase() : 'S',
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
                                        student.name,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.badge,
                                            size: 16,
                                            color: AppColors.textSecondary,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${'id_label'.tr} ${student.universityId}',
                                            style: TextStyle(
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                        ],
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
                                    '${'year_label'.tr} ${student.year.value}',
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
                                  Icons.school,
                                  size: 16,
                                  color: AppColors.textSecondary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${'major_label'.tr} ${student.major}',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                            if (isAdmin) ...[
                              const Divider(height: 24),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton.icon(
                                    icon: const Icon(Icons.calculate),
                                    label: Text('view_gpa'.tr),
                                    onPressed: () {
                                      controller.setSelectedStudent(student);
                                      Get.toNamed(Routes.STUDENT_GPA);
                                    },
                                  ),
                                  const SizedBox(width: 8),
                                  TextButton.icon(
                                    icon: const Icon(Icons.visibility),
                                    label: Text('view_details'.tr),
                                    onPressed: () {
                                      controller.setSelectedStudent(student);
                                      Get.toNamed(Routes.STUDENT_DETAIL);
                                    },
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
          ),
        ],
      ),
    );
  }
}
