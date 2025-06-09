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
        title: 'Error',
        message: 'Failed to fetch students: ${e.toString()}',
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
        title: 'Error',
        message: 'Failed to get student: ${e.toString()}',
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
      final result = await _studentRepository.findStudentsByName(searchQuery.value);
      students.assignAll(result);
    } catch (e) {
      DialogHelper.showErrorSnackbar(
        title: 'Error',
        message: 'Failed to search students: ${e.toString()}',
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
        title: 'Error',
        message: 'Failed to get semester GPA: ${e.toString()}',
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
        title: 'Error',
        message: 'Failed to get cumulative GPA: ${e.toString()}',
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

    return students.where((student) => student.year == filterYear.value).toList();
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
      title: 'Delete Student',
      message: 'Are you sure you want to delete this student? This action cannot be undone.',
      confirmText: 'Delete',
      cancelText: 'Cancel',
      onConfirm: () async {
        try {
          isLoading.value = true;
          await _studentRepository.deleteStudent(id);

          DialogHelper.showSuccessSnackbar(
            title: 'Success',
            message: AppConstants.deleteSuccess,
          );

          // Refresh students
          fetchAllStudents();

          // Go back if viewing details
          if (selectedStudent.value != null && selectedStudent.value!.id == id) {
            selectedStudent.value = null;
            Get.offAllNamed(Routes.STUDENTS);
          }
        } catch (e) {
          DialogHelper.showErrorSnackbar(
            title: 'Error',
            message: 'Failed to delete student: ${e.toString()}',
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