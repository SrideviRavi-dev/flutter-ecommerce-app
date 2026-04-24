import 'package:flutter/material.dart';
import 'package:myapp/features/shop/screen/product_review/widgets/process_indigator_and_rating.dart';

class JOverallProductRating extends StatelessWidget {
  final double averageRating;
  final Map<int, int> ratingCounts; // Example: {5: 30, 4: 10, 3: 5, 2: 2, 1: 3}

  const JOverallProductRating({
    super.key,
    required this.averageRating,
    required this.ratingCounts,
  });

  @override
  Widget build(BuildContext context) {
    // Total number of ratings
    final int totalRatings = ratingCounts.values.fold(0, (a, b) => a + b);

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            averageRating.toStringAsFixed(1),
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ),
        Expanded(
          flex: 7,
          child: Column(
            children: List.generate(5, (index) {
              final star = 5 - index; // from 5 to 1
              final count = ratingCounts[star] ?? 0;
              final value = totalRatings > 0 ? count / totalRatings : 0.0;

              return JRatingProgressIndicator(
                text: star.toString(),
                value: value,
              );
            }),
          ),
        ),
      ],
    );
  }
}
