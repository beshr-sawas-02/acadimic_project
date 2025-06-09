class ApiConstants {
  static const String baseUrl = 'https://student-vote-backend.vercel.app';
  //static const String baseUrl = 'http://192.168.201.167:3000';

  // Auth endpoints
  static const String login = '/auth/loginEmp';
  static const String loginAdmin = '/auth/loginAdmin';

  // Course endpoints
  static const String courses = '/course';
  static const String createCourse = '/course/create-course';
  static const String openCourseYear = '/course/open-course-year';
  static const String findAllCourses = '/course/find-all-course';
  static const String openCoursesByYear = '/course/open-course';

  // Employee endpoints
  static const String employees = '/emp';
  static const String createEmployee = '/emp/create';
  static const String findAllEmployees = '/emp/find-all';

  // Mark endpoints
  static const String marks = '/mark';
  static const String bulkImportMarks = '/mark/bulk-import';
  static const String getAllMarks = '/mark/get-all-marks';

  // Student endpoints
  static const String students = '/student';
  static const String getAllStudents = '/student/get-all';
  static const String findStudentByName = '/student/find';

  // Vote endpoints
  static const String votes = '/votes';
  static const String getAllVotes = '/votes/find-all';
  static const String openVoting = '/votes/open-voting';
  static const String closeVoting = '/votes/close-voting';
}

class AppConstants {
  static const String appName = 'University Management';
  static const String appVersion = '1.0.0';

  // Shared preferences keys
  static const String token = 'token';
  static const String user = 'user';
  static const String role = 'role';

  // Error messages
  static const String serverError = 'Server error, please try again later';
  static const String networkError = 'Network error, please check your connection';
  static const String unknownError = 'An unknown error occurred';
  static const String authError = 'Authentication error, please login again';

  // Success messages
  static const String loginSuccess = 'Login successful';
  static const String logoutSuccess = 'Logout successful';
  static const String createSuccess = 'Created successfully';
  static const String updateSuccess = 'Updated successfully';
  static const String deleteSuccess = 'Deleted successfully';
}