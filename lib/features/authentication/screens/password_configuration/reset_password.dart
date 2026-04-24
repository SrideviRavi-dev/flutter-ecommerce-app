import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/features/authentication/controllers/forgot_password.dart/forgot_password_Controller.dart';
import 'package:myapp/features/authentication/screens/login/login.dart';
import 'package:myapp/utils/constant/image_string.dart';
import 'package:myapp/utils/constant/sizes.dart';
import 'package:myapp/utils/constant/text_string.dart';
import 'package:myapp/utils/helpers/helper_function.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key,
   required this.email
   });
  final String email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(CupertinoIcons.clear))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(JSizes.defaultSpace),
          child: Column(
            children: [
              Image(
                image: const AssetImage(JImages.verifyEmail),
                width: JHelperFunction.screenWidth() * 0.6,
              ),
              const SizedBox(
                height: JSizes.spaceBtwItems,
              ),
              Text(
                email,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: JSizes.spaceBtwItems,
              ),
              Text(
                JTexts.changeYourPasswordSubTitle,
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: JSizes.spaceBtwSections,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () => Get.offAll(() => const LoginScreen()),
                    child: const Text(JTexts.done)),
              ),
              const SizedBox(
                height: JSizes.spaceBtwItems,
              ),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                    onPressed: () => ForgotPasswordController.instance.resendPasswordResetEmail(email),
                    child: const Text(JTexts.resendEmail)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
