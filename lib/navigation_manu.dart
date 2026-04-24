// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:myapp/features/personalization/screen/settings/settings.dart';
import 'package:myapp/features/shop/screen/cart/cart.dart';
import 'package:myapp/features/shop/screen/categories/category.dart';
import 'package:myapp/features/shop/screen/home/home.dart';
import 'package:myapp/features/shop/screen/wishlist/wishlist.dart';
import 'package:myapp/utils/constant/colors.dart';
import 'package:myapp/utils/helpers/helper_function.dart';

class NavigationMenu extends StatelessWidget {
  
  const NavigationMenu({super.key, });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final darkMode = JHelperFunction.isDarkMode(context);
    return Scaffold(
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
           type: BottomNavigationBarType.fixed,
          currentIndex: controller.selectedIndex.value,
          onTap: (index) => controller.selectedIndex.value = index,
          backgroundColor: darkMode ? JColors.black : Color.fromARGB(255, 247, 247, 223),
          selectedItemColor: darkMode ? JColors.white : Color(0xFF7B3F00)
,
          unselectedItemColor: darkMode
              ? JColors.white.withOpacity(0.6)
              : Color(0xFF2F4F4F),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Iconsax.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Iconsax.heart),
              label: 'WishList',
            ),
            BottomNavigationBarItem(
              icon: Icon(Iconsax.category),
              label: 'Category',
            ),
            BottomNavigationBarItem(
              icon: Icon(Iconsax.shopping_cart),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: Icon(Iconsax.user),
              label: 'Account',
            ),
          ],
          selectedLabelStyle: const TextStyle(fontSize: 14),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  void resetIndex() {
    selectedIndex.value = 0;
  }
  final screens = [
    const HomeScreen(),
    const FavoriteScreen(),
     CategoryScreen(),
    const CartScreen(),
     const SettingsScreen()
  ];
}
