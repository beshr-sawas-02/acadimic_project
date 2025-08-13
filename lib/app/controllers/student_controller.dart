import 'package:get/get.dart';
import '../data/models/student_model.dart';
import '../data/repositories/student_repository.dart';
import '../data/enums/year_enum.dart';
import '../utils/dialog_helper.dart';
import '../utils/constants.dart';
import '../routes/app_pages.dart';

class StudentController extends GetxController {
  final StudentRepository _studentRepository = Get.find<StudentRepository>();

  final RxBool isLoading = false.obs;
  final RxList<Student> students = <Student>[].obs;
  final Rx<Student?> selectedStudent = Rx<Student?>(null);
  final Rx<GpaResponse?> gpaResponse = Rx<GpaResponse?>(null);

  // Search parameters
  final RxString searchQuery = ''.obs;

  // Filter parameters
  final Rx<YearEnum?> filterYear = Rx<YearEnum?>(null);

  // GPA parameters
  final Rx<YearEnum> gpaYear = YearEnum.FIRST.obs;
  final RxInt gpaSemester = 1.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllStudents();
  }

  // Fetch all students
  Future<void> fetchAllStudents() async {
    try {
      isLoading.value = true;
      final result = await _studentRepository.getAllStudents();
      students.assignAll(result);
    } catch (e) {
      DialogHelper.showErrorSnackbar(
        title: 'error'.tr,
        message: 'failed_fetch_students'.tr + e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Get student by ID
  Future<void> getStudentById(String id) async {
    try {
      isLoading.value = true;
      final result = await _studentRepository.getStudentById(id);
      selectedStudent.value = result;
    } catch (e) {
      DialogHelper.showErrorSnackbar(
        title: 'error'.tr,
        message: 'failed_get_student'.tr + e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Search students by name
  Future<void> searchStudentsByName() async {
    if (searchQuery.value.isEmpty) {
      fetchAllStudents();
      return;
    }

    try {
      isLoading.value = true;
      final result = await _studentRepository.findStudentsByName(
        searchQuery.value,
      );
      students.assignAll(result);
    } catch (e) {
      DialogHelper.showErrorSnackbar(
        title: 'error'.tr,
        message: 'failed_search_students'.tr + e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Get semester GPA
  Future<void> getSemesterGPA(String studentId) async {
    try {
      isLoading.value = true;
      final result = await _studentRepository.getSemesterGPA(
        studentId,
        gpaYear.value,
        gpaSemester.value,
      );
      gpaResponse.value = result;
    } catch (e) {
      DialogHelper.showErrorSnackbar(
        title: 'error'.tr,
        message: 'failed_get_semester_gpa'.tr + e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Get cumulative GPA
  Future<void> getCumulativeGPA(String studentId) async {
    try {
      isLoading.value = true;
      final result = await _studentRepository.getCumulativeGPA(studentId);
      gpaResponse.value = result;
    } catch (e) {
      DialogHelper.showErrorSnackbar(
        title: 'error'.tr,
        message: 'failed_get_cumulative_gpa'.tr + e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Apply filters
  List<Student> getFilteredStudents() {
    if (filterYear.value == null) {
      return students;
    }

    return students.where((student) {
      if (filterYear.value!.value == 5) {
        return student.year.value >= 5;
      } else {
        return student.year == filterYear.value;
      }
    }).toList();
  }

  // Clear filters
  void clearFilters() {
    filterYear.value = null;
    searchQuery.value = '';
    fetchAllStudents();
  }

  // Delete student
  Future<void> deleteStudent(String id) async {
    DialogHelper.showConfirmDialog(
      title: 'delete_student'.tr,
      message: 'delete_confirmation_message'.tr,
      confirmText: 'delete'.tr,
      cancelText: 'cancel'.tr,
      onConfirm: () async {
        try {
          isLoading.value = true;
          await _studentRepository.deleteStudent(id);

          DialogHelper.showSuccessSnackbar(
            title: 'success'.tr,
            message: AppConstants.deleteSuccess,
          );

          // Refresh students
          fetchAllStudents();

          // Go back if viewing details
          if (selectedStudent.value != null &&
              selectedStudent.value!.id == id) {
            selectedStudent.value = null;
            Get.offAllNamed(Routes.STUDENTS);
          }
        } catch (e) {
          DialogHelper.showErrorSnackbar(
            title: 'error'.tr,
            message: 'failed_to_delete_student'.tr + e.toString(),
          );
        } finally {
          isLoading.value = false;
        }
      },
    );
  }

  // Set selected student
  void setSelectedStudent(Student student) {
    selectedStudent.value = student;
  }
}
