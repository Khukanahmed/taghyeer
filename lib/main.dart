import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taghyeer/core/theme/app_theme.dart';
import 'package:taghyeer/core/theme/theme_controller.dart';
import 'package:taghyeer/feature/auth/controller/login_controller.dart';
import 'package:taghyeer/feature/route/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Pre-load prefs before first frame → no theme/route flicker
  final prefs = await SharedPreferences.getInstance();
  final isDark = prefs.getBool(StorageKeys.isDarkMode) ?? true;
  final hasUser = prefs.getString(StorageKeys.user) != null;

  runApp(MyApp(initialDark: isDark, isLoggedIn: hasUser));
}

class MyApp extends StatelessWidget {
  final bool initialDark;
  final bool isLoggedIn;

  const MyApp({super.key, required this.initialDark, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.put(ThemeController(), permanent: true);
    Get.put(AuthController(), permanent: true);

    return Obx(
      () => GetMaterialApp(
        title: 'Taghyeer',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeController.isDarkMode.value
            ? ThemeMode.dark
            : ThemeMode.light,
        initialRoute: AppRoutes.splash,
        getPages: AppRoutes.routes,
        builder: EasyLoading.init(),
      ),
    );
  }
}
