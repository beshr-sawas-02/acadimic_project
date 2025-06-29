import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/models/course_model.dart';
import '../data/repositories/course_repository.dart';
import '../data/enums/year_enum.dart';
import '../utils/dialog_helper.dart';
import '../utils/constants.dart';

class CourseController extends GetxController {
  final CourseRepository _courseRepository = Get.find<CourseRepository>();

  final RxBool isLoading = false.obs;
  final RxList<Course> courses = <Course>[].obs;
  final Rx<Course?> selectedCourse = Rx<Course?>(null);

  // Form values
  final RxString name = ''.obs;
  final RxString teacher = ''.obs;
  final RxString type = ''.obs;
  final Rx<YearEnum> year = YearEnum.FIRST.obs;
  final RxString semester = ''.obs;
  final RxString courseCode = ''.obs;
  final RxList<String> prerequisites = <String>[].obs;
  final RxBool isOpen = false.obs;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController teacherController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController semesterController = TextEditingController();
  final TextEditingController courseCodeController = TextEditingController();

  // Filter values
  final Rx<YearEnum?> filterYear = Rx<YearEnum?>(null);
  final RxBool filterOpen = false.obs;

  // Open year for open course actions (independent)
  final Rx<YearEnum> openYear = YearEnum.FIRST.obs;

  @override
  void onInit() {
    super.onInit();

    nameController.text = name.value;
    teacherController.text = teacher.value;
    typeController.text = type.value;
    semesterController.text = semester.value;
    courseCodeController.text = courseCode.value;

    nameController.addListener(() => name.value = nameController.text);
    teacherController.addListener(() => teacher.value = teacherController.text);
    typeController.addListener(() => type.value = typeController.text);
    semesterController.addListener(() => semester.value = semesterController.text);
    courseCodeController.addListener(() => courseCode.value = courseCodeController.text);

    fetchAllCourses();
  }

  @override
  void onClose() {
    nameController.dispose();
    teacherController.dispose();
    typeController.dispose();
    semesterController.dispose();
    courseCodeController.dispose();
    super.onClose();
  }

  Future<void> fetchAllCourses() async {
    try {
      isLoading.value = true;
      final result = await _courseRepository.getAllCourses();
      courses.assignAll(result);
    } catch (e) {
      DialogHelper.showErrorSnackbar(
        title: 'Error'.tr,
        message: '${'Failed to fetch courses:'.tr} ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getCourseById(String id) async {
    try {
      isLoading.value = true;
      final result = await _courseRepository.getCourseById(id);
      setSelectedCourse(result);
    } catch (e) {
      DialogHelper.showErrorSnackbar(
        title: 'Error'.tr,
        message: '${'Failed to get course:'.tr} ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<Course>> getCoursePrerequisites(String courseCode) async {
    try {
      isLoading.value = true;
      final result = await _courseRepository.getCoursePrerequisites(courseCode);
      return result;
    } catch (e) {
      DialogHelper.showErrorSnackbar(
        title: 'Error'.tr,
        message: '${'Failed to get prerequisites:'.tr} ${e.toString()}',
      );
      return [];
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getOpenCoursesByYear(YearEnum year) async {
    try {
      isLoading.value = true;
      final result = await _courseRepository.getAllOpenCoursesByYear(year);
      courses.assignAll(result);
    } catch (e) {
      DialogHelper.showErrorSnackbar(
        title: 'Error'.tr,
        message: '${'Failed to get open courses:'.tr} ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> openCourseOfYear(YearEnum year) async {
    try {
      isLoading.value = true;
      final result = await _courseRepository.openCourseOfYear(year);

      DialogHelper.showSuccessSnackbar(
        title: 'Success'.tr,
        message: result,
      );

      fetchAllCourses();
    } catch (e) {
      DialogHelper.showErrorSnackbar(
        title: 'Error'.tr,
        message: '${'Failed to open courses:'.tr} ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createCourse() async {
    if (name.value.isEmpty ||
        teacher.value.isEmpty ||
        type.value.isEmpty ||
        semester.value.isEmpty ||
        courseCode.value.isEmpty) {
      DialogHelper.showErrorSnackbar(
        title: 'Error'.tr,
        message: 'Please fill all required fields'.tr,
      );
      return;
    }

    try {
      isLoading.value = true;

      final createRequest = CreateCourseRequest(
        name: name.value,
        teacher: teacher.value,
        type: type.value,
        year: year.value,
        semester: semester.value,
        courseCode: courseCode.value,
        prerequisites: prerequisites.toList(),
      );

      await _courseRepository.createCourse(createRequest);

      DialogHelper.showSuccessSnackbar(
        title: 'Success'.tr,
        message: AppConstants.createSuccess,
      );

      resetForm();
      fetchAllCourses();
      Get.back();
    } catch (e) {
      DialogHelper.showErrorSnackbar(
        title: 'Error'.tr,
        message: '${'Failed to create course:'.tr} ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateCourse() async {
    if (selectedCourse.value == null) {
      DialogHelper.showErrorSnackbar(
        title: 'Error'.tr,
        message: 'No course selected'.tr,
      );
      return;
    }

    try {
      isLoading.value = true;

      final updateRequest = UpdateCourseRequest(
        name: name.value != selectedCourse.value!.name ? name.value : null,
        teacher: teacher.value != selectedCourse.value!.teacher ? teacher.value : null,
        type: type.value != selectedCourse.value!.type ? type.value : null,
        year: year.value != selectedCourse.value!.year ? year.value : null,
        semester: semester.value != selectedCourse.value!.semester ? semester.value : null,
        courseCode: courseCode.value != selectedCourse.value!.courseCode ? courseCode.value : null,
        prerequisites: prerequisites,
        isOpen: isOpen.value != selectedCourse.value!.isOpen ? isOpen.value : null,
      );

      await _courseRepository.updateCourse(selectedCourse.value!.id, updateRequest);

      DialogHelper.showSuccessSnackbar(
        title: 'Success'.tr,
        message: AppConstants.updateSuccess,
      );

      fetchAllCourses();
      Get.back();
    } catch (e) {
      DialogHelper.showErrorSnackbar(
        title: 'Error'.tr,
        message: '${'Failed to update course:'.tr} ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteCourse(String id) async {
    DialogHelper.showConfirmDialog(
      title: 'Delete Course'.tr,
      message: 'Are you sure you want to delete this course?'.tr,
      confirmText: 'Delete'.tr,
      cancelText: 'cancel'.tr,
      onConfirm: () async {
        try {
          isLoading.value = true;
          await _courseRepository.deleteCourse(id);

          DialogHelper.showSuccessSnackbar(
            title: 'Success'.tr,
            message: AppConstants.deleteSuccess,
          );

          fetchAllCourses();

          if (selectedCourse.value != null && selectedCourse.value!.id == id) {
            selectedCourse.value = null;
            Get.back();
          }
        } catch (e) {
          DialogHelper.showErrorSnackbar(
            title: 'Error'.tr,
            message: '${'Failed to delete course:'.tr} ${e.toString()}',
          );
        } finally {
          isLoading.value = false;
        }
      },
    );
  }

  void resetForm() {
    name.value = '';
    teacher.value = '';
    type.value = '';
    year.value = YearEnum.FIRST;
    semester.value = '';
    courseCode.value = '';
    prerequisites.clear();
    isOpen.value = false;

    nameController.clear();
    teacherController.clear();
    typeController.clear();
    semesterController.clear();
    courseCodeController.clear();
  }

  void setSelectedCourse(Course course) {
    selectedCourse.value = course;

    name.value = course.name;
    teacher.value = course.teacher;
    type.value = course.type;
    year.value = course.year;
    semester.value = course.semester;
    courseCode.value = course.courseCode;
    prerequisites.assignAll(course.prerequisites ?? []);
    isOpen.value = course.isOpen;

    nameController.text = course.name;
    teacherController.text = course.teacher;
    typeController.text = course.type;
    semesterController.text = course.semester;
    courseCodeController.text = course.courseCode;
  }

  List<Course> getFilteredCourses() {
    if (filterYear.value == null && !filterOpen.value) {
      return courses;
    }

    return courses.where((course) {
      if (filterYear.value != null && course.year != filterYear.value) {
        return false;
      }

      if (filterOpen.value && !course.isOpen) {
        return false;
      }

      return true;
    }).toList();
  }

  void clearFilters() {
    filterYear.value = null;
    filterOpen.value = false;
  }

  void addPrerequisite(String courseId) {
    if (!prerequisites.contains(courseId)) {
      prerequisites.add(courseId);
    }
  }

  void removePrerequisite(String courseId) {
    prerequisites.remove(courseId);
  }
}
