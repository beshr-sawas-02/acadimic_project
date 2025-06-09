import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  final _box = GetStorage();
  final themeMode = ThemeMode.light.obs;

  @override
  void onInit() {
    super.onInit();
    final isDark = _box.read('isDarkMode') ?? false;
    themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  void toggleTheme() {
    final isDark = themeMode.value == ThemeMode.dark;
    themeMode.value = isDark ? ThemeMode.light : ThemeMode.dark;
    _box.write('isDarkMode', !isDark);
  }

  bool get isDarkMode => themeMode.value == ThemeMode.dark;
}
