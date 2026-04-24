// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/features/shop/controllers/image_uploader/image_uploader.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final ImageUploader _imageUploader =
      ImageUploader(); // Instance of ImageUploader

  Future<void> addCategory(String name, String imageUrl) async {
    await _db.collection('categories').add({
      'name': name,
      'image': imageUrl,
    });
  }

  // Method to add a banner from gallery
  // Method to add a banner from the gallery
  Future<void> addBannerFromGallery() async {
    try {
      String? imageUrl = await _imageUploader.uploadImage('banners');

      if (imageUrl != null) {
        await _db.collection('promotions').add({
          'imageUrl': imageUrl,
        });
      } else {
        print('No image selected or upload failed.');
      }
    } catch (e) {
      print('Error adding banner: $e');
    }
  }

  // Method to add a product to favorites
//   Future<void> toggleFavorite(String productId, String title, String imageUrl, String price, bool isFavorite) async {
//   if (isFavorite) {
//     await _db.collection('favorites').doc(productId).delete();
//     print('Removed from favorites: $productId');
//   } else {
//     await _db.collection('favorites').doc(productId).set({
//       'productId': productId,
//       'title': title,
//       'imageUrl': imageUrl,
//       'price': price,
//     });
//     print('Added to favorites: $productId');
//   }
// }
}
