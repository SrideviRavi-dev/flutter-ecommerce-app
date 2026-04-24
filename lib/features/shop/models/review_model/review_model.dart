import 'package:cloud_firestore/cloud_firestore.dart';

class ProductReview {
  final String userName;
  final double rating;
  final String review;
  final DateTime timestamp;

  ProductReview({
    required this.userName,
    required this.rating,
    required this.review,
    required this.timestamp,
  });

  factory ProductReview.fromMap(Map<String, dynamic> data) {
    return ProductReview(
      userName: data['userName'] ?? '',
      rating: (data['rating'] ?? 0).toDouble(),
      review: data['review'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }
}
