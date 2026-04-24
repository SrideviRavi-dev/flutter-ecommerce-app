import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:myapp/common/widgets/appbar/appbar.dart';
import 'package:myapp/common/widgets/container/primary_container.dart';
import 'package:myapp/common/widgets/list_tile/settings_menu_tile.dart';
import 'package:myapp/common/widgets/list_tile/user_profile_tile.dart';
import 'package:myapp/common/widgets/text/section_heading.dart';
import 'package:myapp/features/authentication/screens/login/login.dart';
import 'package:myapp/features/authentication/screens/signup/signup.dart';
import 'package:myapp/features/personalization/screen/address/address.dart';
import 'package:myapp/features/shop/screen/cart/cart.dart'; 
import 'package:myapp/features/shop/screen/order/order.dart';
import 'package:myapp/repositoires/authentication/auth_rep.dart';
import 'package:myapp/utils/constant/sizes.dart';
import 'package:url_launcher/url_launcher.dart'; // <- Add this import

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  // Privacy Policy URL
  static final Uri _privacyPolicyUrl = Uri.parse(
    'https://doc-hosting.flycricket.io/jardion-privacy-policy/358c6081-a80d-4beb-9870-3c313488bc6c/privacy',
  );

  Future<void> _launchPrivacyPolicy() async {
    if (!await launchUrl(_privacyPolicyUrl, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $_privacyPolicyUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 233, 255, 255),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const JPrimaryHeaderContainer(
              child: Column(
                children: [
                  JAppBar(title: Text('Account')),
                  SizedBox(height: JSizes.defaultSpace),
                  JUserProfileTile(),
                  SizedBox(height: JSizes.spaceBtwSections),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(JSizes.defaultSpace),
              child: Column(
                children: [
                  const JSectionHeading(
                    title: 'Account Settings',
                    showActionButton: false,
                  ),
                  const SizedBox(height: JSizes.spaceBtwItems),
                  JSettingsMenuTile(
                      icon: Iconsax.safe_home,
                      title: 'My Addresses',
                      subTitle: 'Set Shopping Delivery Address',
                      onTap: () => Get.to(() => UserAddressScreen())),
                  JSettingsMenuTile(
                    icon: Iconsax.shopping_cart,
                    title: 'My Cart',
                    subTitle: 'Add, remove products and move to checkout',
                    onTap: () => Get.to(() => const CartScreen()),
                  ),
                  JSettingsMenuTile(
                      icon: Iconsax.bag_tick,
                      title: 'My Orders',
                      subTitle: 'In Progress and completed Orders',
                      onTap: () => Get.to(() => const OrderScreen())),
                  JSettingsMenuTile(
                    icon: Iconsax.discount_shape,
                    title: 'My Coupons',
                    subTitle: 'List of All the discount coupons',
                    onTap: () {},
                  ),
                  JSettingsMenuTile(
                    icon: Iconsax.notification,
                    title: 'Notifications',
                    subTitle: 'Set any kind of notification message',
                    onTap: () {},
                  ),
                  JSettingsMenuTile(
                    icon: Iconsax.security_card,
                    title: 'Privacy Policy',
                    subTitle: 'Manage data usage and Connected accounts',
                    onTap: _launchPrivacyPolicy, // <-- Open privacy link
                  ),
                  const SizedBox(height: JSizes.spaceBtwSections),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Get.to(() => const LoginScreen()),
                      child: const Text('Sign In'),
                    ),
                  ),
                  const SizedBox(height: JSizes.spaceBtwSections / 2),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Get.to(() => const SignUpScreen()),
                      child: const Text('Create Account'),
                    ),
                  ),
                  const SizedBox(height: JSizes.spaceBtwSections / 2),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () async {
                        await AuthenticationRepository.instance.logout();
                      },
                      child: const Text('Logout'),
                    ),
                  ),
                  const SizedBox(height: JSizes.spaceBtwSections * 2.5),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
