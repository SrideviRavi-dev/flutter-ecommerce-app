// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:myapp/common/style/spacing_style.dart';
import 'package:myapp/utils/constant/sizes.dart';
import 'package:myapp/utils/constant/text_string.dart';
import 'package:myapp/utils/helpers/helper_function.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen(
      {super.key,
      required this.image,
      required this.title,
      required this.subTitle,
      required this.onPressed});

  final String image;
  final String title;
  final String subTitle;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    // final screenWidth = JHelperFunction.screenWidth(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: JSpacingStyle.paddingInAppBarHeight * 2,
          child: Column(
            children: [
              Image(
                image: AssetImage(image),
                width: JHelperFunction.screenWidth() * 0.6,
              ),
              const SizedBox(
                height: JSizes.spaceBtwItems,
              ),

              /// Title & subTitle
              Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: JSizes.spaceBtwItems),
              Text(
                subTitle,
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: JSizes.spaceBtwItems),

              /// button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      print('✅ Continue button tapped');
                      onPressed();
                    },
                    child: const Text(JTexts.jContinue)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
