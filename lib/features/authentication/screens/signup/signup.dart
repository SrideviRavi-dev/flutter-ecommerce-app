import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/features/authentication/controllers/auth_controller/auth_controller.dart';
import 'package:myapp/utils/constant/sizes.dart';
import 'package:myapp/utils/constant/text_string.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthController());
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(JSizes.defaultSpace),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'assets/logos/new_logo.png', 
                height: 100, // Adjust the height as needed
              ),
            ),
            const SizedBox(height: JSizes.sm),
            Text(
              JTexts.signUpTitle,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: JSizes.sm),
            Text(
              JTexts.loginTitle,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: JSizes.lg),
            TextField(
              controller: controller.phoneNumberController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: JTexts.phoneNo,
                prefixText: '+91 ',
              ),
            ),
            const SizedBox(height: JSizes.spaceBtwInputFields),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.sendOtp(),
                child: const Text(JTexts.sentotp),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
