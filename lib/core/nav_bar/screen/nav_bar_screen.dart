import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taghyeer/core/nav_bar/controller/nav_bar_controller.dart';
import 'package:taghyeer/feature/Products_screen/view/product_screen.dart';
import 'package:taghyeer/feature/post_screen/view/post_screen.dart';
import 'package:taghyeer/feature/setting_screen/view/setting_screen.dart';

class NavigationbarScreen extends StatelessWidget {
  NavigationbarScreen({super.key});

  final NavigationbarController controller = Get.put(NavigationbarController());

  final List<Widget> pages = [
    ProductListScreen(),
    PostScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => pages[controller.selectedIndex.value]),

      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
          onTap: controller.changeIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag),
              label: "Products",
            ),
            BottomNavigationBarItem(icon: Icon(Icons.article), label: "Posts"),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: "Settings",
            ),
          ],
        ),
      ),
    );
  }
}
