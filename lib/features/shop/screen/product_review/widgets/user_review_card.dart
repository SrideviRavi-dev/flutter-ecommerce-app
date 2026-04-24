import 'package:flutter/material.dart';
import 'package:myapp/utils/constant/sizes.dart';

class UserReviewCard extends StatelessWidget {
  final String userName;
  final double rating;
  final String reviewText;
  final DateTime date;

  const UserReviewCard({
    super.key,
    required this.userName,
    required this.rating,
    required this.reviewText,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: JSizes.spaceBtwItems),
      child: Padding(
        padding: const EdgeInsets.all(JSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(userName, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 16),
                const SizedBox(width: 4),
                Text(rating.toString(), style: Theme.of(context).textTheme.bodyMedium),
                const Spacer(),
                Text('${date.day}/${date.month}/${date.year}',
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
            const SizedBox(height: 8),
            Text(reviewText, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
