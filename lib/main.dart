import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:taghyeer/core/theme/app_theme.dart';
import 'package:taghyeer/core/theme/theme_controller.dart';
import 'package:taghyeer/feature/auth/controller/login_controller.dart';

import 'package:taghyeer/feature/route/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
