import 'package:get/get.dart';
import '../controllers/student_controller.dart';
import '../data/repositories/student_repository.dart';

class StudentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StudentRepository>(() => StudentRepository());
    Get.lazyPut<StudentController>(() => StudentController());
  }
}