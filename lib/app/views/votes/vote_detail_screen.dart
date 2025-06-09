import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/vote_controller.dart';
import '../../theme/app_colors.dart';

class VoteDetailScreen extends StatelessWidget {
  const VoteDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VoteController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('vote_details'.tr),
      ),
      body: Obx(() {
        final vote = controller.selectedVote.value;

        if (vote == null) {
          return Center(
            child: Text('no_vote_selected'.tr),
          );
        }

        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final studentName = vote.student != null
            ? vote.student!['name'] as String
            : '${'course_id'.tr}: ${vote.studentId}';

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Vote header
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: AppColors.primary,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      // Student avatar
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: Text(
                          studentName.isNotEmpty ? studentName[0].toUpperCase() : 'S',
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
                              studentName,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.tertiary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              vote.course?['name'],
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.tertiary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${'created_at'.tr}: ${_formatDate(vote.createdAt)}',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.tertiary.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Course list
              // Card(
              //   elevation: 2,
              //   shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(12),
              //   ),
              //   child: Padding(
              //     padding: const EdgeInsets.all(16),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Text(
              //           'voted_courses'.tr,
              //           style: const TextStyle(
              //             fontSize: 18,
              //             fontWeight: FontWeight.bold,
              //           ),
              //         ),
              //         const SizedBox(height: 16),
              //
              //         if (vote.course != null)
              //           ListTile(
              //             leading: CircleAvatar(
              //               backgroundColor: AppColors.secondary,
              //               child: Text(
              //                 '${index + 1}',
              //                 style: const TextStyle(
              //                   color: Colors.white,
              //                   fontWeight: FontWeight.bold,
              //                 ),
              //               ),
              //             ),
              //             title: Text(
              //               vote.course?['name'],
              //               style: const TextStyle(
              //                 fontWeight: FontWeight.bold,
              //               ),
              //             ),
              //             subtitle: Text('Code: $courseCode'),
              //             trailing: const Icon(Icons.check_circle, color: Colors.green),
              //           )
              //         else
              //           ListView.separated(
              //             shrinkWrap: true,
              //             physics: const NeverScrollableScrollPhysics(),
              //             itemCount: vote.courseIds.length,
              //             separatorBuilder: (context, index) => const Divider(),
              //             itemBuilder: (context, index) {
              //               final courseId = vote.courseIds[index];
              //
              //               return ListTile(
              //                 leading: CircleAvatar(
              //                   backgroundColor: AppColors.secondary,
              //                   child: Text(
              //                     '${index + 1}',
              //                     style: const TextStyle(
              //                       color: Colors.white,
              //                       fontWeight: FontWeight.bold,
              //                     ),
              //                   ),
              //                 ),
              //                 title: Text(
              //                   '${'course_id'.tr}: $courseId',
              //                   style: const TextStyle(
              //                     fontWeight: FontWeight.bold,
              //                   ),
              //                 ),
              //                 trailing: const Icon(Icons.check_circle, color: Colors.green),
              //               );
              //             },
              //           ),
              //       ],
              //     ),
              //   ),
              // ),

              const SizedBox(height: 24),

              // Metadata
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
                        'vote_information'.tr,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildDetailRow(
                        icon: Icons.how_to_vote,
                        title: 'vote_id'.tr,
                        value: vote.id,
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        icon: Icons.person,
                        title: 'student_id'.tr,
                        value: vote.student?['name'],
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        icon: Icons.calendar_today,
                        title: 'created_at'.tr,
                        value:
                        '${vote.createdAt.day}/${vote.createdAt.month}/${vote.createdAt.year} ${vote.createdAt.hour}:${vote.createdAt.minute}',
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        icon: Icons.update,
                        title: 'updated_at'.tr,
                        value:
                        '${vote.updatedAt.day}/${vote.updatedAt.month}/${vote.updatedAt.year} ${vote.updatedAt.hour}:${vote.updatedAt.minute}',
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

  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.secondary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppColors.secondary,
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
