import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../models/mark_model.dart';
import '../providers/api_provider.dart';
import '../../utils/constants.dart';

class MarkRepository {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  // Bulk import marks
  Future<String> bulkImportMarks(List<BulkImportMarkRequest> requests) async {
    try {
      final response = await _apiProvider.post(
        ApiConstants.bulkImportMarks,
        data: requests.map((request) => request.toMap()).toList(),
      );

      return response.data['message'] ?? 'Marks imported successfully';
    } on DioException catch (e) {
      if (e.response != null) {
        throw e.response!.data['message'] ?? 'Failed to import marks';
      } else {
        throw e.message ?? 'Failed to import marks';
      }
    } catch (e) {
      throw e.toString();
    }
  }

  // Get all marks
  Future<List<Mark>> getAllMarks() async {
    try {

      final response = await _apiProvider.get(
        ApiConstants.getAllMarks,
      );
print(response.data);
      return (response.data as List)
          .map((mark) => Mark.fromMap(mark))
          .toList();
    } on DioException catch (e) {
      if (e.response != null) {
        throw e.response!.data['message'] ?? 'Failed to get marks';
      } else {
        throw e.message ?? 'Failed to get marks';
      }
    } catch (e) {
      throw e.toString();
    }
  }

  // Get mark by ID
  Future<Mark> getMarkById(String id) async {
    try {
      final response = await _apiProvider.get(
        '${ApiConstants.marks}/find-by-id/$id',
      );

      return Mark.fromMap(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        throw e.response!.data['message'] ?? 'Failed to get mark';
      } else {
        throw e.message ?? 'Failed to get mark';
      }
    } catch (e) {
      throw e.toString();
    }
  }

  // Update mark
  Future<Mark> updateMark(String id, UpdateMarkRequest request) async {
    try {
      final response = await _apiProvider.patch(
        '${ApiConstants.marks}/update/$id',
        data: {
          'id': id,
          'updateDto': request.toMap(),
        },
      );

      return Mark.fromMap(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        throw e.response!.data['message'] ?? 'Failed to update mark';
      } else {
        throw e.message ?? 'Failed to update mark';
      }
    } catch (e) {
      throw e.toString();
    }
  }

  // Delete mark
  Future<String> deleteMark(String id) async {
    try {
      final response = await _apiProvider.delete(
        '${ApiConstants.marks}/delete/$id',
      );

      return response.data['message'] ?? 'Mark deleted successfully';
    } on DioException catch (e) {
      if (e.response != null) {
        throw e.response!.data['message'] ?? 'Failed to delete mark';
      } else {
        throw e.message ?? 'Failed to delete mark';
      }
    } catch (e) {
      throw e.toString();
    }
  }
}