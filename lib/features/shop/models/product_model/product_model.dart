// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/features/shop/models/product_variation_model.dart';

class Product {
  final String id;
  final String title;
  final double price;
  final double salePrice;
  final List<String> imageUrls;
  final String discountPercentage;
  final List<String> description;
  final String categoryId;
  final List<String>? colors;
  final List<ProductOption>? colorOptions;
  final List<String>? sizes;
  String? selectedColor;
  String? selectedSize;
  int quantity;
  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.salePrice,
    required this.imageUrls,
    required this.discountPercentage,
    required this.description,
    required this.categoryId,
    this.colors,
    this.colorOptions,
    this.sizes,
    this.selectedColor,
    this.selectedSize,
    this.quantity = 1,
  });

  factory Product.fromFirestore(Map<String, dynamic> data, String id) {
    return Product(
      id: data['productId'] ?? data['id'] ?? '',
      title: data['title'] ?? 'Unknown',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      salePrice: double.tryParse(data['salePrice']?.toString() ?? '0') ?? 0.0,
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      discountPercentage: data['discountPercentage'] ?? '0%',
      description: List<String>.from(data['description'] ?? []),
      categoryId: data['categoryId']?.toString() ?? '',
      colorOptions: data['colors'] != null
          ? List<String>.from(data['colors'])
              .map((name) =>
                  ProductOption(name: name, color: getColorFromName(name)))
              .toList()
          : null,
      colors: data['colors'] != null ? List<String>.from(data['colors']) : null,
      sizes: data['sizes'] != null ? List<String>.from(data['sizes']) : null,
      selectedColor: data['selectedColor'], // Initialize selectedColor
      selectedSize: data['selectedSize'],
      quantity: data['quantity'] ?? 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': id,
      'title': title,
      'price': price,
      'salePrice': salePrice,
      'imageUrls': imageUrls,
      'discountPercentage': discountPercentage,
      'description': description,
      'categoryId': categoryId,
      'colors': colors,
      'sizes': sizes,
      'colorOptions': colorOptions?.map((option) => option.name).toList(),
      'selectedColor': selectedColor,
      'selectedSize': selectedSize,
      'quantity': quantity,
    };
  }

  factory Product.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    return Product(
      id: snapshot.id,
      title: data['title'] ?? '',
      price: data['price'] ?? '',
      salePrice: data['salePrice'] ?? '',
      description: List<String>.from(data['description'] ?? []),
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      categoryId: data['categoryId'],
      colors: List<String>.from(data['colors'] ?? []),
      sizes: List<String>.from(data['sizes'] ?? []),
      discountPercentage: data['discountPercentage'] ?? '',
    );
  }

  static Product fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['productId'] ?? map['id'],
      title: map['title'],
      price: map['price'],
      salePrice: map['salePrice'],
      imageUrls: List<String>.from(map['imageUrls']),
      discountPercentage: map['discountPercentage'] ?? '0%',
      description: List<String>.from(map['description']),
      selectedColor: map['selectedColor'],
      selectedSize: map['selectedSize'],
      quantity: map['quantity'] ?? 1,
      colors: map['colors'] != null ? List<String>.from(map['colors']) : null,
      sizes: map['sizes'] != null ? List<String>.from(map['sizes']) : null,
      colorOptions: [],
      categoryId: '',
    );
  }
}
