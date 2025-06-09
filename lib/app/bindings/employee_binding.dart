import 'package:get/get.dart';
import '../controllers/employee_controller.dart';
import '../data/repositories/employee_repository.dart';

class EmployeeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmployeeRepository>(() => EmployeeRepository());
    Get.lazyPut<EmployeeController>(() => EmployeeController());
  }
}