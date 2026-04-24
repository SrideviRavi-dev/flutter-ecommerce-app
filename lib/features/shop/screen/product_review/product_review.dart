import 'package:flutter/material.dart';
import 'package:myapp/common/widgets/appbar/appbar.dart';
import 'package:myapp/common/widgets/product/rating/rating_indicator.dart';
import 'package:myapp/features/shop/models/review_model/review_model.dart';
import 'package:myapp/features/shop/screen/product_review/widgets/rating_process_indicator.dart';
import 'package:myapp/features/shop/screen/product_review/widgets/user_review_card.dart';
import 'package:myapp/services/review_service/review_service.dart';
import 'package:myapp/utils/constant/sizes.dart';

class ProductReviewsScreen extends StatefulWidget {
  final String productId;

  const ProductReviewsScreen({super.key, required this.productId});

  @override
  State<ProductReviewsScreen> createState() => _ProductReviewsScreenState();
}

class _ProductReviewsScreenState extends State<ProductReviewsScreen> {
  late Future<List<ProductReview>> _reviewsFuture;

  @override
  void initState() {
    super.initState();
    _reviewsFuture = fetchReviews(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const JAppBar(
        title: Text('Reviews & Ratings'),
        showBackArrow: true,
      ),
      body: FutureBuilder<List<ProductReview>>(
        future: _reviewsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No reviews found.'));
          }

          final reviews = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(JSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Ratings and reviews are verified and are from people who use the same type of devices that you use.",
                ),
                const SizedBox(height: JSizes.spaceBtwItems),

                /// Overall Rating - optional
                const JOverallProductRating(
                  averageRating: 4.8,
                  ratingCounts: {5: 100, 4: 40, 3: 20, 2: 10, 1: 5},
                ),
                const JRatingBarIndicator(rating: 4.0),
                Text('${reviews.length}',
                    style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: JSizes.spaceBtwSections),

                /// User Reviews
                ...reviews.map((review) => UserReviewCard(
                      userName: review.userName,
                      rating: review.rating,
                      reviewText: review.review,
                      date: review.timestamp,
                    )),
              ],
            ),
          );
        },
      ),
    );
  }
}
