import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:myapp/features/authentication/controllers/login/login_controller.dart';
import 'package:myapp/features/authentication/screens/password_configuration/forgot_password.dart';
import 'package:myapp/utils/constant/sizes.dart';
import 'package:myapp/utils/constant/text_string.dart';
import 'package:myapp/utils/validator/validator.dart';
import '../../signup/signup.dart';


class JLoginForm extends StatelessWidget {
  const JLoginForm({super.key});

  @override
  Widget build(BuildContext context) {
     final controller = Get.put(LoginController());
    return Form(
       key: controller.loginFormKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: JSizes.spaceBtwSections),
        child: Column(
          children: [
            TextFormField(
              controller: controller.email,
              validator: (value) => JValidator.validateEmail(value),
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.direct_right),
                labelText: JTexts.email,
              ),
            ),
            const SizedBox(height: JSizes.spaceBtwInputFields),
             Obx(
               ()=> TextFormField(
                  controller: controller.password,
                  validator: (value) => JValidator.validatePassword(value),
                    obscureText: controller.hidePassword.value,
                  decoration: InputDecoration(
                    labelText: JTexts.password,
                    prefixIcon: const Icon(Iconsax.password_check),
                    suffixIcon: IconButton(
                      onPressed: () => controller.hidePassword.value =
                          !controller.hidePassword.value,
                      icon: Icon(controller.hidePassword.value
                          ? Iconsax.eye_slash
                          : Iconsax.eye),
                     
                    ),
                  ),
                ),
             ),
            
            const SizedBox(height: JSizes.spaceBtwInputFields / 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Obx(
                      ()=> Checkbox(
                          value: controller.rememberMe.value,
                          onChanged: (value) => controller.rememberMe.value =
                              !controller.rememberMe.value
                        
                      ),
                    ),
                    const Text(JTexts.rememberMe),
                  ],
                ),
                TextButton(
                    onPressed: () => Get.to(()=>const ForgotPassword()),
                    //onPressed: () => Get.to(() => const ForgotPassword()),
                    child: const Text(JTexts.forgotPassword))
              ],
            ),
            const SizedBox(
              height: JSizes.spaceBtwSections,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                
                   onPressed: () =>  controller.emailAndPasswordSignIn(),
                  child: const Text(JTexts.signIn)),
            ),
            const SizedBox(
              height: JSizes.spaceBtwItems,
            ),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                  //onPressed: () {},
                   onPressed: () => Get.to(() => const SignUpScreen()),
                  child: const Text(JTexts.createAccount)),
            ),
          ],
        ),
      ),
    );
  }
}
