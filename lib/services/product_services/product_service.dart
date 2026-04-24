// ignore_for_file: avoid_print, unnecessary_cast

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/features/shop/models/product_model/product_model.dart';

class ProductService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch all products
  Future<List<Product>> fetchProducts() async {
    final snapshot = await _db.collection('products').get();

    if (snapshot.docs.isEmpty) {}

    return snapshot.docs.map((doc) {
      return Product.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }

  Future<List<Product>> fetchInitialProducts({int limit = 10}) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('products')
     //   .orderBy('timestamp', descending: true) // 👈 Must have 'timestamp' field in Firestore
        .limit(limit)
        .get();

    return snapshot.docs
        .map((doc) => Product.fromFirestore(doc.data(), doc.id))
        .toList();
  }

  Future<List<Product>> fetchMoreProducts({
  required int limit,
  required DocumentSnapshot lastDocument,
}) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('products')
      //.orderBy('timestamp', descending: true) ✅ Enable later if timestamp exists
      .startAfterDocument(lastDocument)
      .limit(limit)
      .get();

  return snapshot.docs.map((doc) {
    return Product.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
  }).toList();
}


  // Fetch products by category ID
  Future<List<Product>> fetchProductsByCategory(String categoryId) async {
    final snapshot = await _db
        .collection('products')
        .where('categoryId', isEqualTo: categoryId)
        .get();

    if (snapshot.docs.isEmpty) {
    } else {
      for (var doc in snapshot.docs) {
        print('Product Data: ${doc.data()}');
      }
    }

    return snapshot.docs.map((doc) {
      return Product.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }

  // Fetch product details by product ID
  Future<Product> fetchProductDetails(String productId) async {
    final snapshot = await _db.collection('products').doc(productId).get();

    if (!snapshot.exists) {
      throw Exception('Product not found');
    }

    return Product.fromFirestore(
        snapshot.data() as Map<String, dynamic>, snapshot.id);
  }

  Future<List<Product>> fetchSimilarProducts(String categoryId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('products')
          .where('categoryId', isEqualTo: categoryId)
          .get();

      if (snapshot.docs.isEmpty) {
        print('No documents found for this category.');
        return [];
      }

      return snapshot.docs.map((doc) {
        return Product.fromFirestore(
            doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print('Error fetching similar products: $e');
      return [];
    }
  }

  Future<List<Product>> fetchProductsByCategoryLimited(
      String categoryId, int limit) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('categoryId', isEqualTo: categoryId)
        .limit(limit)
        .get();

    return snapshot.docs
        .map((doc) => Product.fromFirestore(doc.data(), doc.id))
        .toList();
  }
}
