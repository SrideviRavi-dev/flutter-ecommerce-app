// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteProduct {
  final String productId;
  final String title;
  final String imageUrl;
  final String price;
  final String salePrice;

  FavoriteProduct({
    required this.productId,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.salePrice,
  });
}

class FavoriteService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add a product to favorites
  Future<void> addFavorite(FavoriteProduct product) async {
    try {
      await _db.collection('favorites').doc(product.productId).set({
        'productId': product.productId,
        'title': product.title,
        'imageUrl': product.imageUrl,
        'price': product.price,
        'salePrice': product.salePrice,
      });
    } catch (e) {
      print('Error adding favorite: $e');
    }
  }

  // Remove a product from favorites
  Future<void> removeFavorite(String productId) async {
    try {
      await _db.collection('favorites').doc(productId).delete();
    } catch (e) {
      print('Error removing favorite: $e');
    }
  }

  // Fetch all favorite products
  Future<List<FavoriteProduct>> fetchFavorites() async {
    try {
      final snapshot = await _db.collection('favorites').get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return FavoriteProduct(
          productId: data['productId'],
          title: data['title'],
          imageUrl: data['imageUrl'],
          price: data['price'],
          salePrice: data['salePrice'],
        );
      }).toList();
    } catch (e) {
      print('Error fetching favorites: $e');
      return [];
    }
  }
}
