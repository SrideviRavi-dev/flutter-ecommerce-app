import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:myapp/app.dart';
import 'package:myapp/firebase_options.dart';
import 'package:myapp/repositoires/authentication/auth_rep.dart';
import 'package:myapp/services/cart_services/cart_service.dart';

void main() async {
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.playIntegrity,
      appleProvider: AppleProvider.appAttest,
    );

    // Put your services
    Get.put(AuthenticationRepository(), permanent: true);
    FirebaseFirestore.instance.settings =
        const Settings(persistenceEnabled: true);
    await Get.putAsync<CartService>(() async {
      final service = CartService();
      await service.init();
      return service;
    }, permanent: true);
  } catch (e, stack) {
    debugPrint("🔥 Error during app initialization: $e");
    debugPrint("📌 Stack trace: $stack");
  }

  runApp(const MyApp());
}
