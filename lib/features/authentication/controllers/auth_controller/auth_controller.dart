// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:myapp/features/authentication/screens/login/login.dart';
import 'package:myapp/features/authentication/screens/signup/otp_verification.dart';
import 'package:myapp/features/personalization/controllers/user_controller/user_controller.dart';
import 'package:myapp/navigation_manu.dart';
import 'package:myapp/repositoires/authentication/auth_rep.dart';
import 'package:myapp/utils/constant/image_string.dart';
import 'package:myapp/utils/constant/text_string.dart';
import 'package:myapp/utils/loaders/snackbar_loaders.dart';

class AuthController extends GetxController {
  static AuthController get instance => Get.find();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final phoneNumberController = TextEditingController();
  final otpController = TextEditingController();
  final verificationId = ''.obs;
  final isLoading = false.obs;
  final localStorage = GetStorage();
  FirebaseAuth get auth => _auth;

  /// -------------------- SEND OTP --------------------
  Future<void> sendOtp() async {
    isLoading.value = true;
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: '+91${phoneNumberController.text.trim()}',
        timeout: const Duration(seconds: 60),

        // ✅ AUTO VERIFICATION HANDLER (Play Store)
        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            debugPrint("✅ Auto-verification triggered");

            if (_auth.currentUser == null) {
              final userCredential = await _auth.signInWithCredential(credential);
              localStorage.write('isUserVerified', true);

              // Save user record to Firestore
              final userController = Get.put(UserController());
              await userController.saveUserRecord(userCredential);

              // ✅ DIRECTLY NAVIGATE TO HOME SCREEN (no Continue button)
              Future.delayed(const Duration(milliseconds: 500), () {
                Get.offAll(() => const NavigationMenu());
              });
            } else {
              debugPrint("⚠️ User already signed in, skipping auto-verification.");
            }
          } catch (e) {
            debugPrint("🔥 Auto verification error: $e");
            JLoaders.errorSnackBar(
              title: 'Auto Verification Failed',
              message: e.toString(),
            );
          } finally {
            isLoading.value = false;
          }
        },

        // ✅ VERIFICATION FAILED
        verificationFailed: (FirebaseAuthException e) {
          debugPrint('🔥 PHONE-AUTH-ERROR → ${e.code} : ${e.message}');
          JLoaders.errorSnackBar(
            title: 'OTP Error',
            message: '${e.code} : ${e.message}',
          );
          isLoading.value = false;
        },

        // ✅ OTP SENT SUCCESSFULLY
        codeSent: (String verificationId, int? resendToken) {
          this.verificationId.value = verificationId;
          JLoaders.successSnackBar(
            title: 'OTP Sent',
            message: 'Check your phone for the OTP.',
          );
          isLoading.value = false;

          // Navigate to OTP Verification screen
          Get.to(() => OTPVerificationScreen());
        },

        // ✅ AUTO RETRIEVAL TIMEOUT
        codeAutoRetrievalTimeout: (String verificationId) {
          this.verificationId.value = verificationId;
          debugPrint("⌛ Code auto-retrieval timed out, waiting for manual input.");
        },
      );
    } catch (e) {
      isLoading.value = false;
      JLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  /// -------------------- VERIFY OTP MANUALLY --------------------
  Future<UserCredential?> verifyOtp(String passedVerificationId) async {
    isLoading.value = true;
    try {
      // ✅ Skip manual verification if already signed in
      if (_auth.currentUser != null) {
        JLoaders.successSnackBar(
          title: 'Already Verified',
          message: 'You are already signed in.',
        );
        isLoading.value = false;
        Get.offAll(() => const NavigationMenu());
        return null;
      }

      final credential = PhoneAuthProvider.credential(
        verificationId: passedVerificationId,
        smsCode: otpController.text.trim(),
      );

      final userCredential = await _auth.signInWithCredential(credential);

      // Save verification status
      localStorage.write('isUserVerified', true);

      // Save user record
      final userController = Get.put(UserController());
      await userController.saveUserRecord(userCredential);

      isLoading.value = false;

      // ✅ Show success and redirect manually
      JLoaders.successSnackBar(
        title: 'OTP Verified',
        message: 'Verification successful!',
      );

      Future.delayed(const Duration(milliseconds: 300), () {
        Get.offAll(() => const NavigationMenu());
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;

      if (e.code == 'session-expired') {
        JLoaders.errorSnackBar(
          title: 'Session Expired',
          message: 'Your OTP session has expired. Please request a new OTP.',
        );
      } else if (e.code == 'invalid-verification-code') {
        JLoaders.errorSnackBar(
          title: 'Invalid OTP',
          message: 'The OTP entered is incorrect.',
        );
      } else {
        JLoaders.errorSnackBar(
          title: 'OTP Error',
          message: e.message ?? 'Verification failed.',
        );
      }
      return null;
    } catch (e) {
      isLoading.value = false;
      JLoaders.errorSnackBar(title: 'Error', message: e.toString());
      return null;
    }
  }

  /// -------------------- LOGOUT --------------------
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    localStorage.remove('isUserVerified');
    Get.offAll(() => const LoginScreen());
  }
}
