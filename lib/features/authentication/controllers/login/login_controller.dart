// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:myapp/features/authentication/controllers/signup/network_manager.dart';
import 'package:myapp/features/personalization/controllers/user_controller/user_controller.dart';
import 'package:myapp/repositoires/authentication/auth_rep.dart';
import 'package:myapp/utils/constant/image_string.dart';
import 'package:myapp/utils/loaders/snackbar_loaders.dart';
import 'package:myapp/utils/popups/full_screen_loader.dart';

class LoginController extends GetxController {
  // Variables
  final rememberMe = false.obs;
  final hidePassword = true.obs;
  final localStorage = GetStorage();
  final email = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final userController = Get.put(UserController());

  @override
  void onInit() {
    email.text = localStorage.read('REMEMBER_ME_EMAIL')?? '';
    password.text = localStorage.read('REMEMBER_ME_PASSWORD')?? '';

    super.onInit();
  }

  Future<void> emailAndPasswordSignIn() async {
    try {
      JFullScreenLoader.openLoadingDialog(
          'Logging you in....', JImages.lodinggif);

      //check Internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        //Remove Loader
        JFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation

      if (!loginFormKey.currentState!.validate()) {
        //Remove Loader
        JFullScreenLoader.stopLoading();
        return;
      }
      //privacy policy check
      if (rememberMe.value) {
        localStorage.write('REMEMBER_ME_EMAIL', email.text.trim());
        localStorage.write('REMEMBER_ME_PASSWORD', password.text.trim());
      }

   //   final userCredential = await AuthenticationRepository.instance
     //     .loginWithEmailAndPassword(email.text.trim(), password.text.trim());

      //Remove Loader
      JFullScreenLoader.stopLoading();

      // Redirect
      AuthenticationRepository.instance.screenRedirect();
    } catch (e) {
      //Remove Loader
      JFullScreenLoader.stopLoading();
      //Show some Generic Error  to the user
      JLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}
