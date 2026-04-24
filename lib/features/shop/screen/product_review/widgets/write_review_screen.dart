// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:myapp/utils/constant/colors.dart';
import 'package:myapp/utils/constant/sizes.dart';

class WriteReviewScreen extends StatefulWidget {
  final String productId;
  final String title;

  const WriteReviewScreen({
    super.key,
    required this.productId,
    required this.title,
  });

  @override
  State<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends State<WriteReviewScreen> {
  double _rating = 3;
  final TextEditingController _controller = TextEditingController();
  bool _isSubmitting = false;

 Future<void> _submitReview() async {
  setState(() => _isSubmitting = true);

  final currentUser = FirebaseAuth.instance.currentUser;
  String userName = 'Guest';

  if (currentUser != null) {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser.uid)
          .get();

      if (userDoc.exists) {
        final userData = userDoc.data();
        if (userData != null && userData.containsKey('UserName')) {
          userName = userData['UserName'];
        } else {
          debugPrint("⚠️ 'UserName' not found in document.");
        }
      } else {
        debugPrint("⚠️ User document does not exist for UID: ${currentUser.uid}");
      }
    } catch (e) {
      debugPrint("🔥 Error fetching user data: $e");
    }
  }

  // Submit the review to Firestore
  await FirebaseFirestore.instance.collection('product_reviews').add({
    'productId': widget.productId,
    'title': widget.title,
    'rating': _rating,
    'review': _controller.text.trim(),
    'timestamp': Timestamp.now(),
    'userName': userName,
  });

  setState(() => _isSubmitting = false);
  Navigator.pop(context);
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Write a Review"),
        backgroundColor: JColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(JSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Review for: ${widget.title}",
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            RatingBar.builder(
              initialRating: _rating,
              minRating: 1,
              itemCount: 5,
              allowHalfRating: true,
              itemBuilder: (context, _) => const Icon(Icons.star, color: JColors.primary),
              onRatingUpdate: (rating) {
                setState(() => _rating = rating);
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Write your review...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _isSubmitting ? null : _submitReview,
              icon: const Icon(Icons.send),
              label: const Text("Submit"),
              style: ElevatedButton.styleFrom(backgroundColor: JColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}
