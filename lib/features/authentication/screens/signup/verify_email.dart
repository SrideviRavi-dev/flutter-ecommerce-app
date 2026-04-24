import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/features/authentication/controllers/signup/verify_emailcontroller.dart';
import 'package:myapp/repositoires/authentication/auth_rep.dart';
import 'package:myapp/utils/constant/image_string.dart';
import 'package:myapp/utils/constant/sizes.dart';
import 'package:myapp/utils/constant/text_string.dart';
import 'package:myapp/utils/helpers/helper_function.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key, this.email});
  final String? email;
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VerifyEmailController());
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () => AuthenticationRepository.instance.logout(),
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
                JTexts.confirmEmail,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: JSizes.spaceBtwItems,
              ),
              Text(
                email ?? '',
                style: Theme.of(context).textTheme.labelLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: JSizes.spaceBtwItems,
              ),
              Text(
                JTexts.confirmEmailSubTitle,
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: JSizes.spaceBtwSections,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () => controller.checkEmailVerificationStatus(),
                    child: const Text(JTexts.jContinue)),
              ),
              const SizedBox(
                height: JSizes.spaceBtwItems,
              ),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                   onPressed: () => controller.sendEmailVerification(),
                  child: const Text(JTexts.resendEmail),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
