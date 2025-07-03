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
        title: 'error'.tr,
        message: error.toString(),
      );
    }
  }

  static void _handleDioError(dio.DioException error) {
    switch (error.type) {
      case dio.DioExceptionType.connectionTimeout:
        DialogHelper.showErrorSnackbar(
          title: 'connection_timeout'.tr,
          message: 'connection_timeout_msg'.tr,
        );
        break;

      case dio.DioExceptionType.sendTimeout:
        DialogHelper.showErrorSnackbar(
          title: 'send_timeout'.tr,
          message: 'send_timeout_msg'.tr,
        );
        break;

      case dio.DioExceptionType.receiveTimeout:
        DialogHelper.showErrorSnackbar(
          title: 'receive_timeout'.tr,
          message: 'receive_timeout_msg'.tr,
        );
        break;

      case dio.DioExceptionType.badResponse:
        _handleResponse(error.response!);
        break;

      case dio.DioExceptionType.cancel:
        DialogHelper.showErrorSnackbar(
          title: 'request_cancelled'.tr,
          message: 'request_cancelled_msg'.tr,
        );
        break;

      case dio.DioExceptionType.connectionError:
        DialogHelper.showErrorSnackbar(
          title: 'connection_error'.tr,
          message: 'connection_error_msg'.tr,
        );
        break;

      default:
        DialogHelper.showErrorSnackbar(
          title: 'network_error'.tr,
          message: AppConstants.networkError, // هذا ثابت، يمكنك ترجمته في مكان آخر
        );
    }
  }

  static void _handleResponse(dio.Response response) {
    switch (response.statusCode) {
      case 400:
        DialogHelper.showErrorSnackbar(
          title: 'bad_request'.tr,
          message: _getErrorMessage(response),
        );
        break;

      case 401:
        DialogHelper.showErrorSnackbar(
          title: 'unauthorized'.tr,
          message: 'unauthorized_msg'.tr,
        );
        _clearTokenAndRedirectToLogin();
        break;

      case 403:
        DialogHelper.showErrorSnackbar(
          title: 'forbidden'.tr,
          message: 'forbidden_msg'.tr,
        );
        break;

      case 404:
        DialogHelper.showErrorSnackbar(
          title: 'not_found'.tr,
          message: 'not_found_msg'.tr,
        );
        break;

      case 409:
        DialogHelper.showErrorSnackbar(
          title: 'conflict'.tr,
          message: _getErrorMessage(response),
        );
        break;

      case 422:
        DialogHelper.showErrorSnackbar(
          title: 'validation_error'.tr,
          message: _getErrorMessage(response),
        );
        break;

      case 500:
        DialogHelper.showErrorSnackbar(
          title: 'server_error'.tr,
          message: 'server_error_msg'.tr,
        );
        break;

      default:
        DialogHelper.showErrorSnackbar(
          title: 'error'.tr,
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
        return 'generic_error_msg'.tr;
      }
    } catch (e) {
      return 'generic_error_msg'.tr;
    }
  }

  static void _clearTokenAndRedirectToLogin() {
    final StorageProvider storageProvider = Get.find<StorageProvider>();
    storageProvider.clearToken();
    storageProvider.clearUser();

    Get.offAllNamed(Routes.LOGIN);
  }
}
