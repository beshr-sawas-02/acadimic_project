import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/course_controller.dart';
import '../../controllers/vote_controller.dart';

class VotingManagementScreen extends StatefulWidget {
  VotingManagementScreen({super.key});

  @override
  State<VotingManagementScreen> createState() => _VotingManagementScreenState();
}

class _VotingManagementScreenState extends State<VotingManagementScreen> {
  final CourseController courseController = Get.find<CourseController>();
  final VoteController voteController = Get.find<VoteController>();

  // Controller لحقل البحث
  final TextEditingController searchController = TextEditingController();

  // نص البحث متغير رياكتيفي
  final RxString searchText = ''.obs;

  // الألوان كما هي
  static const Color primary = Color(0xFFD4C9BE);
  static const Color secondary = Color(0xFF123458);

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
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
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Obx(
                    () => Column(
                  children: [
                    const SizedBox(height: 16),

                    // حقل البحث
                    TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        hintText: 'search_courses'.tr,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: searchText.value.isNotEmpty
                            ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            searchController.clear();
                            searchText.value = '';
                          },
                        )
                            : null,
                      ),
                      onChanged: (value) {
                        searchText.value = value.trim();
                      },
                    ),

                    const SizedBox(height: 16),

                    _buildCoursesSection(),

                    const SizedBox(height: 24),

                    _buildDateRow(),

                    const SizedBox(height: 24),

                    _buildActionGrid(),

                    const SizedBox(height: 24),

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
    // هنا نفلتر المقررات حسب نص البحث
    List filteredCourses = courseController.courses.where((course) {
      if (searchText.value.isEmpty) return true;
      final search = searchText.value.toLowerCase();
      return course.name.toLowerCase().contains(search) ||
          course.courseCode.toLowerCase().contains(search);
    }).toList();

    // حساب حالة تحديد الكل
    bool isAllSelected = filteredCourses.isNotEmpty &&
        filteredCourses.every((course) => voteController.selectedCourseIds.contains(course.id));
    bool isPartiallySelected = filteredCourses.any((course) => voteController.selectedCourseIds.contains(course.id)) && !isAllSelected;

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

          // أزرار تحديد الكل وإلغاء تحديد الكل
          if (filteredCourses.isNotEmpty) ...[
            Row(
              children: [
                Expanded(
                  child: _buildSelectAllButton(
                    title: 'select_all'.tr,
                    icon: Icons.check_box,
                    isSelected: isAllSelected,
                    isPartiallySelected: isPartiallySelected,
                    onTap: () {
                      if (isAllSelected) {
                        // إلغاء تحديد الكل
                        for (var course in filteredCourses) {
                          voteController.selectedCourseIds.remove(course.id);
                        }
                      } else {
                        // تحديد الكل
                        for (var course in filteredCourses) {
                          if (!voteController.selectedCourseIds.contains(course.id)) {
                            voteController.selectedCourseIds.add(course.id);
                          }
                        }
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSelectAllButton(
                    title: 'clear_all'.tr,
                    icon: Icons.clear_all,
                    isSelected: false,
                    isPartiallySelected: false,
                    onTap: () {
                      // إلغاء تحديد جميع المقررات (حتى المفلترة)
                      for (var course in filteredCourses) {
                        voteController.selectedCourseIds.remove(course.id);
                      }
                    },
                    backgroundColor: Colors.red.withAlpha((0.1 * 255).round()),
                    textColor: Colors.red[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],

          // عرض عدد المقررات المحددة
          if (voteController.selectedCourseIds.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: secondary.withAlpha((0.1 * 255).round()),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${'selected_courses'.tr}: ${voteController.selectedCourseIds.length}',
                style: TextStyle(
                  color: secondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: filteredCourses.map((course) {
              final isSelected = voteController.selectedCourseIds.contains(course.id);
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
                        color: isSelected ? Colors.white70 : Colors.grey[500],
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
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectAllButton({
    required String title,
    required IconData icon,
    required bool isSelected,
    required bool isPartiallySelected,
    required VoidCallback onTap,
    Color? backgroundColor,
    Color? textColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor ?? (isSelected ? secondary.withAlpha((0.1 * 255).round()) : Colors.grey[100]),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? secondary : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isPartiallySelected ? Icons.indeterminate_check_box : icon,
              color: textColor ?? (isSelected ? secondary : Colors.grey[600]),
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: textColor ?? (isSelected ? secondary : Colors.grey[600]),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // بقية الكود كما هو (بدون تغيير)
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
          onTap: voteController.isLoading.value
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
          onTap: voteController.isLoading.value
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
          gradient: onTap != null
              ? gradient
              : LinearGradient(
            colors: [Colors.grey[300]!, Colors.grey[400]!],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: onTap != null
              ? [
            BoxShadow(
              color: Colors.black.withAlpha((0.1 * 255).round()),
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
}