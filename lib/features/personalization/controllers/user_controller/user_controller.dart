import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/features/authentication/model/user_model.dart';
import 'package:myapp/features/authentication/screens/login/login.dart';
import 'package:myapp/features/personalization/re_auth_login/re_auth_login_form.dart';
import 'package:myapp/repositoires/authentication/auth_rep.dart';
import 'package:myapp/repositoires/user/user_rep.dart';
import 'package:myapp/utils/constant/image_string.dart';
import 'package:myapp/utils/constant/sizes.dart';
import 'package:myapp/utils/loaders/snackbar_loaders.dart';
import 'package:myapp/utils/popups/full_screen_loader.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  final profileLoading = false.obs;
  Rx<UserModel> user = UserModel.empty().obs;

  final hidePassword = false.obs;
  final imageUploading = false.obs;
  final verifyEmail = TextEditingController();
  final verifyPassword = TextEditingController();
  final userRepository = Get.put(UserRepository());
  GlobalKey<FormState> reAuthFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    fetchUserRecord();
  }

  /// ✅ Fetch user record from Firestore
  Future<void> fetchUserRecord() async {
    try {
      profileLoading.value = true;
      final userData = await userRepository.fetchUserDetails();
      user(userData);
    } catch (e) {
      user(UserModel.empty());
    } finally {
      profileLoading.value = false;
    }
  }

  /// ✅ Save user record from UserCredential (manual OTP or signup)
  Future<void> saveUserRecord(UserCredential? userCredentials) async {
    try {
      await fetchUserRecord();

      if (user.value.id.isEmpty && userCredentials?.user != null) {
        final firebaseUser = userCredentials!.user!;
        final nameParts = UserModel.nameParts(firebaseUser.displayName ?? '');
        final userName = UserModel.generateUsername(firebaseUser.displayName ?? '');

        final userModel = UserModel(
          id: firebaseUser.uid,
          firstName: nameParts.isNotEmpty ? nameParts[0] : '',
          lastName: nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '',
          userName: userName,
          email: firebaseUser.email ?? '',
          phoneNumber: firebaseUser.phoneNumber ?? '',
          profilPicture: firebaseUser.photoURL ?? '',
        );

        await userRepository.saveUserRecord(userModel);
      }
    } catch (e) {
      JLoaders.warningSnackBar(
        title: 'Data not Saved',
        message:
            'Something went wrong saving your info. You can re-save it in Profile.',
      );
    }
  }

  /// ✅ Save user record directly from Firebase User (auto verification)
  Future<void> saveUserRecordFromUser(User? firebaseUser) async {
    if (firebaseUser == null) return;

    try {
      await fetchUserRecord();

      // Save only if record doesn’t exist
      if (user.value.id.isEmpty) {
        final nameParts = UserModel.nameParts(firebaseUser.displayName ?? '');
        final userName = UserModel.generateUsername(firebaseUser.displayName ?? '');

        final userModel = UserModel(
          id: firebaseUser.uid,
          firstName: nameParts.isNotEmpty ? nameParts[0] : '',
          lastName: nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '',
          userName: userName,
          email: firebaseUser.email ?? '',
          phoneNumber: firebaseUser.phoneNumber ?? '',
          profilPicture: firebaseUser.photoURL ?? '',
        );

        await userRepository.saveUserRecord(userModel);
      }
    } catch (e) {
      JLoaders.warningSnackBar(
        title: 'Data not Saved',
        message:
            'Something went wrong saving your info (auto verification). You can re-save it in Profile.',
      );
    }
  }

  /// ✅ Delete Account Warning Popup
  void deleteAccountWarningPopup() {
    Get.defaultDialog(
      contentPadding: const EdgeInsets.all(JSizes.md),
      title: 'Delete Account',
      middleText:
          'Are you sure you want to delete your account permanently? This action cannot be undone.',
      confirm: ElevatedButton(
        onPressed: () async => deleteUserAccount(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          side: const BorderSide(color: Colors.red),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: JSizes.lg),
          child: Text('Delete'),
        ),
      ),
      cancel: OutlinedButton(
        onPressed: () => Navigator.of(Get.overlayContext!).pop(),
        child: const Text('Cancel'),
      ),
    );
  }

  /// ✅ Delete User Account
  void deleteUserAccount() async {
    try {
      JFullScreenLoader.openLoadingDialog('Processing', JImages.lodinggif);
      final auth = AuthenticationRepository.instance;
      final provider = auth.authUser!.providerData.map((e) => e.providerId).first;

      if (provider.isNotEmpty) {
        if (provider == 'google.com') {
          await auth.deleteAccount();
          JFullScreenLoader.stopLoading();
          Get.offAll(() => const LoginScreen());
        } else if (provider == 'password') {
          JFullScreenLoader.stopLoading();
          Get.to(() => const ReAuthLoginForm());
        }
      }
    } catch (e) {
      JFullScreenLoader.stopLoading();
      JLoaders.warningSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  /// ✅ Upload User Profile Picture
  Future<void> uploadUserProfilePicture() async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        maxHeight: 512,
        maxWidth: 512,
      );

      if (image != null) {
        imageUploading.value = true;
        final imageUrl =
            await userRepository.uploadImage('users/images/profile/', image);

        Map<String, dynamic> json = {'ProfilPicture': imageUrl};
        await userRepository.updateSingleField(json);

        user.value.profilPicture = imageUrl;
        user.refresh();

        JLoaders.successSnackBar(
          title: 'Congratulations',
          message: 'Your profile picture has been uploaded successfully!',
        );
      }
    } catch (e) {
      JLoaders.errorSnackBar(
        title: 'Oh Snap!',
        message: 'Something went wrong: $e',
      );
    } finally {
      imageUploading.value = false;
    }
  }
}
