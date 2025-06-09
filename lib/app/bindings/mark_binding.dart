import 'package:get/get.dart';
import '../controllers/mark_controller.dart';
import '../data/repositories/mark_repository.dart';

class MarkBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MarkRepository>(() => MarkRepository());
    Get.lazyPut<MarkController>(() => MarkController());
  }
}