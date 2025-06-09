import 'package:get/get.dart';

class Validators {
  // Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    if (!GetUtils.isEmail(value)) {
      return 'Please enter a valid email';
    }

    return null;
  }

  // Password validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  // Required field validation
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }

    return null;
  }

  // Number validation
  static String? validateNumber(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }

    if (!GetUtils.isNum(value)) {
      return 'Please enter a valid number';
    }

    return null;
  }

  // Mark validation
  static String? validateMark(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mark is required';
    }

    if (!GetUtils.isNum(value)) {
      return 'Mark must be a number';
    }

    final mark = double.tryParse(value);
    if (mark == null) {
      return 'Invalid mark';
    }

    if (mark < 0 || mark > 100) {
      return 'Mark must be between 0 and 100';
    }

    return null;
  }

  // Date validation
  static String? validateDate(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }

    if (!GetUtils.isDateTime(value)) {
      return 'Please enter a valid date';
    }

    return null;
  }

  // University ID validation
  static String? validateUniversityId(String? value) {
    if (value == null || value.isEmpty) {
      return 'University ID is required';
    }

    if (!GetUtils.isNumericOnly(value)) {
      return 'University ID must be a number';
    }

    return null;
  }

  // Confirm password validation
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Confirm password is required';
    }

    if (value != password) {
      return 'Passwords do not match';
    }

    return null;
  }

  // Course code validation
  static String? validateCourseCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Course code is required';
    }

    if (value.length < 4) {
      return 'Course code must be at least 4 characters';
    }

    return null;
  }

  // Name validation
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }

    if (value.length < 3) {
      return 'Name must be at least 3 characters';
    }

    return null;
  }
}