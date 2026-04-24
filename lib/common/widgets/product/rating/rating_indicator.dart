import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:myapp/utils/constant/colors.dart';

class JRatingBarIndicator extends StatelessWidget {
  const JRatingBarIndicator({
    super.key,
    required this.rating,
  });

  final double rating;

  @override
  Widget build(BuildContext context) {
    return RatingBarIndicator(
        rating: rating,
        itemSize: 20,
        unratedColor: JColors.grey,
        itemBuilder: (_, __) =>const Icon(
              Iconsax.star1,
              color: JColors.primary,
            ));
  }
}
