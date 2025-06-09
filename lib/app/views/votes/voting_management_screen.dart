// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import '../../controllers/vote_controller.dart';
// import '../../controllers/course_controller.dart';
// import '../../theme/app_colors.dart';
// import '../../../widgets/custom_button.dart';
//
// class VotingManagementScreen extends StatelessWidget {
//   const VotingManagementScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final voteController = Get.find<VoteController>();
//     final courseController = Get.find<CourseController>();
//
//     // Ensure courses are loaded
//     if (courseController.courses.isEmpty) {
//       courseController.fetchAllCourses();
//     }
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('voting_management'.tr),
//       ),
//       body: Obx(() {
//         if (courseController.isLoading.value || voteController.isLoading.value) {
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         }
//
//         return SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Instructions
//               Card(
//                 elevation: 2,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'voting_period_management'.tr,
//                         style: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       Text(
//                         'voting_period_description'.tr,
//                         style: const TextStyle(
//                           color: Colors.grey,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 24),
//
//               // Configure voting period
//               Card(
//                 elevation: 2,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'configure_voting_period'.tr,
//                         style: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//
//                       // Course selection
//                       Text(
//                         'select_course'.tr,
//                         style: const TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 12),
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.grey),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: DropdownButtonHideUnderline(
//                           child: DropdownButton<String>(
//                             isExpanded: true,
//                             value: voteController.courseId.value.isEmpty
//                                 ? null
//                                 : voteController.courseId.value,
//                             hint: Text('select_course'.tr),
//                             items: courseController.courses.map((course) {
//                               return DropdownMenuItem<String>(
//                                 value: course.id,
//                                 child: Text('${course.name} (${course.courseCode})'),
//                               );
//                             }).toList(),
//                             onChanged: (value) {
//                               if (value != null) {
//                                 voteController.courseId.value = value;
//                               }
//                             },
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//
//                       // Date range
//                       Row(
//                         children: [
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'start_date'.tr,
//                                   style: const TextStyle(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 8),
//                                 InkWell(
//                                   onTap: () => _selectStartDate(context, voteController),
//                                   child: Container(
//                                     padding: const EdgeInsets.symmetric(
//                                       horizontal: 12,
//                                       vertical: 12,
//                                     ),
//                                     decoration: BoxDecoration(
//                                       border: Border.all(color: Colors.grey),
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                     child: Row(
//                                       children: [
//                                         const Icon(Icons.calendar_today, size: 16),
//                                         const SizedBox(width: 8),
//                                         Text(
//                                           DateFormat('dd/MM/yyyy')
//                                               .format(voteController.startDate.value),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(width: 16),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'end_date'.tr,
//                                   style: const TextStyle(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 8),
//                                 InkWell(
//                                   onTap: () => _selectEndDate(context, voteController),
//                                   child: Container(
//                                     padding: const EdgeInsets.symmetric(
//                                       horizontal: 12,
//                                       vertical: 12,
//                                     ),
//                                     decoration: BoxDecoration(
//                                       border: Border.all(color: Colors.grey),
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                     child: Row(
//                                       children: [
//                                         const Icon(Icons.calendar_today, size: 16),
//                                         const SizedBox(width: 8),
//                                         Text(
//                                           DateFormat('dd/MM/yyyy')
//                                               .format(voteController.endDate.value),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 24),
//
//                       // Action buttons
//                       Row(
//                         children: [
//                           Expanded(
//                             child: CustomButton(
//                               text: 'open_voting'.tr,
//                               onPressed: voteController.courseId.value.isEmpty
//                                   ? null
//                                   : () => voteController.openVoting(),
//                               backgroundColor: Colors.green,
//                               icon: Icons.lock_open,
//                             ),
//                           ),
//                           const SizedBox(width: 16),
//                           Expanded(
//                             child: CustomButton(
//                               text: 'close_voting'.tr,
//                               onPressed: voteController.courseId.value.isEmpty
//                                   ? null
//                                   : () => voteController.closeVoting(),
//                               backgroundColor: Colors.red,
//                               icon: Icons.lock,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 24),
//
//               // View voting stats
//               Card(
//                 elevation: 2,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'view_course_voting_stats'.tr,
//                         style: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       Text(
//                         'voting_stats_description'.tr,
//                         style: const TextStyle(
//                           color: Colors.grey,
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       CustomButton(
//                         text: 'get_course_votes'.tr,
//                         onPressed: voteController.courseId.value.isEmpty
//                             ? null
//                             : () => voteController.getCourseVotes(),
//                         backgroundColor: AppColors.secondary,
//                         icon: Icons.assessment,
//                         width: double.infinity,
//                       ),
//                       const SizedBox(height: 16),
//
//                       // Course votes results
//                       if (voteController.courseVotes.isNotEmpty) ...[
//                         const Divider(),
//                         const SizedBox(height: 16),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               '${'total_votes'.tr}: ${voteController.courseVotes.length}',
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             Text(
//                               DateFormat('dd/MM/yyyy').format(voteController.startDate.value) +
//                                   ' - ' +
//                                   DateFormat('dd/MM/yyyy').format(voteController.endDate.value),
//                               style: TextStyle(
//                                 color: AppColors.textSecondary,
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 16),
//                         ListView.builder(
//                           shrinkWrap: true,
//                           physics: const NeverScrollableScrollPhysics(),
//                           itemCount: voteController.courseVotes.length,
//                           itemBuilder: (context, index) {
//                             final vote = voteController.courseVotes[index];
//                             final studentName = vote.student != null
//                                 ? vote.student!['name'] as String
//                                 : '${'student'.tr}: ${vote.studentId}';
//
//                             return ListTile(
//                               leading: CircleAvatar(
//                                 backgroundColor: AppColors.primary,
//                                 child: Text(
//                                   studentName.isNotEmpty
//                                       ? studentName[0].toUpperCase()
//                                       : 'S',
//                                   style: TextStyle(
//                                     color: AppColors.tertiary,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                               title: Text(studentName),
//                               subtitle: Text(
//                                 '${'voted_on'.tr}: ${DateFormat('dd/MM/yyyy').format(vote.createdAt)}',
//                               ),
//                               trailing: IconButton(
//                                 icon: const Icon(Icons.visibility),
//                                 onPressed: () {
//                                   voteController.setSelectedVote(vote);
//                                   Get.toNamed('/vote-detail');
//                                 },
//                               ),
//                             );
//                           },
//                         ),
//                       ],
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }
//
//   Future<void> _selectStartDate(BuildContext context, VoteController voteController) async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: voteController.startDate.value,
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2100),
//     );
//     if (picked != null) {
//       voteController.startDate.value = picked;
//     }
//   }
//
//   Future<void> _selectEndDate(BuildContext context, VoteController voteController) async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: voteController.endDate.value,
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2100),
//     );
//     if (picked != null) {
//       voteController.endDate.value = picked;
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/course_controller.dart';
import '../../controllers/vote_controller.dart';

class VotingManagementScreen extends StatelessWidget {
  final CourseController courseController = Get.find<CourseController>();
  final VoteController voteController = Get.find<VoteController>();

  VotingManagementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'voting_management'.tr,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: AppColors.textLight,
          ),
        ),
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.textLight,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // Course Selection Section
              _buildCoursesSection(),

              const SizedBox(height: 24),

              // Date Selection Section
              _buildDateSection(),

              const SizedBox(height: 24),

              // Control Buttons Section
              _buildControlSection(),

              const SizedBox(height: 24),

              // Votes Display Section
              _buildVotesSection(),
            ],
          ),
        )),
      ),
    );
  }

  Widget _buildCoursesSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.tertiary.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.school_outlined,
                  color: AppColors.secondary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'select_courses'.tr,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'اختر المواد للتصويت عليها',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          Container(
            height: 220,
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.divider.withOpacity(0.3)),
            ),
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: courseController.courses.length,
              itemBuilder: (context, index) {
                final course = courseController.courses[index];
                final isSelected = voteController.selectedCourseIds.contains(course.id);
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary.withOpacity(0.1) : AppColors.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.divider.withOpacity(0.3),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: CheckboxListTile(
                    title: Text(
                      course.name,
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected ? AppColors.secondary : AppColors.textPrimary,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Text(
                      course.courseCode,
                      style: TextStyle(
                        color: isSelected ? AppColors.secondary.withOpacity(0.7) : AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    value: isSelected,
                    activeColor: AppColors.secondary,
                    checkColor: AppColors.textLight,
                    onChanged: (checked) {
                      if (checked == true) {
                        voteController.selectedCourseIds.add(course.id);
                      } else {
                        voteController.selectedCourseIds.remove(course.id);
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.tertiary.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.calendar_today_outlined,
                  color: AppColors.secondary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                'فترة التصويت',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: _buildDateField(
                  label: 'start_date'.tr,
                  date: voteController.startDate.value,
                  icon: Icons.play_circle_outline,
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: Get.context!,
                      initialDate: voteController.startDate.value,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.light(
                              primary: AppColors.secondary,
                              onPrimary: AppColors.textLight,
                              surface: AppColors.surface,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null) {
                      voteController.startDate.value = picked;
                    }
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDateField(
                  label: 'end_date'.tr,
                  date: voteController.endDate.value,
                  icon: Icons.stop_circle_outlined,
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: Get.context!,
                      initialDate: voteController.endDate.value,
                      firstDate: voteController.startDate.value,
                      lastDate: DateTime(2100),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.light(
                              primary: AppColors.secondary,
                              onPrimary: AppColors.textLight,
                              surface: AppColors.surface,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null) {
                      voteController.endDate.value = picked;
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime date,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.divider.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: AppColors.secondary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildControlSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.tertiary.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.settings_outlined,
                  color: AppColors.secondary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                'إدارة التصويت',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: _buildControlButton(
                  label: 'open_voting'.tr,
                  icon: Icons.play_arrow,
                  backgroundColor: AppColors.success,
                  onPressed: voteController.isLoading.value
                      ? null
                      : () => voteController.openVoting(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildControlButton(
                  label: 'close_voting'.tr,
                  icon: Icons.stop,
                  backgroundColor: AppColors.error,
                  onPressed: voteController.isLoading.value
                      ? null
                      : () => voteController.closeVoting(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: _buildControlButton(
              label: 'get_votes'.tr,
              icon: Icons.poll_outlined,
              backgroundColor: AppColors.secondary,
              onPressed: voteController.isLoading.value
                  ? null
                  : () => voteController.getCourseVotes(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required String label,
    required IconData icon,
    required Color backgroundColor,
    required VoidCallback? onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: onPressed != null ? backgroundColor : AppColors.disabled,
        foregroundColor: AppColors.textLight,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
      ),
    );
  }

  Widget _buildVotesSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.tertiary.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.how_to_vote_outlined,
                  color: AppColors.secondary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'نتائج التصويت',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              if (voteController.courseVotes.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${voteController.courseVotes.length}',
                    style: const TextStyle(
                      color: AppColors.textLight,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),

          SizedBox(
            height: 300,
            child: voteController.isLoading.value
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(AppColors.secondary),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'جاري تحميل الأصوات...',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
                : voteController.courseVotes.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.ballot_outlined,
                    size: 48,
                    color: AppColors.textSecondary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'لا توجد أصوات حتى الآن',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'اضغط على "جلب الأصوات" للتحديث',
                    style: TextStyle(
                      color: AppColors.textSecondary.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            )
                : ListView.separated(
              itemCount: voteController.courseVotes.length,
              separatorBuilder: (context, index) => Divider(
                color: AppColors.divider.withOpacity(0.3),
                height: 1,
              ),
              itemBuilder: (context, index) {
                final vote = voteController.courseVotes[index];
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: AppColors.primary,
                        child: Text(
                          (vote.student?["name"] ?? 'N')[0].toUpperCase(),
                          style: const TextStyle(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              vote.student?["name"] ?? 'لا يوجد اسم',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'تم التصويت في: ${vote.createdAt.day}/${vote.createdAt.month}/${vote.createdAt.year}',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.check_circle_outline,
                          color: AppColors.success,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AppColors {
  // App colors from provided hex values
  static const Color primary = Color(0xFFD4C9BE); // Beige
  static const Color secondary = Color(0xFF123458); // Navy Blue
  static const Color tertiary = Color(0xFF030303); // Almost Black

  // Extended color palette
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Colors.white;
  static const Color error = Color(0xFFB00020);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF2196F3);

  // Text colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textLight = Colors.white;

  // Other utility colors
  static const Color divider = Color(0xFFBDBDBD);
  static const Color disabled = Color(0xFFE0E0E0);
  static const Color cardBg = Color(0xFFFAFAFA);
}