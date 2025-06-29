import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/course_controller.dart';
import '../../controllers/vote_controller.dart';

class VotingManagementScreen extends StatelessWidget {
  final CourseController courseController = Get.find<CourseController>();
  final VoteController voteController = Get.find<VoteController>();

  // Custom Color Palette
  static const Color primary = Color(0xFFD4C9BE); // Beige
  static const Color secondary = Color(0xFF123458); // Navy Blue

  VotingManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with gradient
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'voting_management'.tr,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primary, Color(0xFFD4C9BE)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Obx(
                () => Column(
                  children: [
                    const SizedBox(height: 16),

                    // Course Selection with Chips
                    _buildCoursesSection(),

                    const SizedBox(height: 24),

                    // Date Selection Row
                    _buildDateRow(),

                    const SizedBox(height: 24),

                    // Action Buttons Grid
                    _buildActionGrid(),

                    const SizedBox(height: 24),

                    // Votes Display
                    //_buildVotesDisplay(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoursesSection() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primary.withAlpha((0.3 * 255).round()), primary.withAlpha((0.5 * 255).round())],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primary),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: secondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.library_books,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'select_courses'.tr,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2c3e50),
                      ),
                    ),
                    Text(
                      'choose_courses_hint'.tr,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Courses as Chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                courseController.courses.map((course) {
                  final isSelected = voteController.selectedCourseIds.contains(
                    course.id,
                  );
                  return FilterChip(
                    selected: isSelected,
                    label: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          course.name,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white : Colors.grey[700],
                          ),
                        ),
                        Text(
                          course.courseCode,
                          style: TextStyle(
                            fontSize: 10,
                            color:
                                isSelected ? Colors.white70 : Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                    onSelected: (checked) {
                      if (checked) {
                        voteController.selectedCourseIds.add(course.id);
                      } else {
                        voteController.selectedCourseIds.remove(course.id);
                      }
                    },
                    selectedColor: secondary,
                    checkmarkColor: Colors.white,
                    backgroundColor: primary.withAlpha((0.2 * 255).round()),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDateRow() {
    return Row(
      children: [
        Expanded(
          child: _buildDateCard(
            title: 'start_date'.tr,
            date: voteController.startDate.value,
            icon: Icons.play_circle_outline,
            color: secondary,
            onTap: () async {
              final picked = await showDatePicker(
                context: Get.context!,
                initialDate: voteController.startDate.value,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: secondary,
                        onPrimary: Colors.white,
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
          child: _buildDateCard(
            title: 'end_date'.tr,
            date: voteController.endDate.value,
            icon: Icons.stop_circle_outlined,
            color: secondary,
            onTap: () async {
              final picked = await showDatePicker(
                context: Get.context!,
                initialDate: voteController.endDate.value,
                firstDate: voteController.startDate.value,
                lastDate: DateTime(2100),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: secondary,
                        onPrimary: Colors.white,
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
    );
  }

  Widget _buildDateCard({
    required String title,
    required DateTime date,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withAlpha((0.1 * 255).round()),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: color.withAlpha((0.2 * 255).round())),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${date.day}/${date.month}/${date.year}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF2c3e50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.8,
      children: [
        _buildActionCard(
          title: 'open_voting'.tr,
          icon: Icons.rocket_launch,
          gradient: const LinearGradient(
            colors: [primary, secondary],
            stops: [0.1, 1.0],
          ),
          onTap:
              voteController.isLoading.value
                  ? null
                  : () => voteController.openVoting(),
        ),
        _buildActionCard(
          title: 'close_voting'.tr,
          icon: Icons.block,
          gradient: const LinearGradient(
            colors: [secondary, primary],
            stops: [0.1, 1.0],
          ),
          onTap:
              voteController.isLoading.value
                  ? null
                  : () => voteController.closeVoting(),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required String title,
    required IconData icon,
    required Gradient gradient,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient:
              onTap != null
                  ? gradient
                  : LinearGradient(
                    colors: [Colors.grey[300]!, Colors.grey[400]!],
                  ),
          borderRadius: BorderRadius.circular(20),
          boxShadow:
              onTap != null
                  ? [
                    BoxShadow(
                      color: Colors.black.withAlpha((0.1*255).round()),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                  : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVotesDisplay() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.05 * 255).round()),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header with Get Votes button
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [secondary, Color(0xFF2c3e50)]),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.poll, color: Colors.white, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'get_votes'.tr,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                FloatingActionButton.small(
                  heroTag: "refresh_votes",
                  onPressed:
                      voteController.isLoading.value
                          ? null
                          : () => voteController.getCourseVotes(),
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.refresh, color: secondary),
                ),
              ],
            ),
          ),

          // Votes Content
          Container(
            height: 300,
            padding: const EdgeInsets.all(20),
            child:
                voteController.isLoading.value
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(secondary),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Loading votes...',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
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
                            Icons.inbox_outlined,
                            size: 64,
                            color: primary.withAlpha((0.5 * 255).round()),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'no_votes_yet'.tr,
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      itemCount: voteController.courseVotes.length,
                      itemBuilder: (context, index) {
                        final vote = voteController.courseVotes[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                primary.withAlpha((0.3 * 255).round()),
                                primary.withAlpha((0.5 * 255).round()),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: primary),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [secondary, Color(0xFF2c3e50)],
                                  ),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Center(
                                  child: Text(
                                    (vote.student?["name"] ?? 'N')[0]
                                        .toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      vote.student?["name"] ?? 'No Name',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Color(0xFF2c3e50),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Voted: ${vote.createdAt.day}/${vote.createdAt.month}/${vote.createdAt.year}',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: primary.withAlpha((0.3 * 255).round()),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Icon(
                                  Icons.how_to_vote,
                                  color: secondary,
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
