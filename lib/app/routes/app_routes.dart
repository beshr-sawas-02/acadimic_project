part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  // Auth
  static const SPLASH = _Paths.SPLASH;
  static const LOGIN = _Paths.LOGIN;
  static const DASHBOARD = _Paths.DASHBOARD;

  // Courses
  static const COURSES = _Paths.COURSES;
  static const COURSE_DETAIL = _Paths.COURSE_DETAIL;
  static const ADD_EDIT_COURSE = _Paths.ADD_EDIT_COURSE;

  // Employees
  static const EMPLOYEES = _Paths.EMPLOYEES;
  static const EMPLOYEE_DETAIL = _Paths.EMPLOYEE_DETAIL;
  static const ADD_EDIT_EMPLOYEE = _Paths.ADD_EDIT_EMPLOYEE;

  // Marks
  static const MARKS = _Paths.MARKS;
  static const ADD_EDIT_MARK = _Paths.ADD_EDIT_MARK;
  static const BULK_IMPORT_MARKS = _Paths.BULK_IMPORT_MARKS;

  // Students
  static const STUDENTS = _Paths.STUDENTS;
  static const STUDENT_DETAIL = _Paths.STUDENT_DETAIL;
  static const STUDENT_GPA = _Paths.STUDENT_GPA;

  // Votes
  static const VOTES = _Paths.VOTES;
  static const VOTE_DETAIL = _Paths.VOTE_DETAIL;
  static const VOTING_MANAGEMENT = _Paths.VOTING_MANAGEMENT;
}

abstract class _Paths {
  // Auth
  static const SPLASH = '/splash';
  static const LOGIN = '/login';
  static const DASHBOARD = '/dashboard';

  // Courses
  static const COURSES = '/courses';
  static const COURSE_DETAIL = '/course-detail';
  static const ADD_EDIT_COURSE = '/add-edit-course';

  // Employees
  static const EMPLOYEES = '/employees';
  static const EMPLOYEE_DETAIL = '/employee-detail';
  static const ADD_EDIT_EMPLOYEE = '/add-edit-employee';

  // Marks
  static const MARKS = '/marks';
  static const ADD_EDIT_MARK = '/add-edit-mark';
  static const BULK_IMPORT_MARKS = '/bulk-import-marks';

  // Students
  static const STUDENTS = '/students';
  static const STUDENT_DETAIL = '/student-detail';
  static const STUDENT_GPA = '/student-gpa';

  // Votes
  static const VOTES = '/votes';
  static const VOTE_DETAIL = '/vote-detail';
  static const VOTING_MANAGEMENT = '/voting-management';
}