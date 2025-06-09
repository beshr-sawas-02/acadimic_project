import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'dialog_helper.dart';
import 'constants.dart';
import '../routes/app_pages.dart';
import '../data/providers/storage_provider.dart';

class NetworkErrorHandler {
  static void handleError(dynamic error) {
    if (error is dio.DioException) {
      _handleDioError(error);
    } else {
      DialogHelper.showErrorSnackbar(
        title: 'Error',
        message: error.toString(),
      );
    }
  }

  static void _handleDioError(dio.DioException error) {
    switch (error.type) {
      case dio.DioExceptionType.connectionTimeout:
        DialogHelper.showErrorSnackbar(
          title: 'Connection Timeout',
          message: 'The connection timed out. Please try again.',
        );
        break;

      case dio.DioExceptionType.sendTimeout:
        DialogHelper.showErrorSnackbar(
          title: 'Send Timeout',
          message: 'The request timed out while sending data. Please try again.',
        );
        break;

      case dio.DioExceptionType.receiveTimeout:
        DialogHelper.showErrorSnackbar(
          title: 'Receive Timeout',
          message: 'The server took too long to respond. Please try again.',
        );
        break;

      case dio.DioExceptionType.badResponse:
        _handleResponse(error.response!);
        break;

      case dio.DioExceptionType.cancel:
        DialogHelper.showErrorSnackbar(
          title: 'Request Cancelled',
          message: 'The request was cancelled.',
        );
        break;

      case dio.DioExceptionType.connectionError:
        DialogHelper.showErrorSnackbar(
          title: 'Connection Error',
          message: 'Please check your internet connection and try again.',
        );
        break;

      default:
        DialogHelper.showErrorSnackbar(
          title: 'Network Error',
          message: AppConstants.networkError,
        );
    }
  }

  static void _handleResponse(dio.Response response) {
    switch (response.statusCode) {
      case 400:
        DialogHelper.showErrorSnackbar(
          title: 'Bad Request',
          message: _getErrorMessage(response),
        );
        break;

      case 401:
        DialogHelper.showErrorSnackbar(
          title: 'Unauthorized',
          message: 'Your session has expired. Please login again.',
        );
        _clearTokenAndRedirectToLogin();
        break;

      case 403:
        DialogHelper.showErrorSnackbar(
          title: 'Forbidden',
          message: 'You do not have permission to perform this action.',
        );
        break;

      case 404:
        DialogHelper.showErrorSnackbar(
          title: 'Not Found',
          message: 'The requested resource was not found.',
        );
        break;

      case 409:
        DialogHelper.showErrorSnackbar(
          title: 'Conflict',
          message: _getErrorMessage(response),
        );
        break;

      case 422:
        DialogHelper.showErrorSnackbar(
          title: 'Validation Error',
          message: _getErrorMessage(response),
        );
        break;

      case 500:
        DialogHelper.showErrorSnackbar(
          title: 'Server Error',
          message: AppConstants.serverError,
        );
        break;

      default:
        DialogHelper.showErrorSnackbar(
          title: 'Error',
          message: _getErrorMessage(response),
        );
    }
  }

  static String _getErrorMessage(dio.Response response) {
    try {
      if (response.data is Map && response.data['message'] != null) {
        return response.data['message'].toString();
      } else if (response.data is String) {
        return response.data;
      } else {
        return 'An error occurred. Please try again.';
      }
    } catch (e) {
      return 'An error occurred. Please try again.';
    }
  }

  static void _clearTokenAndRedirectToLogin() {
    final StorageProvider storageProvider = Get.find<StorageProvider>();
    storageProvider.clearToken();
    storageProvider.clearUser();

    Get.offAllNamed(Routes.LOGIN);
  }
}
