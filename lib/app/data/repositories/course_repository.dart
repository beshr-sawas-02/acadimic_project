import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../models/course_model.dart';
import '../providers/api_provider.dart';
import '../../utils/constants.dart';
import '../enums/year_enum.dart';

class CourseRepository {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  // Create course
  Future<Course> createCourse(CreateCourseRequest request) async {
    try {
      final response = await _apiProvider.post(
        ApiConstants.createCourse,
        data: request.toMap(),
      );

      return Course.fromMap(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        throw e.response!.data['message'] ?? 'Failed to create course';
      } else {
        throw e.message ?? 'Failed to create course';
      }
    } catch (e) {
      throw e.toString();
    }
  }

  // Get all courses
  Future<List<Course>> getAllCourses() async {
    try {
      final response = await _apiProvider.get(
        ApiConstants.findAllCourses,
      );

      return (response.data as List)
          .map((course) => Course.fromMap(course))
          .toList();
    } on DioException catch (e) {
      if (e.response != null) {
        throw e.response!.data['message'] ?? 'Failed to get courses';
      } else {
        throw e.message ?? 'Failed to get courses';
      }
    } catch (e) {
      throw e.toString();
    }
  }

  // Get course by id
  Future<Course> getCourseById(String id) async {
    try {
      final response = await _apiProvider.get(
        '${ApiConstants.courses}/find-one/$id',
      );

      return Course.fromMap(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        throw e.response!.data['message'] ?? 'Failed to get course';
      } else {
        throw e.message ?? 'Failed to get course';
      }
    } catch (e) {
      throw e.toString();
    }
  }

  // Get course prerequisites
  Future<List<Course>> getCoursePrerequisites(String courseCode) async {
    try {
      final response = await _apiProvider.get(
        '${ApiConstants.courses}/$courseCode/prerequisites',
      );

      return (response.data as List)
          .map((course) => Course.fromMap(course))
          .toList();
    } on DioException catch (e) {
      if (e.response != null) {
        throw e.response!.data['message'] ?? 'Failed to get prerequisites';
      } else {
        throw e.message ?? 'Failed to get prerequisites';
      }
    } catch (e) {
      throw e.toString();
    }
  }

  // Get all open courses by year
  Future<List<Course>> getAllOpenCoursesByYear(YearEnum year) async {
    try {
      final response = await _apiProvider.get(
        '${ApiConstants.openCoursesByYear}/${year.value}',
      );

      return (response.data as List)
          .map((course) => Course.fromMap(course))
          .toList();
    } on DioException catch (e) {
      if (e.response != null) {
        throw e.response!.data['message'] ?? 'Failed to get open courses';
      } else {
        throw e.message ?? 'Failed to get open courses';
      }
    } catch (e) {
      throw e.toString();
    }
  }

  // Open courses for a specific year
  Future<String> openCourseOfYear(YearEnum year) async {
    try {
      final response = await _apiProvider.post(
        ApiConstants.openCourseYear,
        data: {
          'year': year.value,
        },
      );

      return response.data['message'] ?? 'Courses opened successfully';
    } on DioException catch (e) {
      if (e.response != null) {
        throw e.response!.data['message'] ?? 'Failed to open courses';
      } else {
        throw e.message ?? 'Failed to open courses';
      }
    } catch (e) {
      throw e.toString();
    }
  }

  // Update course
  Future<Course> updateCourse(String id, UpdateCourseRequest request) async {
    try {
      final response = await _apiProvider.patch(
        '${ApiConstants.courses}/update/$id',
        data: request.toMap(),
      );

      return Course.fromMap(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        throw e.response!.data['message'] ?? 'Failed to update course';
      } else {
        throw e.message ?? 'Failed to update course';
      }
    } catch (e) {
      throw e.toString();
    }
  }

  // Delete course
  Future<String> deleteCourse(String id) async {
    try {
      final response = await _apiProvider.delete(
        '${ApiConstants.courses}/delete/$id',
      );

      return response.data['message'] ?? 'Course deleted successfully';
    } on DioException catch (e) {
      if (e.response != null) {
        throw e.response!.data['message'] ?? 'Failed to delete course';
      } else {
        throw e.message ?? 'Failed to delete course';
      }
    } catch (e) {
      throw e.toString();
    }
  }
}