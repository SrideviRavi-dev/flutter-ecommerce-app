import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:myapp/common/widgets/success_screen/success_screen.dart';
import 'package:myapp/repositoires/authentication/auth_rep.dart';
import 'package:myapp/utils/constant/image_string.dart';
import 'package:myapp/utils/constant/text_string.dart';
import 'package:myapp/utils/loaders/snackbar_loaders.dart';

class VerifyEmailController extends GetxController {
  VerifyEmailController get instance => Get.find();

  @override
  void onInit() {
    super.onInit();
    sendEmailVerification();
    setTimerForAutoRedirect();
  }

  /// send Email Verification line
  sendEmailVerification() async {
    try {
      //await AuthenticationRepository.instance.sendEmailVerification();
      JLoaders.successSnackBar( 
        title: 'Email sent',
        message: 'Please Check Your inbox and verify your email',
      );
    } catch (e) {
      JLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  /// Timer to automatically redirect on Email Verification
  setTimerForAutoRedirect() {                                                       
    Timer.periodic(
      const Duration(seconds: 2), // Check every 2 seconds for email verification
      (timer) async {
        try {
          await FirebaseAuth.instance.currentUser?.reload(); // Reload user info
          final user = FirebaseAuth.instance.currentUser;
          
          // Check if email is verified
          if (user?.emailVerified ?? false) {
            timer.cancel(); // Stop checking once verified

          // Redirect to success screen
            Get.offAll(
              () => SuccessScreen(
                image: JImages.resendEmail,
                title: JTexts.yourAccountCreatedTitle,
                subTitle: JTexts.accountCreatedMessage,
                onPressed: () => AuthenticationRepository.instance.screenRedirect(),
              ),
            );
          }
        } catch (e) {
          // Handle error in reloading user
          JLoaders.errorSnackBar(title: 'Error', message: 'Error checking email verification status');
          timer.cancel();
        }
      },
    );
  }

  /// Manually check if Email Verified
  checkEmailVerificationStatus() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null && currentUser.emailVerified) {
        Get.offAll(
          () => SuccessScreen(
            image: JImages.resendEmail,
            title: JTexts.yourAccountCreatedTitle,
            subTitle: JTexts.accountCreatedMessage,
            onPressed: () => AuthenticationRepository.instance.screenRedirect(),
          ),
        );
      }
    } catch (e) {
      // Handle error if checking manually
      JLoaders.errorSnackBar(title: 'Error', message: 'Error checking email verification status');
    }
  }
}
