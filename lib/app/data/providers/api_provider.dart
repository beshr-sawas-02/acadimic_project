import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import '../../utils/constants.dart';
import '../../utils/network_error_handler.dart';
import 'storage_provider.dart';

class ApiProvider extends GetxService {
  final dio.Dio _dio = dio.Dio();
  final _storage = Get.find<StorageProvider>();

  ApiProvider() {
    _dio.options.baseUrl = ApiConstants.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    _dio.options.contentType = 'application/json';

    // Add request interceptor for authentication
    _dio.interceptors.add(
      dio.InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = _storage.token;
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (dio.DioException e, handler) {
          NetworkErrorHandler.handleError(e);
          return handler.next(e);
        },
      ),
    );
  }

  // Generic GET request
  Future<dio.Response> get(
      String path, {
        Map<String, dynamic>? queryParameters,
        dio.Options? options,
        dio.CancelToken? cancelToken,
        dio.ProgressCallback? onReceiveProgress,
      }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Generic POST request
  Future<dio.Response> post(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        dio.Options? options,
        dio.CancelToken? cancelToken,
        dio.ProgressCallback? onSendProgress,
        dio.ProgressCallback? onReceiveProgress,
      }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Generic PUT request
  Future<dio.Response> put(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        dio.Options? options,
        dio.CancelToken? cancelToken,
        dio.ProgressCallback? onSendProgress,
        dio.ProgressCallback? onReceiveProgress,
      }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Generic PATCH request
  Future<dio.Response> patch(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        dio.Options? options,
        dio.CancelToken? cancelToken,
        dio.ProgressCallback? onSendProgress,
        dio.ProgressCallback? onReceiveProgress,
      }) async {
    try {
      final response = await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Generic DELETE request
  Future<dio.Response> delete(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        dio.Options? options,
        dio.CancelToken? cancelToken,
      }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
