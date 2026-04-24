import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/features/authentication/controllers/auth_controller/auth_controller.dart';
import 'package:myapp/features/personalization/controllers/user_controller/user_controller.dart';
import 'package:myapp/navigation_manu.dart';
import 'package:myapp/utils/loaders/snackbar_loaders.dart';

class OTPVerificationScreen extends StatefulWidget {
  const OTPVerificationScreen({super.key});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();

    // ✅ Auto-redirect if user already verified (auto OTP worked)
    Future.delayed(const Duration(milliseconds: 500), () async {
      final currentUser = authController.auth.currentUser;
      if (currentUser != null) {
        JLoaders.successSnackBar(
          title: 'Already Verified',
          message: 'You are already signed in.',
        );

        // Save verified flag
        authController.localStorage.write('isUserVerified', true);

        // ✅ Save user record directly (auto verification)
        final userController = Get.put(UserController());
        await userController.saveUserRecordFromUser(currentUser);

        // Navigate to home screen
        Get.offAll(() => const NavigationMenu());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter OTP')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: authController.otpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'Enter OTP'),
            ),
            const SizedBox(height: 20),

            // ✅ Button Logic (Auto + Manual Verification)
            Obx(() => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: authController.isLoading.value
                        ? null
                        : () async {
                            final otp =
                                authController.otpController.text.trim();

                            if (otp.length != 6) {
                              JLoaders.errorSnackBar(
                                title: 'Invalid OTP',
                                message: 'Please enter a valid 6-digit OTP',
                              );
                              return;
                            }

                            authController.isLoading.value = true;

                            try {
                              // ✅ Check if user is already signed in (auto verification)
                              if (authController.auth.currentUser != null) {
                                JLoaders.successSnackBar(
                                  title: 'Already Verified',
                                  message: 'You are already signed in.',
                                );
                                Get.offAll(() => const NavigationMenu());
                                authController.isLoading.value = false;
                                return;
                              }

                              // ✅ Manual verification fallback
                              final credential = PhoneAuthProvider.credential(
                                verificationId:
                                    authController.verificationId.value,
                                smsCode: otp,
                              );

                              final userCredential = await authController.auth
                                  .signInWithCredential(credential);

                              // Save verified flag
                              authController.localStorage
                                  .write('isUserVerified', true);

                              // Save user record
                              final userController = Get.put(UserController());
                              await userController
                                  .saveUserRecord(userCredential);

                              authController.isLoading.value = false;

                              Get.offAll(() => const NavigationMenu());
                            } on FirebaseAuthException catch (e) {
                              authController.isLoading.value = false;
                              JLoaders.errorSnackBar(
                                title: 'OTP Error',
                                message: e.message ?? e.code,
                              );
                            } catch (e) {
                              authController.isLoading.value = false;
                              JLoaders.errorSnackBar(
                                title: 'Error',
                                message: e.toString(),
                              );
                            }
                          },
                    child: authController.isLoading.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Verify OTP'),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
