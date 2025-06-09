import 'package:intl/intl.dart';

class DateFormatter {
  // Format date as day/month/year
  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  // Format date as day/month/year hour:minute
  static String formatDateTime(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  // Format date as relative time (e.g., "2 days ago")
  static String formatRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays < 1) {
      if (difference.inHours < 1) {
        return '${difference.inMinutes} minutes ago';
      }
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 30) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else {
      return '${(difference.inDays / 365).floor()} years ago';
    }
  }

  // Parse date from string
  static DateTime? parseDate(String date) {
    try {
      return DateFormat('dd/MM/yyyy').parse(date);
    } catch (e) {
      return null;
    }
  }

  // Parse date time from string
  static DateTime? parseDateTime(String date) {
    try {
      return DateFormat('dd/MM/yyyy HH:mm').parse(date);
    } catch (e) {
      return null;
    }
  }

  // Format date for API (ISO 8601)
  static String formatForApi(DateTime date) {
    return date.toIso8601String();
  }

  // Format academic year (e.g., "2023-2024")
  static String formatAcademicYear(int year) {
    return '$year-${year + 1}';
  }

  // Get current academic year
  static String getCurrentAcademicYear() {
    final now = DateTime.now();
    final academicYearStart = DateTime(now.year, 9, 1); // September 1

    if (now.isBefore(academicYearStart)) {
      return formatAcademicYear(now.year - 1);
    } else {
      return formatAcademicYear(now.year);
    }
  }
}