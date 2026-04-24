// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/features/authentication/controllers/signup/network_manager.dart';
import 'package:myapp/features/authentication/screens/password_configuration/reset_password.dart';
//import 'package:myapp/repositoires/authentication/auth_rep.dart';
import 'package:myapp/utils/constant/image_string.dart';
import 'package:myapp/utils/loaders/snackbar_loaders.dart';
import 'package:myapp/utils/popups/full_screen_loader.dart';

class ForgotPasswordController extends GetxController {
  static ForgotPasswordController get instance => Get.find();

  // Variables

  final email = TextEditingController();
  GlobalKey<FormState> forgotPasswordFormKey = GlobalKey<FormState>();

  // send Reset Password Email

  sendPasswordResetEmail() async {
    try {
      JFullScreenLoader.openLoadingDialog(
          'Processing Your Request...', JImages.lodinggif);
      //check internet connection
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        //Remove Loader
        JFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation

      if (!forgotPasswordFormKey.currentState!.validate()) {
        //Remove Loader
        JFullScreenLoader.stopLoading();
        return;
      }

      // await AuthenticationRepository.instance
      //     .sendPasswordResetEmail(email.text.trim());

      //Remove Loader
      JFullScreenLoader.stopLoading();

      JLoaders.successSnackBar(
          title: 'Email Send',
          message: 'Email Link sent to Reset Your password'.tr);

      // Redirect
      Get.to(() => ResetPassword(email: email.text.trim()));
    } catch (e) {
      JFullScreenLoader.stopLoading();
      JLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

  resendPasswordResetEmail(String email) async {
    try {
      JFullScreenLoader.openLoadingDialog(
          'Processing Your Request...', JImages.lodinggif);
      //check internet connection
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        //Remove Loader
        JFullScreenLoader.stopLoading();
        return;
      }

   //   await AuthenticationRepository.instance.sendPasswordResetEmail(email);

      //Remove Loader
      JFullScreenLoader.stopLoading();

      JLoaders.successSnackBar(
          title: 'Email Send',
          message: 'Email Link sent to Reset Your password'.tr);
    } catch (e) {
      JFullScreenLoader.stopLoading();
      JLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }
}
