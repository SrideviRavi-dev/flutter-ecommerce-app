// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:myapp/utils/constant/colors.dart';
import 'package:myapp/utils/constant/sizes.dart';

class JProductOfferText extends StatelessWidget {
  const JProductOfferText({
    super.key,
    required this.offerPercentage,
  });

  final String offerPercentage;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          offerPercentage,
          // You can change this to any color you prefer
          style: Theme.of(context)
              .textTheme
              .headlineLarge!
              .apply(color: JColors.error.withOpacity(0.9)),
        ),
         const SizedBox(width: JSizes.spaceBtwItems / 2),
        Text('off',
        style: Theme.of(context)
              .textTheme
              .titleLarge!
              .apply(color: JColors.error.withOpacity(0.9)),
        )
      ],
    );
    // Adjust the font size as needed
  }
}
