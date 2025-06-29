import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/vote_controller.dart';
import '../../theme/app_colors.dart';
import '../../data/models/vote_model.dart';

class VoteDetailScreen extends StatelessWidget {
  const VoteDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VoteController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('course_voters'.tr),
      ),
      body: Obx(() {
        final courseVote = controller.selectedVote.value;

        if (courseVote == null) {
          return Center(
            child: Text('no_course_selected'.tr),
          );
        }

        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Course header
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: AppColors.primary,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // Course avatar
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.white,
                            child: Text(
                              courseVote.courseName.isNotEmpty
                                  ? courseVote.courseName[0].toUpperCase()
                                  : 'C',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: AppColors.tertiary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  courseVote.courseName,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.tertiary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  courseVote.courseCode,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.tertiary.withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Icon(
                            Icons.how_to_vote,
                            color: AppColors.tertiary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'total_votes'.trParams(
                                {'count': courseVote.voteCount.toString()}),
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.tertiary,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.school,
                            color: AppColors.tertiary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'graduating_voters'.tr + "${courseVote.graduatingVotersCount.toString()}",
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.tertiary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Voters list
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'voters_list'.tr,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      courseVote.voters.isEmpty
                          ? Center(child: Text('no_voters_found'.tr))
                          : ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: courseVote.voters.length,
                        separatorBuilder: (context, index) =>
                        const Divider(),
                        itemBuilder: (context, index) {
                          final voter = courseVote.voters[index];
                          return Directionality(
                            textDirection: TextDirection.rtl,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: AppColors.secondary,
                                child: Text(
                                  voter.name.isNotEmpty
                                      ? voter.name[0].toUpperCase()
                                      : 'S',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(voter.name),
                              subtitle: Text(
                                'university_id'.tr +" ${voter.universityId.toString()}",
                              ),
                              trailing: voter.isGraduating
                                  ? Chip(
                                label: Text('graduating'.tr),
                                backgroundColor: AppColors.secondary
                                    .withOpacity(0.1),
                                labelStyle: TextStyle(
                                    color: AppColors.secondary),
                              )
                                  : null,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}