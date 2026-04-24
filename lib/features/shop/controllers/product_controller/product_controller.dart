// ignore_for_file: avoid_print, unnecessary_cast, unnecessary_type_check, unused_field

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:myapp/features/shop/models/product_model/product_model.dart';
import 'package:myapp/services/product_services/product_service.dart';

class ProductController extends GetxController {
  var products = <Product>[].obs;
  var isLoading = true.obs;
  var hasError = false.obs;
  var searchQuery = ''.obs;
  var similarProducts = <Product>[].obs;
  var filteredProducts = <Product>[].obs;
  final ProductService _productService = ProductService();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  DocumentSnapshot? lastDocument;
  var isFetchingMore = false.obs;
  final int fetchLimit = 10;
  var searchSuggestions = <String>[].obs;   

  @override
  void onInit() {
    super.onInit();
    fetchProducts(); // Fetch all products initially if needed
  }

  // 🔄 Fetch random 10 products by shuffling locally
  void fetchProducts() async {
    try {
      isLoading.value = true;

      final snapshot = await _db
          .collection('products')
          .limit(30) // Fetch more products
          .get();

      final allProducts = snapshot.docs
          .map((doc) => Product.fromFirestore(doc.data(), doc.id))
          .toList();

      allProducts.shuffle(); // ✅ Randomize list

      final randomSet = allProducts.take(fetchLimit).toList();

      products.assignAll(randomSet);  
      filteredProducts.assignAll(randomSet);

      lastDocument = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;
      hasError.value = false;
    } catch (e) {
      hasError.value = true;
      print('Error fetching random products: $e');
    } finally {
      isLoading.value = false;
    }
  }



  Future<void> fetchMoreProducts() async {
    if (isFetchingMore.value || lastDocument == null) return;

    try {
      isFetchingMore.value = true;

      final snapshot = await _db
          .collection('products')
          //.orderBy('timestamp', descending: true)
          .startAfterDocument(lastDocument!)
          .limit(fetchLimit)
          .get();

      final newProducts = snapshot.docs
          .map((doc) => Product.fromFirestore(doc.data(), doc.id))
          .toList();

      if (newProducts.isNotEmpty) {
        products.addAll(newProducts);
        filteredProducts.assignAll(products);
        // ✅ Keep search results accurate
        searchProducts(searchQuery.value);
        lastDocument = snapshot.docs.last;
      }
    } catch (e) {
      print('Error fetching more: $e');
    } finally {
      isFetchingMore.value = false;
    }
  }

  // Fetch products by category ID
  Future<void> fetchProductsByCategory(String categoryId) async {
    try {
      isLoading.value = true;
      hasError.value = false;

      QuerySnapshot<Map<String, dynamic>> snapshot = await _db
          .collection('products')
          .where('categoryId', isEqualTo: categoryId)
          .get();

      final fetchedProducts = snapshot.docs
          .map((doc) => Product.fromFirestore(doc.data(), doc.id))
          .toList();

      products.value = fetchedProducts;
      filteredProducts.assignAll(fetchedProducts);
    } catch (e) {
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔍 Search Function (Case-Insensitive)
  void searchProducts(String query) {
    searchQuery.value = query;

    if (query.isEmpty) {
      filteredProducts.assignAll(products);
      searchSuggestions.clear();
      return;
    }

    final lowerQuery = query.toLowerCase();

    final results = products.where((product) {
      String titleText = '';

      if (product.title is String) {
        titleText = (product.title as String).toLowerCase();
      } else if (product.title is List) {
        final List titleList = product.title as List;
        titleText =
            titleList.map((item) => item.toString().toLowerCase()).join(' ');
      }

      final description = (product.description is String)
          ? (product.description as String).toLowerCase()
          : '';

      return titleText.contains(lowerQuery) || description.contains(lowerQuery);
    }).toList();

    filteredProducts.assignAll(results);

    /// ✅ Update suggestions list
    final suggestions = products
        .map((product) => product.title.toString())
        .where((title) => title.toLowerCase().contains(lowerQuery))
        .toSet() // Remove duplicates
        .take(5) // Limit to 5 suggestions
        .toList();

    searchSuggestions.assignAll(suggestions);
  }

  void resetProducts() {
    filteredProducts.assignAll(products);
  }

  // Add this method
  void filterProductsByCategory(String categoryId) {
    filteredProducts.assignAll(
      products.where((product) => product.categoryId == categoryId).toList(),
    );
    isLoading.value = false;
  }
}
