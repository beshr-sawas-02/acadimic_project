import 'package:get/get.dart';
import '../bindings/auth_binding.dart';
import '../bindings/course_binding.dart';
import '../bindings/employee_binding.dart';
import '../bindings/mark_binding.dart';
import '../bindings/student_binding.dart';
import '../bindings/vote_binding.dart';
import '../middlewares/auth_middlewares.dart';
import '../middlewares/role_middlewares.dart';
import '../views/auth/login_screen.dart';
import '../views/dashboard/dashboard_screen.dart';
import '../views/courses/course_list_screen.dart';
import '../views/courses/course_detail_screen.dart';
import '../views/courses/add_edit_course_screen.dart';
import '../views/employees/employee_list_screen.dart';
import '../views/employees/employee_detail_screen.dart';
import '../views/employees/add_edit_employee_screen.dart';
import '../views/marks/mark_list_screen.dart';
import '../views/marks/add_edit_mark_screen.dart';
import '../views/marks/bulk_import_screen.dart';
import '../views/students/student_list_screen.dart';
import '../views/students/student_detail_screen.dart';
import '../views/students/student_gpa_screen.dart';
import '../views/votes/vote_list_screen.dart';
import '../views/votes/vote_detail_screen.dart';
import '../views/votes/voting_management_screen.dart';
import '../views/splash_screen.dart';


part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    // Splash and Auth
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => const DashboardScreen(),
      bindings: [
        AuthBinding(),
        CourseBinding(),
        EmployeeBinding(),
        MarkBinding(),
        StudentBinding(),
        VoteBinding(),
      ],
      middlewares: [AuthMiddleware()],
    ),

    // Course routes
    GetPage(
      name: _Paths.COURSES,
      page: () => const CourseListScreen(),
      binding: CourseBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.COURSE_DETAIL,
      page: () => const CourseDetailScreen(),
      binding: CourseBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.ADD_EDIT_COURSE,
      page: () => const AddEditCourseScreen(),
      binding: CourseBinding(),
      middlewares: [
        AuthMiddleware(),
        RoleMiddleware(requireAdmin: true)
      ],
    ),

    // Employee routes
    GetPage(
      name: _Paths.EMPLOYEES,
      page: () => const EmployeeListScreen(),
      binding: EmployeeBinding(),
      middlewares: [
        AuthMiddleware(),
        RoleMiddleware(requireAdmin: true)
      ],
    ),
    GetPage(
      name: _Paths.EMPLOYEE_DETAIL,
      page: () => const EmployeeDetailScreen(),
      binding: EmployeeBinding(),
      middlewares: [
        AuthMiddleware(),
        RoleMiddleware(requireAdmin: true)
      ],
    ),
    GetPage(
      name: _Paths.ADD_EDIT_EMPLOYEE,
      page: () => const AddEditEmployeeScreen(),
      binding: EmployeeBinding(),
      middlewares: [
        AuthMiddleware(),
        RoleMiddleware(requireAdmin: true)
      ],
    ),

    // Mark routes
    GetPage(
      name: _Paths.MARKS,
      page: () => const MarkListScreen(),
      binding: MarkBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.ADD_EDIT_MARK,
      page: () => const AddEditMarkScreen(),
      bindings: [MarkBinding(),StudentBinding(),CourseBinding()],
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.BULK_IMPORT_MARKS,
      page: () => const BulkImportScreen(),
      binding: MarkBinding(),
      middlewares: [AuthMiddleware()],
    ),

    // Student routes
    GetPage(
      name: _Paths.STUDENTS,
      page: () => const StudentListScreen(),
      binding: StudentBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.STUDENT_DETAIL,
      page: () => const StudentDetailScreen(),
      binding: StudentBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.STUDENT_GPA,
      page: () => const StudentGpaScreen(),
      binding: StudentBinding(),
      middlewares: [AuthMiddleware()],
    ),

    // Vote routes
    GetPage(
      name: _Paths.VOTES,
      page: () => const VoteListScreen(),
      binding: VoteBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.VOTE_DETAIL,
      page: () => const VoteDetailScreen(),
      binding: VoteBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.VOTING_MANAGEMENT,
      page: () =>  VotingManagementScreen(),
      bindings:[VoteBinding() ,CourseBinding() ]  ,
      middlewares: [
        AuthMiddleware(),
        RoleMiddleware(requireAdmin: true)
      ],
    ),
  ];
}