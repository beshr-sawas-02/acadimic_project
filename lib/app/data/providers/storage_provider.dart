import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class StorageProvider extends GetxService {
  final GetStorage _box = GetStorage();

  // Storage keys
  static const String _tokenKey = 'token';
  static const String _userKey = 'user';
  static const String _roleKey = 'role';
  static const String _themeKey = 'theme';

  Future<StorageProvider> init() async {
    await GetStorage.init();
    return this;
  }

  // Token methods
  String? get token => _box.read<String>(_tokenKey);

  Future<void> setToken(String token) async {
    await _box.write(_tokenKey, token);
  }

  Future<void> clearToken() async {
    await _box.remove(_tokenKey);
  }

  // User methods
  Map<String, dynamic>? get user => _box.read<Map<String, dynamic>>(_userKey);

  Future<void> setUser(Map<String, dynamic> user) async {
    await _box.write(_userKey, user);
  }

  Future<void> clearUser() async {
    await _box.remove(_userKey);
  }

  // Role methods
  String? get role => _box.read<String>(_roleKey);

  Future<void> setRole(String role) async {
    await _box.write(_roleKey, role);
  }

  // Theme methods
  String? get theme => _box.read<String>(_themeKey);

  Future<void> setTheme(String theme) async {
    await _box.write(_themeKey, theme);
  }

  // Clear all data
  Future<void> clearAll() async {
    await _box.erase();
  }

  // Check if user is logged in
  bool get isLoggedIn => token != null && token!.isNotEmpty;

  // Check if user is admin
  bool get isAdmin => role == 'admin';

  // Check if user is employee
  bool get isEmployee => role == 'emp';
}