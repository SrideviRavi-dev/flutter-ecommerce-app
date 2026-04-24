import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/features/authentication/controllers/signup/signup_controller.dart';
import 'package:myapp/utils/constant/colors.dart';
import 'package:myapp/utils/constant/sizes.dart';
import 'package:myapp/utils/constant/text_string.dart';
import 'package:myapp/utils/helpers/helper_function.dart';

class JTermsAndConditionCheckBox extends StatelessWidget {
  const JTermsAndConditionCheckBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = SignupController.instance;
    final dark = JHelperFunction.isDarkMode(context);
    return Row(
      children: [
        SizedBox(
          width: 24,
          height: 60,
          child: Obx(
            () => Checkbox(
                value: controller.privacyPolicy.value,
                onChanged: (value) => controller.privacyPolicy.value =
                    !controller.privacyPolicy.value),
          ),
        ),
        const SizedBox(
          height: JSizes.spaceBtwItems,
        ),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                  text: '  ${JTexts.iAgreeTo} ',
                  style: Theme.of(context).textTheme.bodySmall),
              TextSpan(
                  text: '${JTexts.privacyPolicy} ',
                  style: Theme.of(context).textTheme.bodyMedium!.apply(
                        color: dark ? JColors.white : JColors.buttonPrimary,
                        decoration: TextDecoration.underline,
                        decorationColor:
                            dark ? JColors.white : JColors.buttonPrimary,
                      )),
              TextSpan(
                  text: '${JTexts.and} ',
                  style: Theme.of(context).textTheme.bodySmall),
              TextSpan(
                  text: JTexts.termsOfUse,
                  style: Theme.of(context).textTheme.bodyMedium!.apply(
                        color: dark ? JColors.white : JColors.buttonPrimary,
                        decoration: TextDecoration.underline,
                        decorationColor:
                            dark ? JColors.white : JColors.buttonPrimary,
                      )),
            ],
          ),
        ),
      ],
    );
  }
}
