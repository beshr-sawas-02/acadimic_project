import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../models/login_model.dart';
import '../models/user_model.dart';
import '../providers/api_provider.dart';
import '../providers/storage_provider.dart';
import '../../utils/constants.dart';

class AuthRepository {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();
  final StorageProvider _storageProvider = Get.find<StorageProvider>();

  // Login employee
  Future<User> loginEmployee(LoginRequest loginRequest) async {
    try {
      final response = await _apiProvider.post(
        ApiConstants.login,
        data: loginRequest.toMap(),
      );

      final loginResponse = LoginResponse.fromMap(response.data);

      // Save token and user data
      await _storageProvider.setToken(loginResponse.accessToken);
      await _storageProvider.setUser(loginResponse.user);
      await _storageProvider.setRole(loginResponse.user['role']);

      return User.fromMap(loginResponse.user);
    } on DioException catch (e) {
      if (e.response != null) {
        throw e.response!.data['message'] ?? 'Login failed';
      } else {
        throw e.message ?? 'Login failed';
      }
    } catch (e) {
      throw e.toString();
    }
  }

  // Login admin
  Future<User> loginAdmin(LoginAdminRequest loginRequest) async {
    try {
      final response = await _apiProvider.post(
        ApiConstants.loginAdmin,
        data: loginRequest.toMap(),
      );


      final loginResponse = LoginResponse.fromMap(response.data);

      // Save token and user data
      await _storageProvider.setToken(loginResponse.accessToken);
      await _storageProvider.setUser(loginResponse.user);
      await _storageProvider.setRole(loginResponse.user['role']);

      return User.fromMap(loginResponse.user);
    } on DioException catch (e) {
      if (e.response != null) {
        throw e.response!.data['message'] ?? 'Login failed';
      } else {
        throw e.message ?? 'Login failed';
      }
    } catch (e) {
      throw e.toString();
    }
  }

  // Logout
  Future<void> logout() async {
    await _storageProvider.clearAll();
  }

  // Check if user is logged in
  bool get isLoggedIn => _storageProvider.isLoggedIn;

  // Get user data
  User? getUserData() {
    final userData = _storageProvider.user;
    if (userData != null) {
      return User.fromMap(userData);
    }
    return null;
  }

  // Get user role
  String? getUserRole() {
    return _storageProvider.role;
  }

  // Check if user is admin
  bool get isAdmin => _storageProvider.isAdmin;

  // Check if user is employee
  bool get isEmployee => _storageProvider.isEmployee;
}