import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LanguageController extends GetxController {
  final _locale = Locale('en').obs;
  final GetStorage _storage = GetStorage();

  Locale get locale => _locale.value;

  @override
  void onInit() {
    super.onInit();
    String? langCode = _storage.read('language');
    if (langCode != null) {
      _locale.value = Locale(langCode);
      Get.updateLocale(_locale.value);
    }
  }

  void toggleLanguage() {
    final newLang = _locale.value.languageCode == 'en' ? 'ar' : 'en';
    _locale.value = Locale(newLang);
    _storage.write('language', newLang);
    Get.updateLocale(_locale.value);
  }
}
