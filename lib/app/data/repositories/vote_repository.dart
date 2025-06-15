import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../models/vote_model.dart';
import '../providers/api_provider.dart';
import '../../utils/constants.dart';

class VoteRepository {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  // Get all votes
  Future<List<CourseVote>> getAllVotes() async {
    try {
      final response = await _apiProvider.get(ApiConstants.getAllVotes);
      print(response.data);
      return (response.data as List)
          .map((vote) => CourseVote.fromMap(vote))
          .toList();
    } on DioException catch (e) {
      print('DioException in getAllVotes: ${e.response?.data ?? e.message}');
      throw e.response?.data['message'] ?? 'Failed to get votes';
    } catch (e) {
      print('Other Exception in getAllVotes: $e');
      throw e.toString();
    }
  }
  // Get vote by ID
  Future<Vote> getVoteById(String id) async {
    try {
      final response = await _apiProvider.get(
        '${ApiConstants.votes}/find-by-id/$id',
      );

      return Vote.fromMap(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        throw e.response!.data['message'] ?? 'Failed to get vote';
      } else {
        throw e.message ?? 'Failed to get vote';
      }
    } catch (e) {
      throw e.toString();
    }
  }

  // Get course votes
  Future<List<Vote>> getCourseVotes(CourseVotesParams params) async {
    try {
      final response = await _apiProvider.get(
        '${ApiConstants.votes}/course-votes',
        queryParameters: {
          'courseId': params.courseId,
          'startDate': params.startDate.toIso8601String(),
          'endDate': params.endDate.toIso8601String(),
        },
      );

      return (response.data as List)
          .map((vote) => Vote.fromMap(vote))
          .toList();
    } on DioException catch (e) {
      if (e.response != null) {
        throw e.response!.data['message'] ?? 'Failed to get course votes';
      } else {
        throw e.message ?? 'Failed to get course votes';
      }
    } catch (e) {
      throw e.toString();
    }
  }

  // Open voting
  Future<String> openVoting(String courseId, DateTime startDate, DateTime endDate) async {
    try {
      final response = await _apiProvider.patch(
        '${ApiConstants.openVoting}/$courseId',
        queryParameters: {
          'startDate': startDate.toIso8601String(),
          'endDate': endDate.toIso8601String(),
        },
      );

      return response.data['message'] ?? 'Voting opened successfully';
    } on DioException catch (e) {
      if (e.response != null) {
        throw e.response!.data['message'] ?? 'Failed to open voting';
      } else {
        throw e.message ?? 'Failed to open voting';
      }
    } catch (e) {
      throw e.toString();
    }
  }

  // Close voting
  Future<String> closeVoting(String courseId) async {
    try {
      final response = await _apiProvider.patch(
        '${ApiConstants.closeVoting}/$courseId',
      );

      return response.data['message'] ?? 'Voting closed successfully';
    } on DioException catch (e) {
      if (e.response != null) {
        throw e.response!.data['message'] ?? 'Failed to close voting';
      } else {
        throw e.message ?? 'Failed to close voting';
      }
    } catch (e) {
      throw e.toString();
    }
  }
}