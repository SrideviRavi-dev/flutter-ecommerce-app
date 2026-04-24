import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/features/shop/models/review_model/review_model.dart';

Future<List<ProductReview>> fetchReviews(String productId) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('product_reviews')
      .where('productId', isEqualTo: productId)
      .orderBy('timestamp', descending: true)
      .get();

  return snapshot.docs
      .map((doc) => ProductReview.fromMap(doc.data()))
      .toList();
}
