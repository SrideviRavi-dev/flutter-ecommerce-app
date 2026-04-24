import 'package:flutter/material.dart';
import 'package:myapp/common/shimmer_effect/shimmer_effect.dart';
import 'package:myapp/utils/constant/sizes.dart';

class JBoxesShimmer extends StatelessWidget {
  const JBoxesShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          children: [
            Expanded(child: JShimmerEffect(width: 150, height: 110)),
            SizedBox(width: JSizes.spaceBtwItems),
            Expanded(child: JShimmerEffect(width: 150, height: 110)),
            SizedBox(width: JSizes.spaceBtwItems),
            Expanded(child: JShimmerEffect(width: 150, height: 110)),
          ],
        )
      ],
    );
  }
}
