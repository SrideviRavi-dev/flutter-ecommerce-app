// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/bindings/general_bindings.dart';
import 'package:myapp/features/authentication/screens/login/login.dart';
import 'package:myapp/navigation_manu.dart';
import 'package:myapp/utils/constant/colors.dart';
import 'package:myapp/utils/themes/theme.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: JAppTheme.lightTheme,
      initialBinding: GeneralBindings(),
      home: const _SplashRouter(), // 👈 Redirect logic moved here
    );
  }
}

class _SplashRouter extends StatefulWidget {
  const _SplashRouter({Key? key}) : super(key: key);

  @override
  State<_SplashRouter> createState() => _SplashRouterState();
}

class _SplashRouterState extends State<_SplashRouter> {
  final _box = GetStorage();

  @override
  void initState() {
    super.initState();

    // Run navigation logic after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final user = FirebaseAuth.instance.currentUser;
        final bool isUserVerified = _box.read('isUserVerified') ?? false;

        if (user != null && isUserVerified) {
          Get.offAll(() => const NavigationMenu());
        } else {
          Get.offAll(() => const LoginScreen());
        }
      } catch (e) {
        debugPrint("🔴 Redirect error: $e");
        Get.offAll(() => const LoginScreen());
      } finally {
        FlutterNativeSplash.remove(); // ✅ Always remove splash
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Simple loading screen until redirect completes
    return const Scaffold(
      backgroundColor: JColors.white,
      body: Center(
        child: CircularProgressIndicator(
          color: JColors.primary,
        ),
      ),
    );
  }
}
