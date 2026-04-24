import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/features/authentication/controllers/signup/network_manager.dart';
//import 'package:myapp/features/authentication/model/user_model.dart';
import 'package:myapp/features/authentication/screens/signup/verify_email.dart';
//import 'package:myapp/repositoires/authentication/auth_rep.dart';
//import 'package:myapp/repositoires/user/user_rep.dart';
import 'package:myapp/utils/constant/image_string.dart';
import 'package:myapp/utils/loaders/snackbar_loaders.dart';
import 'package:myapp/utils/popups/full_screen_loader.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  final hidePassword = true.obs;
  final privacyPolicy = true.obs;
  final email = TextEditingController();
  final lastName = TextEditingController();
  final userName = TextEditingController();
  final password = TextEditingController();
  final firstName = TextEditingController();
  final phoneNumber = TextEditingController();
  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();

  Future<void> signup() async {
    try {
      // Start Loading
      JFullScreenLoader.openLoadingDialog(
          'We are processing Your information', JImages.lodinggif);
      //      FullScreenLoader.openLoadingDialog(
      //   "Loading, please wait...",
      //  const CircularProgressIndicator(),
      //);

      // check internet connection
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        //Remove Loader
        JFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation

      if (!signupFormKey.currentState!.validate()) {
        //Remove Loader
        JFullScreenLoader.stopLoading();
        return;
      }
      //privacy policy check
      if (!privacyPolicy.value) {
        JLoaders.warningSnackBar(
            title: 'Accept privacy policy',
            message:
                'In Order to create , you must have to read and accept the privacy policy & Terms of use');
        return;
      }

      //Register user in the Firebase Authentication & Save User Data in the Firebase

      // final userCredential = await AuthenticationRepository.instance
      //     .registerWithEmailPassword(email.text.trim(), password.text.trim());

      // //Save Authenticaion user data in the Firebase Firestore
      // final newuser = UserModel(
      //   id: userCredential.user!.uid,
      //   firstName: firstName.text.trim(),
      //   lastName: lastName.text.trim(),
      //   userName: userName.text.trim(),
      //   email: email.text.trim(),
      //   phoneNumber: phoneNumber.text.trim(),
      //   profilPicture: '',
      // );

     // final userRepository = Get.put(UserRepository());
      //await userRepository.saveUserRecord(newuser);

      //Remove Loader
      JFullScreenLoader.stopLoading();

      // Show Success Message
      JLoaders.successSnackBar(
          title: 'Conguratulaion',
          message: 'Your Account has been created! Verify email to continue');

      // move to verify email screen
      Get.to(() => VerifyEmailScreen(email: email.text.trim()));
    } catch (e) {
      //Show some Generic Error  to the user
      JLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      //Remove Loader
      JFullScreenLoader.stopLoading();
    }
  }
}
