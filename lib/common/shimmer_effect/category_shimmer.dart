import 'package:flutter/material.dart';
import 'package:myapp/common/shimmer_effect/shimmer_effect.dart';
import 'package:myapp/utils/constant/sizes.dart';

class JCategoryShimmer extends StatelessWidget {
  const JCategoryShimmer({
    super.key,
    this.itemCount = 10,
  });

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: itemCount,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (_, __) =>
            const SizedBox(width: JSizes.spaceBtwItems),
        itemBuilder: (_, __) {
          return const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Image

              JShimmerEffect(width: 55, height: 55, radius: 55),
              SizedBox(height: JSizes.spaceBtwItems / 2),

              /// Text

              JShimmerEffect(width: 55, height: 8),
            ],
          );
        },
      ),
    );
  }
}
