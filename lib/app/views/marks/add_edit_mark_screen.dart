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

                      // Course selection with search
                      Text(
                        'course'.tr,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildSearchableDropdown(
                        items: courseController.courses,
                        selectedValue: controller.courseId.value.isEmpty
                            ? null
                            : controller.courseId.value,
                        hint: 'select_course'.tr,
                        searchHint: 'search_course'.tr,
                        onChanged: isEditing
                            ? null
                            : (value) {
                          if (value != null) {
                            controller.courseId.value = value;
                          }
                        },
                        itemBuilder: (course) => '${course.name} (${course.courseCode})',
                        valueExtractor: (course) => course.id,
                        searchFilter: (course, query) =>
                        course.name.toLowerCase().contains(query.toLowerCase()) ||
                            course.courseCode.toLowerCase().contains(query.toLowerCase()),
                      ),
                      const SizedBox(height: 16),

                      // Student selection with search
                      Text(
                        'student'.tr,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildSearchableDropdown(
                        items: studentController.students,
                        selectedValue: controller.studentId.value.isEmpty
                            ? null
                            : controller.studentId.value,
                        hint: 'select_student'.tr,
                        searchHint: 'search_student'.tr,
                        onChanged: isEditing
                            ? null
                            : (value) {
                          if (value != null) {
                            controller.studentId.value = value;
                          }
                        },
                        itemBuilder: (student) => '${student.name} (ID: ${student.universityId})',
                        valueExtractor: (student) => student.id,
                        searchFilter: (student, query) =>
                        student.name.toLowerCase().contains(query.toLowerCase()) ||
                            student.universityId.toString().toLowerCase().contains(query.toLowerCase()),
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

  Widget _buildSearchableDropdown<T>({
    required List<T> items,
    required String? selectedValue,
    required String hint,
    required String searchHint,
    required void Function(String?)? onChanged,
    required String Function(T) itemBuilder,
    required String Function(T) valueExtractor,
    required bool Function(T, String) searchFilter,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onChanged == null ? null : () => _showSearchableDialog<T>(
              items: items,
              selectedValue: selectedValue,
              hint: hint,
              searchHint: searchHint,
              onChanged: onChanged,
              itemBuilder: itemBuilder,
              valueExtractor: valueExtractor,
              searchFilter: searchFilter,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      selectedValue != null && selectedValue.isNotEmpty
                          ? _getSelectedItemText(items, selectedValue, itemBuilder, valueExtractor)
                          : hint,
                      style: TextStyle(
                        color: selectedValue != null && selectedValue.isNotEmpty
                            ? Colors.black
                            : Colors.grey[600],
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: onChanged == null ? Colors.grey : Colors.black54,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getSelectedItemText<T>(
      List<T> items,
      String selectedValue,
      String Function(T) itemBuilder,
      String Function(T) valueExtractor,
      ) {
    try {
      final selectedItem = items.firstWhere(
            (item) => valueExtractor(item) == selectedValue,
      );
      return itemBuilder(selectedItem);
    } catch (e) {
      return selectedValue;
    }
  }

  void _showSearchableDialog<T>({
    required List<T> items,
    required String? selectedValue,
    required String hint,
    required String searchHint,
    required void Function(String?) onChanged,
    required String Function(T) itemBuilder,
    required String Function(T) valueExtractor,
    required bool Function(T, String) searchFilter,
  }) {
    showDialog(
      context: Get.context!,
      builder: (context) => SearchableDialog<T>(
        items: items,
        selectedValue: selectedValue,
        hint: hint,
        searchHint: searchHint,
        onChanged: onChanged,
        itemBuilder: itemBuilder,
        valueExtractor: valueExtractor,
        searchFilter: searchFilter,
      ),
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

class SearchableDialog<T> extends StatefulWidget {
  final List<T> items;
  final String? selectedValue;
  final String hint;
  final String searchHint;
  final void Function(String?) onChanged;
  final String Function(T) itemBuilder;
  final String Function(T) valueExtractor;
  final bool Function(T, String) searchFilter;

  const SearchableDialog({
    Key? key,
    required this.items,
    required this.selectedValue,
    required this.hint,
    required this.searchHint,
    required this.onChanged,
    required this.itemBuilder,
    required this.valueExtractor,
    required this.searchFilter,
  }) : super(key: key);

  @override
  State<SearchableDialog<T>> createState() => _SearchableDialogState<T>();
}

class _SearchableDialogState<T> extends State<SearchableDialog<T>> {
  late TextEditingController _searchController;
  late List<T> _filteredItems;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filteredItems = widget.items;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterItems(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredItems = widget.items;
      } else {
        _filteredItems = widget.items
            .where((item) => widget.searchFilter(item, query))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.6,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              widget.hint,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: widget.searchHint,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: _filterItems,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredItems.length,
                itemBuilder: (context, index) {
                  final item = _filteredItems[index];
                  final value = widget.valueExtractor(item);
                  final isSelected = value == widget.selectedValue;

                  return ListTile(
                    title: Text(widget.itemBuilder(item)),
                    trailing: isSelected
                        ? const Icon(Icons.check, color: Colors.green)
                        : null,
                    selected: isSelected,
                    onTap: () {
                      widget.onChanged(value);
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('cancel'.tr),
              ),
            ),
          ],
        ),
      ),
    );
  }
}