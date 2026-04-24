import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:myapp/features/authentication/screens/login/login.dart';
import 'package:myapp/navigation_manu.dart';
import 'package:myapp/repositoires/user/user_rep.dart';
import 'package:myapp/utils/exception/firebase_auth_exception.dart';
import 'package:myapp/utils/exception/firebase_exception.dart';
import 'package:myapp/utils/exception/format_exception.dart';
import 'package:myapp/utils/exception/platform_exception.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final deviceStorage = GetStorage();
  final _auth = FirebaseAuth.instance;
  final localStorage = GetStorage();

  //Get Authendicated User Data
  User? get authUser => _auth.currentUser;

  @override
  void onInit() {
    super.onInit();
    // Ensure we have a widget frame before navigating
    WidgetsBinding.instance.addPostFrameCallback((_) => screenRedirect());
  }

 Future<void> screenRedirect() async {
  try {
    debugPrint('🔹 screenRedirect() called');
    final user = _auth.currentUser;
    final bool isUserVerified = localStorage.read('isUserVerified') ?? false;

    await Future.delayed(const Duration(milliseconds: 300)); // Allow rebuild

    if (user != null && isUserVerified) {
      debugPrint('➡️ Redirecting to NavigationMenu...');
      Get.offAll(() => const NavigationMenu());
    } else {
      debugPrint('➡️ Redirecting to LoginScreen...');
      Get.offAll(() => const LoginScreen());
    }
  } catch (e) {
    debugPrint("🔴 Error during screen redirect: $e");
    Get.offAll(() => const LoginScreen());
  } finally {
    FlutterNativeSplash.remove();
  }
}


  /* ------------------------Email & Password sign in ----------------------------*/

  /// SignIn
  // Future<UserCredential> loginWithEmailAndPassword(
  //     String email, String password) async {
  //   try {
  //     return await _auth.signInWithEmailAndPassword(
  //         email: email, password: password);
  //   } on FirebaseAuthException catch (e) {
  //     throw JFirebaseAuthException(e.code).message;
  //   } on FirebaseException catch (e) {
  //     throw JFirebaseException(e.code).message;
  //   } on FormatException catch (_) {
  //     throw const JFormatException();
  //   } on PlatformException catch (e) {
  //     throw JPlatformException(e.code).message;
  //   } catch (e) {
  //     throw 'Something went wrong. Please try again';
  //   }
  // }

  // /// Register
  // Future<UserCredential> registerWithEmailPassword(
  //     String email, String password) async {
  //   try {
  //     return await _auth.createUserWithEmailAndPassword(
  //         email: email, password: password);
  //   } on FirebaseAuthException catch (e) {
  //     throw JFirebaseAuthException(e.code).message;
  //   } on FirebaseException catch (e) {
  //     throw JFirebaseException(e.code).message;
  //   } on FormatException catch (_) {
  //     throw const JFormatException();
  //   } on PlatformException catch (e) {
  //     throw JPlatformException(e.code).message;
  //   } catch (e) {
  //     throw 'Something went wrong. Please try again';
  //   }
  // }

  // /// Mail verification

  // Future<void> sendEmailVerification() async {
  //   try {
  //     await _auth.currentUser?.sendEmailVerification();
  //   } on FirebaseAuthException catch (e) {
  //     throw JFirebaseAuthException(e.code).message;
  //   } on FirebaseException catch (e) {
  //     throw JFirebaseException(e.code).message;
  //   } on FormatException catch (_) {
  //     throw const JFormatException();
  //   } on PlatformException catch (e) {
  //     throw JPlatformException(e.code).message;
  //   } catch (e) {
  //     throw 'Something went wrong. Please try again';
  //   }
  // }

  // /// ReAuthendicate

  // Future<void> reAuthenticateWithEmailAndPassword(
  //     String email, String password) async {
  //   try {
  //     AuthCredential credential =
  //         EmailAuthProvider.credential(email: email, password: password);

  //     await _auth.currentUser!.reauthenticateWithCredential(credential);
  //   } on FirebaseAuthException catch (e) {
  //     throw JFirebaseAuthException(e.code).message;
  //   } on FirebaseException catch (e) {
  //     throw JFirebaseException(e.code).message;
  //   } on FormatException catch (_) {
  //     throw const JFormatException();
  //   } on PlatformException catch (e) {
  //     throw JPlatformException(e.code).message;
  //   } catch (e) {
  //     throw 'Something went wrong. Please try again';
  //   }
  // }

  // /// forgot password

  // Future<void> sendPasswordResetEmail(String email) async {
  //   try {
  //     await _auth.sendPasswordResetEmail(email: email);
  //   } on FirebaseAuthException catch (e) {
  //     throw JFirebaseAuthException(e.code).message;
  //   } on FirebaseException catch (e) {
  //     throw JFirebaseException(e.code).message;
  //   } on FormatException catch (_) {
  //     throw const JFormatException();
  //   } on PlatformException catch (e) {
  //     throw JPlatformException(e.code).message;
  //   } catch (e) {
  //     throw 'Something went wrong. Please try again';
  //   }
  // }

  /* ------------------------ Federated identity & social  sign in ----------------------------*/

  /// Remove user Auth and Firestore account.

  Future<void> deleteAccount() async {
    try {
      await UserRepository.instance.removeUserRecord(_auth.currentUser!.uid);
      await _auth.currentUser?.delete();
    } on FirebaseAuthException catch (e) {
      throw JFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw JFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const JFormatException();
    } on PlatformException catch (e) {
      throw JPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Get.offAll(() => const LoginScreen());
    } on FirebaseAuthException catch (e) {
      throw JFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw JFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const JFormatException();
    } on PlatformException catch (e) {
      throw JPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

   
}
