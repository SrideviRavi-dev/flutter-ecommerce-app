// ignore_for_file: avoid_print

import 'dart:convert';

class CartItemModel {
  String productId;
  String title;
  double price;
  double salePrice; // 🆕 Added sale price
  String? imageUrls;
  int quantity;
  String variationId;
  Map<String, String>? selectedVariation;
  String? selectedSize;

  CartItemModel({
    required this.productId,
    required this.quantity,
    this.variationId = '',
    this.imageUrls,
    this.price = 0.0,
    this.salePrice = 0.0, // 🆕 Initialize sale price
    this.title = '',
    this.selectedVariation,
    this.selectedSize,
  });

  // ✅ Calculate Total Amount for Item (using sale price if available)
  String get totalAmount =>
      ((salePrice > 0 ? salePrice : price) * quantity).toStringAsFixed(1);

  // ✅ Create Empty Cart Item
  static CartItemModel empty() => CartItemModel(productId: '', quantity: 0);

  // ✅ Convert to Firestore Format
  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'title': title,
      'price': price,
      'salePrice': salePrice, // 🆕 Added salePrice to map
      'imageUrls': imageUrls,
      'quantity': quantity,
      'variationId': variationId,
      'selectedVariation': selectedVariation,
      'selectedSize': selectedSize,
    };
  }

  // ✅ Convert Firestore Data to CartItemModel
  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      productId: map['productId'] ?? map['id'] ?? '',
      title: map['title'] ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      salePrice: (map['salePrice'] as num?)?.toDouble() ?? 0.0, // 🆕 Added salePrice parsing
      imageUrls: map['imageUrls'] is List
          ? (map['imageUrls'] as List).isNotEmpty
              ? map['imageUrls'][0].toString()
              : null
          : map['imageUrls']?.toString(),
      quantity: map['quantity'] ?? 1,
      variationId: map['variationId'] ?? '',
      selectedVariation: map['selectedVariation'] != null &&
              map['selectedVariation'].toString().isNotEmpty
          ? Map<String, String>.from(json.decode(map['selectedVariation']))
          : null,
         selectedSize: map['selectedSize']   
    );
  }
}
