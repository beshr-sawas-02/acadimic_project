import 'package:get/get.dart';

class Validators {
  // Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'email_required'.tr;
    }

    if (!GetUtils.isEmail(value)) {
      return 'email_invalid'.tr;
    }

    return null;
  }

  // Password validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'password_required'.tr;
    }

    if (value.length < 6) {
      return 'password_min_length'.tr;
    }

    return null;
  }

  // Required field validation
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'field_required'.trParams({'field': fieldName});
    }

    return null;
  }

  // Number validation
  static String? validateNumber(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'number_required'.trParams({'field': fieldName});
    }

    if (!GetUtils.isNum(value)) {
      return 'number_invalid'.tr;
    }

    return null;
  }

  // Mark validation
  static String? validateMark(String? value) {
    if (value == null || value.isEmpty) {
      return 'mark_required'.tr;
    }

    if (!GetUtils.isNum(value)) {
      return 'mark_invalid_number'.tr;
    }

    final mark = double.tryParse(value);
    if (mark == null) {
      return 'mark_invalid'.tr;
    }

    if (mark < 0 || mark > 100) {
      return 'mark_range'.tr;
    }

    return null;
  }

  // Date validation
  static String? validateDate(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'date_required'.trParams({'field': fieldName});
    }

    if (!GetUtils.isDateTime(value)) {
      return 'date_invalid'.tr;
    }

    return null;
  }

  // University ID validation
  static String? validateUniversityId(String? value) {
    if (value == null || value.isEmpty) {
      return 'university_id_required'.tr;
    }

    if (!GetUtils.isNumericOnly(value)) {
      return 'university_id_invalid'.tr;
    }

    return null;
  }

  // Confirm password validation
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'confirm_password_required'.tr;
    }

    if (value != password) {
      return 'passwords_not_match'.tr;
    }

    return null;
  }

  // Course code validation
  static String? validateCourseCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'course_code_required'.tr;
    }

    if (value.length < 4) {
      return 'course_code_min_length'.tr;
    }

    return null;
  }

  // Name validation
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'name_required'.tr;
    }

    if (value.length < 3) {
      return 'name_min_length'.tr;
    }

    return null;
  }
}