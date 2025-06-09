import 'package:get/get.dart';
import '../controllers/course_controller.dart';
import '../data/repositories/course_repository.dart';

class CourseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CourseRepository>(() => CourseRepository());
    Get.lazyPut<CourseController>(() => CourseController());
  }
}