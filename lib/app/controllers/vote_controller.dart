// import 'package:get/get.dart';
// import '../data/models/vote_model.dart';
// import '../data/repositories/vote_repository.dart';
// import '../utils/dialog_helper.dart';
// import '../utils/constants.dart';
//
// class VoteController extends GetxController {
//   final VoteRepository _voteRepository = Get.find<VoteRepository>();
//
//   final RxBool isLoading = false.obs;
//   final RxList<Vote> votes = <Vote>[].obs;
//   final Rx<Vote?> selectedVote = Rx<Vote?>(null);
//
//   // Voting management
//   final RxString courseId = ''.obs;
//   final Rx<DateTime> startDate = DateTime.now().obs;
//   final Rx<DateTime> endDate = DateTime.now().add(const Duration(days: 14)).obs;
//
//   // Course votes parameters
//   final RxList<Vote> courseVotes = <Vote>[].obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchAllVotes();
//   }
//
//   // Fetch all votes
//   Future<void> fetchAllVotes() async {
//     try {
//       isLoading.value = true;
//       final result = await _voteRepository.getAllVotes();
//       votes.assignAll(result);
//     } catch (e) {
//       DialogHelper.showErrorSnackbar(
//         title: 'Error',
//         message: 'Failed to fetch votes: ${e.toString()}',
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // Get vote by ID
//   Future<void> getVoteById(String id) async {
//     try {
//       isLoading.value = true;
//       final result = await _voteRepository.getVoteById(id);
//       selectedVote.value = result;
//     } catch (e) {
//       DialogHelper.showErrorSnackbar(
//         title: 'Error',
//         message: 'Failed to get vote: ${e.toString()}',
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // Get course votes
//   Future<void> getCourseVotes() async {
//     if (courseId.value.isEmpty) {
//       DialogHelper.showErrorSnackbar(
//         title: 'Error',
//         message: 'Please select a course',
//       );
//       return;
//     }
//
//     try {
//       isLoading.value = true;
//
//       final params = CourseVotesParams(
//         courseId: courseId.value,
//         startDate: startDate.value,
//         endDate: endDate.value,
//       );
//
//       final result = await _voteRepository.getCourseVotes(params);
//       courseVotes.assignAll(result);
//     } catch (e) {
//       DialogHelper.showErrorSnackbar(
//         title: 'Error',
//         message: 'Failed to get course votes: ${e.toString()}',
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // Open voting
//   Future<void> openVoting() async {
//     print('openVoting called');
//     if (courseId.value.isEmpty) {
//       DialogHelper.showErrorSnackbar(
//         title: 'Error',
//         message: 'Please select a course',
//       );
//       return;
//     }
//
//     try {
//       isLoading.value = true;
//
//       final result = await _voteRepository.openVoting(
//         courseId.value,
//         startDate.value,
//         endDate.value,
//       );
//
//       DialogHelper.showSuccessSnackbar(
//         title: 'Success',
//         message: result,
//       );
//     } catch (e) {
//       DialogHelper.showErrorSnackbar(
//         title: 'Error',
//         message: 'Failed to open voting: ${e.toString()}',
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // Close voting
//   Future<void> closeVoting() async {
//     print('closeVoting called');
//     if (courseId.value.isEmpty) {
//       DialogHelper.showErrorSnackbar(
//         title: 'Error',
//         message: 'Please select a course',
//       );
//       return;
//     }
//
//     try {
//       isLoading.value = true;
//
//       final result = await _voteRepository.closeVoting(courseId.value);
//
//       DialogHelper.showSuccessSnackbar(
//         title: 'Success',
//         message: result,
//       );
//     } catch (e) {
//       DialogHelper.showErrorSnackbar(
//         title: 'Error',
//         message: 'Failed to close voting: ${e.toString()}',
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // Set selected vote
//   void setSelectedVote(Vote vote) {
//     selectedVote.value = vote;
//   }
//
//   // Reset voting management form
//   void resetVotingManagementForm() {
//     courseId.value = '';
//     startDate.value = DateTime.now();
//     endDate.value = DateTime.now().add(const Duration(days: 14));
//   }
// }
// import 'package:get/get.dart';
// import '../data/models/vote_model.dart';
// import '../data/repositories/vote_repository.dart';
// import '../utils/dialog_helper.dart';
// import '../utils/constants.dart';
//
// class VoteController extends GetxController {
//   final VoteRepository _voteRepository = Get.find<VoteRepository>();
//
//   final RxBool isLoading = false.obs;
//   final RxList<Vote> votes = <Vote>[].obs;
//   final Rx<Vote?> selectedVote = Rx<Vote?>(null);
//
//   // Voting management
//   final RxString courseId = ''.obs;
//   final Rx<DateTime> startDate = DateTime.now().obs;
//   final Rx<DateTime> endDate = DateTime.now().add(const Duration(days: 14)).obs;
//
//   // Course votes parameters
//   final RxList<Vote> courseVotes = <Vote>[].obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchAllVotes();
//   }
//
//   // Fetch all votes
//   Future<void> fetchAllVotes() async {
//     try {
//       isLoading.value = true;
//       final result = await _voteRepository.getAllVotes();
//       votes.assignAll(result);
//     } catch (e) {
//       DialogHelper.showErrorSnackbar(
//         title: 'error'.tr,
//         message: '${'failed_to_fetch_votes'.tr}: ${e.toString()}',
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // Get vote by ID
//   Future<void> getVoteById(String id) async {
//     try {
//       isLoading.value = true;
//       final result = await _voteRepository.getVoteById(id);
//       selectedVote.value = result;
//     } catch (e) {
//       DialogHelper.showErrorSnackbar(
//         title: 'error'.tr,
//         message: '${'failed_to_get_vote'.tr}: ${e.toString()}',
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // Get course votes
//   Future<void> getCourseVotes() async {
//     if (courseId.value.isEmpty) {
//       DialogHelper.showErrorSnackbar(
//         title: 'error'.tr,
//         message: 'please_select_course'.tr,
//       );
//       return;
//     }
//
//     try {
//       isLoading.value = true;
//
//       final params = CourseVotesParams(
//         courseId: courseId.value,
//         startDate: startDate.value,
//         endDate: endDate.value,
//       );
//
//       final result = await _voteRepository.getCourseVotes(params);
//       courseVotes.assignAll(result);
//     } catch (e) {
//       DialogHelper.showErrorSnackbar(
//         title: 'error'.tr,
//         message: '${'failed_to_get_course_votes'.tr}: ${e.toString()}',
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // Open voting
//   Future<void> openVoting() async {
//     if (courseId.value.isEmpty) {
//       DialogHelper.showErrorSnackbar(
//         title: 'error'.tr,
//         message: 'please_select_course'.tr,
//       );
//       return;
//     }
//
//     try {
//       isLoading.value = true;
//
//       final result = await _voteRepository.openVoting(
//         courseId.value,
//         startDate.value,
//         endDate.value,
//       );
//
//       DialogHelper.showSuccessSnackbar(
//         title: 'success'.tr,
//         message: result,
//       );
//     } catch (e) {
//       DialogHelper.showErrorSnackbar(
//         title: 'error'.tr,
//         message: '${'failed_to_open_voting'.tr}: ${e.toString()}',
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // Close voting
//   Future<void> closeVoting() async {
//     if (courseId.value.isEmpty) {
//       DialogHelper.showErrorSnackbar(
//         title: 'error'.tr,
//         message: 'please_select_course'.tr,
//       );
//       return;
//     }
//
//     try {
//       isLoading.value = true;
//
//       final result = await _voteRepository.closeVoting(courseId.value);
//
//       DialogHelper.showSuccessSnackbar(
//         title: 'success'.tr,
//         message: result,
//       );
//     } catch (e) {
//       DialogHelper.showErrorSnackbar(
//         title: 'error'.tr,
//         message: '${'failed_to_close_voting'.tr}: ${e.toString()}',
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // Set selected vote
//   void setSelectedVote(Vote vote) {
//     selectedVote.value = vote;
//   }
//
//   // Reset voting management form
//   void resetVotingManagementForm() {
//     courseId.value = '';
//     startDate.value = DateTime.now();
//     endDate.value = DateTime.now().add(const Duration(days: 14));
//   }
// }

// import 'package:get/get.dart';
// import '../data/models/vote_model.dart';
// import '../data/repositories/vote_repository.dart';
// import '../utils/dialog_helper.dart';
// import '../utils/constants.dart';
//
// class VoteController extends GetxController {
//   final VoteRepository _voteRepository = Get.find<VoteRepository>();
//
//   final RxBool isLoading = false.obs;
//   final RxList<Vote> votes = <Vote>[].obs;
//   final Rx<Vote?> selectedVote = Rx<Vote?>(null);
//
//   // Voting management
//   final RxString courseId = ''.obs;
//   final Rx<DateTime> startDate = DateTime.now().obs;
//   final Rx<DateTime> endDate = DateTime.now().add(const Duration(days: 14)).obs;
//
//   // Course votes parameters
//   final RxList<Vote> courseVotes = <Vote>[].obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchAllVotes();
//   }
//
//   // Fetch all votes
//   Future<void> fetchAllVotes() async {
//     try {
//       isLoading.value = true;
//       final result = await _voteRepository.getAllVotes();
//       votes.assignAll(result);
//     } catch (e) {
//       DialogHelper.showErrorSnackbar(
//         title: 'Error',
//         message: 'Failed to fetch votes: ${e.toString()}',
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // Get vote by ID
//   Future<void> getVoteById(String id) async {
//     try {
//       isLoading.value = true;
//       final result = await _voteRepository.getVoteById(id);
//       selectedVote.value = result;
//     } catch (e) {
//       DialogHelper.showErrorSnackbar(
//         title: 'Error',
//         message: 'Failed to get vote: ${e.toString()}',
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // Get course votes
//   Future<void> getCourseVotes() async {
//     if (courseId.value.isEmpty) {
//       DialogHelper.showErrorSnackbar(
//         title: 'Error',
//         message: 'Please select a course',
//       );
//       return;
//     }
//
//     try {
//       isLoading.value = true;
//
//       final params = CourseVotesParams(
//         courseId: courseId.value,
//         startDate: startDate.value,
//         endDate: endDate.value,
//       );
//
//       final result = await _voteRepository.getCourseVotes(params);
//       courseVotes.assignAll(result);
//     } catch (e) {
//       DialogHelper.showErrorSnackbar(
//         title: 'Error',
//         message: 'Failed to get course votes: ${e.toString()}',
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // Open voting
//   Future<void> openVoting() async {
//     print('openVoting called');
//     if (courseId.value.isEmpty) {
//       DialogHelper.showErrorSnackbar(
//         title: 'Error',
//         message: 'Please select a course',
//       );
//       return;
//     }
//
//     try {
//       isLoading.value = true;
//
//       final result = await _voteRepository.openVoting(
//         courseId.value,
//         startDate.value,
//         endDate.value,
//       );
//
//       DialogHelper.showSuccessSnackbar(
//         title: 'Success',
//         message: result,
//       );
//     } catch (e) {
//       DialogHelper.showErrorSnackbar(
//         title: 'Error',
//         message: 'Failed to open voting: ${e.toString()}',
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // Close voting
//   Future<void> closeVoting() async {
//     print('closeVoting called');
//     if (courseId.value.isEmpty) {
//       DialogHelper.showErrorSnackbar(
//         title: 'Error',
//         message: 'Please select a course',
//       );
//       return;
//     }
//
//     try {
//       isLoading.value = true;
//
//       final result = await _voteRepository.closeVoting(courseId.value);
//
//       DialogHelper.showSuccessSnackbar(
//         title: 'Success',
//         message: result,
//       );
//     } catch (e) {
//       DialogHelper.showErrorSnackbar(
//         title: 'Error',
//         message: 'Failed to close voting: ${e.toString()}',
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // Set selected vote
//   void setSelectedVote(Vote vote) {
//     selectedVote.value = vote;
//   }
//
//   // Reset voting management form
//   void resetVotingManagementForm() {
//     courseId.value = '';
//     startDate.value = DateTime.now();
//     endDate.value = DateTime.now().add(const Duration(days: 14));
//   }
// }
import 'package:get/get.dart';
import '../data/models/vote_model.dart';
import '../data/repositories/vote_repository.dart';
import '../utils/dialog_helper.dart';

class VoteController extends GetxController {
  final VoteRepository _voteRepository = Get.find<VoteRepository>();

  final RxBool isLoading = false.obs;
  final RxList<Vote> votes = <Vote>[].obs;
  final Rx<Vote?> selectedVote = Rx<Vote?>(null);

  // بدل courseId مفرد => قائمة مواد مختارة
  final RxList<String> selectedCourseIds = <String>[].obs;

  final Rx<DateTime> startDate = DateTime.now().obs;
  final Rx<DateTime> endDate = DateTime.now().add(const Duration(days: 14)).obs;

  final RxList<Vote> courseVotes = <Vote>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllVotes();
  }

  Future<void> fetchAllVotes() async {
    try {
      isLoading.value = true;
      final result = await _voteRepository.getAllVotes();
      votes.assignAll(result);
    } catch (e) {
      DialogHelper.showErrorSnackbar(
        title: 'error'.tr,
        message: '${'failed_to_fetch_votes'.tr}: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getVoteById(String id) async {
    try {
      isLoading.value = true;
      final result = await _voteRepository.getVoteById(id);
      selectedVote.value = result;
    } catch (e) {
      DialogHelper.showErrorSnackbar(
        title: 'error'.tr,
        message: '${'failed_to_get_vote'.tr}: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getCourseVotes() async {
    if (selectedCourseIds.isEmpty) {
      DialogHelper.showErrorSnackbar(
        title: 'error'.tr,
        message: 'please_select_course'.tr,
      );
      return;
    }

    try {
      isLoading.value = true;

      List<Vote> allVotes = [];

      for (var courseId in selectedCourseIds) {
        final params = CourseVotesParams(
          courseId: courseId,
          startDate: startDate.value,
          endDate: endDate.value,
        );

        final result = await _voteRepository.getCourseVotes(params);
        allVotes.addAll(result);
      }

      courseVotes.assignAll(allVotes);
    } catch (e) {
      DialogHelper.showErrorSnackbar(
        title: 'error'.tr,
        message: '${'failed_to_get_course_votes'.tr}: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> openVoting() async {
    if (selectedCourseIds.isEmpty) {
      DialogHelper.showErrorSnackbar(
        title: 'error'.tr,
        message: 'please_select_course'.tr,
      );
      return;
    }

    try {
      isLoading.value = true;

      for (var courseId in selectedCourseIds) {
        final result = await _voteRepository.openVoting(
          courseId,
          startDate.value,
          endDate.value,
        );

        DialogHelper.showSuccessSnackbar(
          title: 'success'.tr,
          message: result,
        );
      }
    } catch (e) {
      DialogHelper.showErrorSnackbar(
        title: 'error'.tr,
        message: '${'failed_to_open_voting'.tr}: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> closeVoting() async {
    if (selectedCourseIds.isEmpty) {
      DialogHelper.showErrorSnackbar(
        title: 'error'.tr,
        message: 'please_select_course'.tr,
      );
      return;
    }

    try {
      isLoading.value = true;

      for (var courseId in selectedCourseIds) {
        final result = await _voteRepository.closeVoting(courseId);

        DialogHelper.showSuccessSnackbar(
          title: 'success'.tr,
          message: result,
        );
      }
    } catch (e) {
      DialogHelper.showErrorSnackbar(
        title: 'error'.tr,
        message: '${'failed_to_close_voting'.tr}: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  void setSelectedVote(Vote vote) {
    selectedVote.value = vote;
  }

  void resetVotingManagementForm() {
    selectedCourseIds.clear();
    startDate.value = DateTime.now();
    endDate.value = DateTime.now().add(const Duration(days: 14));
  }
}
