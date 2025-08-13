import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/controllers/auth_controller.dart';
import 'app/controllers/language_controller.dart';
import 'app/controllers/theme_controller.dart';
import 'app/routes/app_pages.dart';
import 'app/theme/app_theme.dart';
import 'app/data/providers/storage_provider.dart';
import 'app/data/providers/api_provider.dart';
import 'app/views/splash_screen.dart';
import 'app/bindings/auth_binding.dart';
import 'lang/translations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  await Get.putAsync(() async => await StorageProvider().init());
  Get.put(ApiProvider(), permanent: true);
  Get.put(AuthController());
  Get.put(ThemeController());
  Get.put(LanguageController());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ThemeController themeController = Get.find<ThemeController>();
  final LanguageController languageController = Get.find<LanguageController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isArabic = languageController.locale.languageCode == 'ar';

      return Directionality(
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: GetMaterialApp(
          title: 'University Management',
          translations: AppTranslations(),
          locale: languageController.locale,
          fallbackLocale: const Locale('ar'), // fallback عربية
          debugShowCheckedModeBanner: false,
          defaultTransition: Transition.fade,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeController.themeMode.value,
          home: const SplashScreen(),
          initialBinding: AuthBinding(),
          getPages: AppPages.routes,
        ),
      );
    });
  }
}
