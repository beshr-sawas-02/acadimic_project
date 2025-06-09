import 'package:get/get.dart';
import '../controllers/vote_controller.dart';
import '../data/repositories/vote_repository.dart';

class VoteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VoteRepository>(() => VoteRepository());
    Get.lazyPut<VoteController>(() => VoteController());
  }
}