import 'package:cloud_firestore/cloud_firestore.dart';

class Banner {
  final String imageUrl;

  Banner({required this.imageUrl});

  factory Banner.fromFirestore(DocumentSnapshot doc) {
    return Banner(
      imageUrl: doc['imageUrl'] ?? '',
    );
  }
}
