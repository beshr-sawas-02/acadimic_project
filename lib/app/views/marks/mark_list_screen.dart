import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/mark_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../data/models/mark_model.dart';
import '../../theme/app_colors.dart';
import '../../../widgets/custom_drawer.dart';
import '../../routes/app_pages.dart';
import '../../data/enums/mark_status_enum.dart';

class MarkListScreen extends StatefulWidget {
  const MarkListScreen({Key? key}) : super(key: key);

  @override
  State<MarkListScreen> createState() => _MarkListScreenState();
}

class _MarkListScreenState extends State<MarkListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final RxString _searchQuery = ''.obs;
  final RxString _selectedSortOption = 'name'.obs;
  final RxBool _sortAscending = true.obs;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      _searchQuery.value = _searchController.text;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MarkController>();
    final authController = Get.find<AuthController>();
    final isAdmin = authController.isAdmin;
    final isEmployee = authController.isEmployee;
    final studentId = Get.arguments != null ? Get.arguments['studentId'] as String? : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(studentId != null ? 'student_marks'.tr : 'all_courses'.tr),
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
      body: Column(
        children: [
          // Search and Sort Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              children: [
                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'search_courses_students'.tr,
                      prefixIcon: const Icon(Icons.search),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Obx(() => PopupMenuButton<String>(
                      icon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.sort, size: 16),
                          Icon(_sortAscending.value ? Icons.arrow_upward : Icons.arrow_downward, size: 14),
                        ],
                      ),
                      onSelected: (value) {
                        if (value == _selectedSortOption.value) {
                          _sortAscending.value = !_sortAscending.value;
                        } else {
                          _selectedSortOption.value = value;
                          _sortAscending.value = true;
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'name',
                          child: Row(
                            children: [
                              const Icon(Icons.sort_by_alpha),
                              const SizedBox(width: 8),
                              Text('sort_by_name'.tr),
                              if (_selectedSortOption.value == 'name') ...[
                                const Spacer(),
                                Icon(_sortAscending.value ? Icons.arrow_upward : Icons.arrow_downward, size: 16),
                              ],
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'marks_count',
                          child: Row(
                            children: [
                              const Icon(Icons.numbers),
                              const SizedBox(width: 8),
                              Text('sort_by_marks_count'.tr),
                              if (_selectedSortOption.value == 'marks_count') ...[
                                const Spacer(),
                                Icon(_sortAscending.value ? Icons.arrow_upward : Icons.arrow_downward, size: 16),
                              ],
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'average_mark',
                          child: Row(
                            children: [
                              const Icon(Icons.trending_up),
                              const SizedBox(width: 8),
                              Text('sort_by_average'.tr),
                              if (_selectedSortOption.value == 'average_mark') ...[
                                const Spacer(),
                                Icon(_sortAscending.value ? Icons.arrow_upward : Icons.arrow_downward, size: 16),
                              ],
                            ],
                          ),
                        ),
                      ],
                    )),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final filteredCourses = _getFilteredAndSortedCourses(controller, studentId);

              if (filteredCourses.isEmpty) {
                return _buildEmptyState(isEmployee, isAdmin);
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filteredCourses.length,
                itemBuilder: (context, index) {
                  final course = filteredCourses[index];
                  return _buildCourseCard(context, course, controller, isEmployee, isAdmin);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredAndSortedCourses(MarkController controller, String? studentId) {
    final Map<String, List<Mark>> courseMarksMap = {};
    for (var mark in controller.marks) {
      if (studentId == null || mark.studentId == studentId) {
        courseMarksMap.putIfAbsent(mark.courseId, () => []).add(mark);
      }
    }

    final courses = courseMarksMap.entries.map((entry) {
      final marks = entry.value;
      final courseName = marks.first.courseName ?? '${'course'.tr}: ${entry.key}';
      return {
        'courseId': entry.key,
        'courseName': courseName,
        'marks': marks,
        'averageMark': marks.isNotEmpty ? marks.map((m) => m.mark).reduce((a, b) => a + b) / marks.length : 0.0,
      };
    }).where((course) {
      if (_searchQuery.value.isEmpty) return true;
      final query = _searchQuery.value.toLowerCase();
      final courseName = (course['courseName'] as String).toLowerCase();
      final marks = course['marks'] as List<Mark>;
      final hasMatchingStudent = marks.any((mark) =>
      (mark.studentName?.toLowerCase().contains(query) ?? false) || mark.studentId.toLowerCase().contains(query));
      return courseName.contains(query) || hasMatchingStudent;
    }).toList();

    courses.sort((a, b) {
      int comparison = 0;
      switch (_selectedSortOption.value) {
        case 'name':
          comparison = (a['courseName'] as String).compareTo(b['courseName'] as String);
          break;
        case 'marks_count':
          comparison = (a['marks'] as List<Mark>).length.compareTo((b['marks'] as List<Mark>).length);
          break;
        case 'average_mark':
          comparison = (a['averageMark'] as double).compareTo(b['averageMark'] as double);
          break;
      }
      return _sortAscending.value ? comparison : -comparison;
    });

    return courses;
  }

  Widget _buildEmptyState(bool isEmployee, bool isAdmin) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: AppColors.secondary.withOpacity(0.5)),
          const SizedBox(height: 16),
          Text('no_results_found'.tr, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('try_adjusting_filters'.tr, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 16),
          if (isEmployee || isAdmin)
            ElevatedButton.icon(
              onPressed: () => Get.toNamed(Routes.BULK_IMPORT_MARKS),
              icon: const Icon(Icons.upload_file),
              label: Text('bulk_import_marks'.tr),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondary),
            ),
        ],
      ),
    );
  }

  Widget _buildCourseCard(BuildContext context, Map<String, dynamic> course, MarkController controller, bool isEmployee, bool isAdmin) {
    final courseName = course['courseName'] as String;
    final marks = course['marks'] as List<Mark>;
    final averageMark = course['averageMark'] as double;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => _buildMarksDialog(context, marks, courseName, controller, isEmployee, isAdmin),
          );
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
                  Expanded(child: Text(courseName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                  const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textSecondary),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildInfoChip(Icons.people, '${marks.length} ${'students'.tr}'),
                  const SizedBox(width: 8),
                  _buildInfoChip(Icons.trending_up, '${'avg'.tr}: ${averageMark.toStringAsFixed(1)}'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.secondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.secondary),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 12, color: AppColors.secondary)),
        ],
      ),
    );
  }

  Widget _buildMarksDialog(BuildContext context, List<Mark> marks, String courseName, MarkController controller, bool isEmployee, bool isAdmin) {
    return AlertDialog(
      title: Text('${'marks_for'.tr} $courseName'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: marks.length,
          itemBuilder: (context, index) {
            final mark = marks[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(12),
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
                                mark.studentName ?? '${'student'.tr}: ${mark.studentId}',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text('${'type'.tr}: ${mark.type}', style: TextStyle(color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _getMarkColor(mark.mark).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: _getMarkColor(mark.mark), width: 2),
                          ),
                          child: Text(
                            _formatMark(mark.mark),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: _getMarkColor(mark.mark),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${'status'.tr}: ${_formatStatus(mark.status)}',
                      style: TextStyle(color: _getStatusColor(mark.status), fontWeight: FontWeight.bold),
                    ),
                    if (isEmployee || isAdmin) ...[
                      const Divider(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, size: 20),
                            color: AppColors.secondary,
                            onPressed: () {
                              controller.setSelectedMark(mark);
                              Get.back();
                              Get.toNamed(Routes.ADD_EDIT_MARK);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, size: 20),
                            color: AppColors.error,
                            onPressed: () {
                              controller.deleteMark(mark.id);
                              Get.back();
                            },
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text('close'.tr),
        ),
      ],
    );
  }

  Color _getMarkColor(double mark) {
    if (mark >= 90) return Colors.green;
    if (mark >= 80) return Colors.blue;
    if (mark >= 70) return Colors.amber.shade700;
    if (mark >= 60) return Colors.orange;
    return Colors.red;
  }

  String _formatMark(double mark) => mark.toInt().toString();

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
