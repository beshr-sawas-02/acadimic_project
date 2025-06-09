import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/student_controller.dart';
import '../../data/enums/year_enum.dart';
import '../../theme/app_colors.dart';
import '../../../widgets/custom_button.dart';

class StudentGpaScreen extends StatelessWidget {
  const StudentGpaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StudentController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('student_gpa'.tr),
      ),
      body: Obx(() {
        final student = controller.selectedStudent.value;

        if (student == null) {
          return Center(
            child: Text('no_student_selected'.tr),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Student info card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
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
                            Text(
                              'ID: ${student.universityId}',
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
                          '${'year'.tr} ${student.year.value}',
                          style: TextStyle(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // GPA Type Selection
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
                        'select_gpa_type'.tr,
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
                              text: 'semester_gpa'.tr,
                              onPressed: () => _showSemesterGpaDialog(context, controller, student.id),
                              backgroundColor: AppColors.secondary,
                              icon: Icons.calendar_today,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: CustomButton(
                              text: 'cumulative_gpa'.tr,
                              onPressed: () => controller.getCumulativeGPA(student.id),
                              backgroundColor: AppColors.primary,
                              textColor: AppColors.tertiary,
                              icon: Icons.assessment,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              if (controller.isLoading.value)
                const Center(child: CircularProgressIndicator())
              else if (controller.gpaResponse.value != null) ...[
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'gpa_results'.tr,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: _getGpaColor(controller.gpaResponse.value!.gpa).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: _getGpaColor(controller.gpaResponse.value!.gpa),
                                  width: 2,
                                ),
                              ),
                              child: Text(
                                controller.gpaResponse.value!.gpa.toStringAsFixed(2),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: _getGpaColor(controller.gpaResponse.value!.gpa),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 32),
                        Text(
                          'grade_details'.tr,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (controller.gpaResponse.value!.details != null) ...[
                          ...controller.gpaResponse.value!.details!.entries.map((entry) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      entry.key,
                                      style: const TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      entry.value.toString(),
                                      style: TextStyle(
                                        color: _getGpaColor(double.parse(entry.value.toString())),
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ] else
                          Text(
                            'no_breakdown'.tr,
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.grey,
                            ),
                          ),
                        const SizedBox(height: 16),
                        Text(
                          _getGpaMessage(controller.gpaResponse.value!.gpa).tr,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: _getGpaColor(controller.gpaResponse.value!.gpa),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ] else
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.assessment, size: 64, color: AppColors.secondary.withOpacity(0.5)),
                      const SizedBox(height: 16),
                      Text(
                        'no_student_selected'.tr,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'select_gpa_to_calculate'.tr,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  void _showSemesterGpaDialog(BuildContext context, StudentController controller, String studentId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('select_semester'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('please_select_year_and_semester'.tr),
            const SizedBox(height: 16),
            Row(
              children: [
                Text('${'year'.tr}:'),
                const SizedBox(width: 16),
                Obx(() {
                  return DropdownButton<int>(
                    value: controller.gpaYear.value.value,
                    items: List.generate(5, (index) {
                      final year = index + 1;
                      return DropdownMenuItem<int>(
                        value: year,
                        child: Text('${'year'.tr} $year'),
                      );
                    }),
                    onChanged: (value) {
                      if (value != null) {
                        controller.gpaYear.value = YearEnum.values.firstWhere(
                              (e) => e.value == value,
                          orElse: () => YearEnum.FIRST,
                        );
                      }
                    },
                  );
                }),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text('${'semester'.tr}:'),
                const SizedBox(width: 16),
                Obx(() {
                  return DropdownButton<int>(
                    value: controller.gpaSemester.value,
                    items: [1, 2].map((semester) {
                      return DropdownMenuItem<int>(
                        value: semester,
                        child: Text('${'semester'.tr} $semester'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        controller.gpaSemester.value = value;
                      }
                    },
                  );
                }),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel'.tr),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              controller.getSemesterGPA(studentId);
            },
            child: Text('calculate'.tr),
          ),
        ],
      ),
    );
  }

  Color _getGpaColor(double gpa) {
    if (gpa >= 3.5) return Colors.green;
    if (gpa >= 2.5) return Colors.blue;
    if (gpa >= 2.0) return Colors.orange;
    return Colors.red;
  }

  String _getGpaMessage(double gpa) {
    if (gpa >= 3.5) return 'excellent_message';
    if (gpa >= 3.0) return 'very_good_message';
    if (gpa >= 2.5) return 'good_message';
    if (gpa >= 2.0) return 'satisfactory_message';
    return 'needs_improvement_message';
  }
}
