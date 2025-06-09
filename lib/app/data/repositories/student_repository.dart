import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../models/student_model.dart';
import '../providers/api_provider.dart';
import '../../utils/constants.dart';
import '../enums/year_enum.dart';

class StudentRepository {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  // Get all students
  Future<List<Student>> getAllStudents() async {
    try {
      final response = await _apiProvider.get(
        ApiConstants.getAllStudents,
      );

      return (response.data as List)
          .map((student) => Student.fromMap(student))
          .toList();
    } on DioException catch (e) {
      if (e.response != null) {
        throw e.response!.data['message'] ?? 'Failed to get students';
      } else {
        throw e.message ?? 'Failed to get students';
      }
    } catch (e) {
      throw e.toString();
    }
  }

  // Get student by ID
  Future<Student> getStudentById(String id) async {
    try {
      final response = await _apiProvider.get(
        '${ApiConstants.students}/get-ById/$id',
      );

      return Student.fromMap(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        throw e.response!.data['message'] ?? 'Failed to get student';
      } else {
        throw e.message ?? 'Failed to get student';
      }
    } catch (e) {
      throw e.toString();
    }
  }

  // Find student by name
  Future<List<Student>> findStudentsByName(String name) async {
    try {
      final response = await _apiProvider.get(
        ApiConstants.findStudentByName,
        queryParameters: {
          'name': name,
        },
      );

      return (response.data as List)
          .map((student) => Student.fromMap(student))
          .toList();
    } on DioException catch (e) {
      if (e.response != null) {
        throw e.response!.data['message'] ?? 'Failed to find students';
      } else {
        throw e.message ?? 'Failed to find students';
      }
    } catch (e) {
      throw e.toString();
    }
  }

  // Get student by university ID
  Future<Student> getStudentByUniversityId(int universityId) async {
    try {
      final response = await _apiProvider.get(
        '${ApiConstants.students}/get-universityId/$universityId',
      );

      return Student.fromMap(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        throw e.response!.data['message'] ?? 'Failed to get student';
      } else {
        throw e.message ?? 'Failed to get student';
      }
    } catch (e) {
      throw e.toString();
    }
  }

  // Get semester GPA
  Future<GpaResponse> getSemesterGPA(String studentId, YearEnum year, int semester) async {
    try {
      final response = await _apiProvider.get(
        '${ApiConstants.students}/$studentId/gpa/semester',
        queryParameters: {
          'year': year.value.toString(),
          'semester': semester.toString(),
        },
      );

      return GpaResponse.fromMap(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        throw e.response!.data['message'] ?? 'Failed to get semester GPA';
      } else {
        throw e.message ?? 'Failed to get semester GPA';
      }
    } catch (e) {
      throw e.toString();
    }
  }

  // Get cumulative GPA
  Future<GpaResponse> getCumulativeGPA(String studentId) async {
    try {
      final response = await _apiProvider.get(
        '${ApiConstants.students}/$studentId/gpa/cumulative',
      );

      return GpaResponse.fromMap(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        throw e.response!.data['message'] ?? 'Failed to get cumulative GPA';
      } else {
        throw e.message ?? 'Failed to get cumulative GPA';
      }
    } catch (e) {
      throw e.toString();
    }
  }

  // Update student
  Future<Student> updateStudent(String id, UpdateStudentRequest request) async {
    try {
      final response = await _apiProvider.patch(
        '${ApiConstants.students}/update/$id',
        data: request.toMap(),
      );

      return Student.fromMap(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        throw e.response!.data['message'] ?? 'Failed to update student';
      } else {
        throw e.message ?? 'Failed to update student';
      }
    } catch (e) {
      throw e.toString();
    }
  }

  // Delete student
  Future<String> deleteStudent(String id) async {
    try {
      final response = await _apiProvider.delete(
        '${ApiConstants.students}/delete/$id',
      );

      return response.data['message'] ?? 'Student deleted successfully';
    } on DioException catch (e) {
      if (e.response != null) {
        throw e.response!.data['message'] ?? 'Failed to delete student';
      } else {
        throw e.message ?? 'Failed to delete student';
      }
    } catch (e) {
      throw e.toString();
    }
  }
}