import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/models/mark_model.dart';
import '../data/repositories/mark_repository.dart';
import '../data/enums/mark_status_enum.dart';
import '../utils/dialog_helper.dart';
import '../utils/constants.dart';
import '../routes/app_pages.dart';

class MarkController extends GetxController {
  final MarkRepository _markRepository = Get.find<MarkRepository>();

  final RxBool isLoading = false.obs;
  final RxList<Mark> marks = <Mark>[].obs;
  final Rx<Mark?> selectedMark = Rx<Mark?>(null);

  // Form values
  final RxString courseId = ''.obs;
  final RxString studentId = ''.obs;
  final RxDouble mark = 0.0.obs;
  final RxString type = ''.obs;
  final Rx<MarkStatus> status = MarkStatus.NORMAL.obs;

  // TextEditingControllers for input fields
  final TextEditingController markController = TextEditingController();
  final TextEditingController typeController = TextEditingController();

  // Bulk import form
  final RxList<BulkImportMarkRequest> bulkMarks = <BulkImportMarkRequest>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllMarks();

    // Sync type with TextEditingController only
    ever(type, (_) {
      if (typeController.text != type.value) {
        typeController.text = type.value;
        typeController.selection = TextSelection.fromPosition(
          TextPosition(offset: typeController.text.length),
        );
      }
    });
  }

  Future<void> fetchAllMarks() async {
    try {
      isLoading.value = true;
      final result = await _markRepository.getAllMarks();
      marks.assignAll(result);
    } catch (e) {
      DialogHelper.showErrorSnackbar(
        title: 'Error',
        message: 'Failed to fetch marks: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getMarkById(String id) async {
    try {
      isLoading.value = true;
      final result = await _markRepository.getMarkById(id);
      selectedMark.value = result;

      courseId.value = result.courseId;
      studentId.value = result.studentId;
      mark.value = result.mark;
      type.value = result.type;
      status.value = result.status;
    } catch (e) {
      DialogHelper.showErrorSnackbar(
        title: 'Error',
        message: 'Failed to get mark: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateMark() async {
    if (selectedMark.value == null) {
      DialogHelper.showErrorSnackbar(
        title: 'Error',
        message: 'No mark selected',
      );
      return;
    }

    try {
      isLoading.value = true;

      final parsedMark = double.tryParse(markController.text) ?? 0.0;
      mark.value = parsedMark;

      final updateRequest = UpdateMarkRequest(
        mark: parsedMark != selectedMark.value!.mark ? parsedMark : null,
        type: type.value != selectedMark.value!.type ? type.value : null,
        status: status.value != selectedMark.value!.status ? status.value : null,
      );

      await _markRepository.updateMark(selectedMark.value!.id, updateRequest);

      DialogHelper.showSuccessSnackbar(
        title: 'Success',
        message: AppConstants.updateSuccess,
      );

      fetchAllMarks();
      Get.back();
    } catch (e) {
      DialogHelper.showErrorSnackbar(
        title: 'Error',
        message: 'Failed to update mark: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteMark(String id) async {
    DialogHelper.showConfirmDialog(
      title: 'Delete Mark',
      message: 'Are you sure you want to delete this mark?',
      confirmText: 'Delete',
      cancelText: 'Cancel',
      onConfirm: () async {
        try {
          isLoading.value = true;
          await _markRepository.deleteMark(id);

          DialogHelper.showSuccessSnackbar(
            title: 'Success',
            message: AppConstants.deleteSuccess,
          );

          fetchAllMarks();

          if (selectedMark.value != null && selectedMark.value!.id == id) {
            selectedMark.value = null;
            Get.back();
          }
        } catch (e) {
          DialogHelper.showErrorSnackbar(
            title: 'Error',
            message: 'Failed to delete mark: ${e.toString()}',
          );
        } finally {
          isLoading.value = false;
        }
      },
    );
  }

  BulkImportMarkRequest createBulkImportRequest({
    required String courseId,
    required String studentId,
    required double mark,
    required String type,
  }) {
    return BulkImportMarkRequest(
      courseId: courseId,
      studentId: studentId,
      mark: mark,
      type: type,
    );
  }

  void addMarkToBulkImport() {
    final parsedMark = double.tryParse(markController.text) ?? 0.0;
    mark.value = parsedMark;

    if (courseId.value.isEmpty || studentId.value.isEmpty || parsedMark <= 0 || type.value.isEmpty) {
      DialogHelper.showErrorSnackbar(
        title: 'Error',
        message: 'Please fill all required fields',
      );
      return;
    }

    final bulkMark = BulkImportMarkRequest(
      courseId: courseId.value,
      studentId: studentId.value,
      mark: parsedMark,
      type: type.value,
    );

    bulkMarks.add(bulkMark);

    courseId.value = '';
    studentId.value = '';
    mark.value = 0.0;
    markController.clear();
    type.value = '';
    typeController.clear();

    DialogHelper.showSuccessSnackbar(
      title: 'Success',
      message: 'Mark added to bulk import list',
    );

    Get.back();
  }

  void removeMarkFromBulkImport(int index) {
    bulkMarks.removeAt(index);
  }

  Future<void> submitBulkImport() async {
    if (bulkMarks.isEmpty) {
      DialogHelper.showErrorSnackbar(
        title: 'Error',
        message: 'No marks to import',
      );
      return;
    }

    try {
      isLoading.value = true;
      await _markRepository.bulkImportMarks(bulkMarks);

      DialogHelper.showSuccessSnackbar(
        title: 'Success',
        message: 'Marks imported successfully',
      );

      bulkMarks.clear();
      fetchAllMarks();
      Get.toNamed(Routes.MARKS);
    } catch (e) {
      DialogHelper.showErrorSnackbar(
        title: 'Error',
        message: 'Failed to import marks: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  void resetForm() {
    courseId.value = '';
    studentId.value = '';
    mark.value = 0.0;
    markController.clear();
    type.value = '';
    typeController.clear();
    status.value = MarkStatus.NORMAL;
  }

  void setSelectedMark(Mark mark) {
    selectedMark.value = mark;

    courseId.value = mark.courseId;
    studentId.value = mark.studentId;
    this.mark.value = mark.mark;
    type.value = mark.type;
    status.value = mark.status;

    markController.text = mark.mark.toString();
    typeController.text = mark.type;
  }

  @override
  void onClose() {
    markController.dispose();
    typeController.dispose();
    super.onClose();
  }
}