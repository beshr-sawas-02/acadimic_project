import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import '../../controllers/mark_controller.dart';
import '../../theme/app_colors.dart';
import '../../../widgets/custom_button.dart';
import '../../utils/dialog_helper.dart';

class BulkImportScreen extends StatelessWidget {
  const BulkImportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MarkController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('bulk_import_marks'.tr),
      ),
      body: Obx(() {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Instructions card
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
                        'instructions'.tr,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'import_instructions_1'.tr,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('import_instructions_2'.tr),
                      const SizedBox(height: 4),
                      Text('import_instructions_3'.tr),
                      const SizedBox(height: 16),
                      CustomButton(
                        text: 'upload_csv_file'.tr,
                        onPressed: _uploadFile,
                        backgroundColor: AppColors.secondary,
                        icon: Icons.upload_file,
                        width: double.infinity,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Manually added marks
              Expanded(
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'marks_to_import'.tr,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () => Get.toNamed('/add-edit-mark'),
                              icon: const Icon(Icons.add),
                              label: Text('add_mark'.tr),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        if (controller.bulkMarks.isEmpty)
                          Expanded(
                            child: Center(
                              child: Text(
                                'no_marks_added_yet'.tr,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          )
                        else
                          Expanded(
                            child: ListView.builder(
                              itemCount: controller.bulkMarks.length,
                              itemBuilder: (context, index) {
                                final mark = controller.bulkMarks[index];

                                return ListTile(
                                  title: Text('Course ID: ${mark.courseId}'),
                                  subtitle: Text('Student ID: ${mark.studentId}'),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _getMarkColor(mark.mark).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                            color: _getMarkColor(mark.mark),
                                          ),
                                        ),
                                        child: Text(
                                          '${'mark'.tr}: ${mark.mark}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: _getMarkColor(mark.mark),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                        onPressed: () => controller.removeMarkFromBulkImport(index),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Submit button
              CustomButton(
                text: 'import_all_marks'.tr,
                onPressed: controller.bulkMarks.isEmpty ? null : controller.submitBulkImport,
                backgroundColor: AppColors.secondary,
                icon: Icons.send,
                width: double.infinity,
                height: 56,
                isLoading: controller.isLoading.value,
              ),
            ],
          ),
        );
      }),
    );
  }

  Future<void> _uploadFile() async {
    final controller = Get.find<MarkController>();

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result != null) {
        PlatformFile file = result.files.first;

        // Read file content safely
        String? fileContent;
        if (file.bytes != null) {
          // For platforms where bytes are available (e.g., mobile)
          fileContent = utf8.decode(file.bytes!);
        } else if (file.path != null) {
          // For platforms where path is available (e.g., desktop)
          fileContent = await File(file.path!).readAsString();
        }

        if (fileContent == null) {
          throw Exception('Unable to read file content');
        }

        final List<String> lines = LineSplitter.split(fileContent).toList();

        // Skip header row if it exists
        const startIndex = 1;

        for (int i = startIndex; i < lines.length; i++) {
          final List<String> values = lines[i].split(',');

          if (values.length >= 4) {
            final studentId = values[0].trim();
            final courseId = values[1].trim();
            final mark = double.tryParse(values[2].trim()) ?? 0.0;
            final type = values[3].trim();

            controller.bulkMarks.add(
              controller.createBulkImportRequest(
                courseId: courseId,
                studentId: studentId,
                mark: mark,
                type: type,
              ),
            );
          }
        }

        DialogHelper.showSuccessSnackbar(
          title: 'success'.tr,
          message: 'file_uploaded_successfully'.trParams({'%s': controller.bulkMarks.length.toString()}),
        );
      }
    } catch (e) {
      DialogHelper.showErrorSnackbar(
        title: 'error'.tr,
        message: e.toString(),
      );
    }
  }
  Color _getMarkColor(double mark) {
    if (mark >= 90) return Colors.green;
    if (mark >= 80) return Colors.blue;
    if (mark >= 70) return Colors.amber.shade700;
    if (mark >= 60) return Colors.orange;
    return Colors.red;
  }
}
