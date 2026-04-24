// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:myapp/features/shop/models/product_model/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartService extends GetxService {
  var cartItems = <Product>[].obs;

  // Initialize the cart when the app starts
  Future<void> init() async {
    await loadCartFromLocal();
  }

  // Add product with color and size selection
  void addProductWithSelection(Product product, String? color, String? size) {
    product.selectedColor = color;
    product.selectedSize = size;
    addToCart(product);
  }

  // Add a product to the cart or increment quantity if it already exists
  void addToCart(Product product) {
    final existingProductIndex = cartItems.indexWhere((item) => item.id == product.id);
    if (existingProductIndex != -1) {
      cartItems[existingProductIndex].quantity += 1; // Increment quantity
    } else {
      product.quantity = 1; // Initialize quantity if it's a new product
      cartItems.add(product); // Add new product to cart
    }
    saveCart(); // Save to local storage and Firestore
  }

  // Remove a product from the cart
  void removeFromCart(String productId) {
    cartItems.removeWhere((item) => item.id == productId);
    saveCart();
  }

  // Increment the quantity of a product in the cart
  void incrementQuantity(String productId) {
    final index = cartItems.indexWhere((item) => item.id == productId);
    if (index != -1) {
      cartItems[index].quantity++;
      cartItems.refresh();
      saveCart();
    }
  }

  // Decrement the quantity of a product in the cart
  void decrementQuantity(String productId) {
    final index = cartItems.indexWhere((item) => item.id == productId);
    if (index != -1) {
      if (cartItems[index].quantity > 1) {
        cartItems[index].quantity--;
      } else {
        removeFromCart(productId);
      }
      cartItems.refresh();
      saveCart(); // Ensure state is saved
    }
  }

  // Update the quantity of a product in the cart
  Future<void> updateQuantity(String productId, int newQuantity) async {
    final index = cartItems.indexWhere((item) => item.id == productId);
    if (index != -1) {
      if (newQuantity <= 0) {
        removeFromCart(productId);
      } else {
        cartItems[index].quantity = newQuantity;
      }
      await saveCart(); // Save changes
    }
  }

  // Calculate subtotal (sum of all products price * quantity)
  double getSubtotal() {
    double subtotal = 0.0;
    for (var item in cartItems) {
      subtotal += item.salePrice * item.quantity; // Price * quantity for each item
    }
    return subtotal;
  }

  // Calculate tax (e.g., 10% tax on subtotal)
  double getTax() {
    double subtotal = getSubtotal();
    const double taxRate = 0.10; // 10% tax rate
    return subtotal * taxRate; // Apply tax rate to subtotal
  }

  // Calculate total (subtotal + tax + shipping)
  double getTotal(double shippingAmount) {
    double subtotal = getSubtotal();
    double taxAmount = getTax();
    return subtotal + taxAmount + shippingAmount; // Subtotal + tax + shipping
  }

  // Save cart data to Firestore and Local Storage
  Future<void> saveCart() async {
    await saveCartToLocal();
    await saveCartToFirestore(); // Save to Firestore
  }

  Future<void> saveCartToFirestore() async {
  try {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? 'guest';
    final cartData = cartItems.map((product) => {
      'productId': product.id,
      'title': product.title,
      'price': product.price,
      'salePrice': product.salePrice,
      'imageUrls': product.imageUrls,
      'selectedColor': product.selectedColor,
      'selectedSize': product.selectedSize,
      'quantity': product.quantity,
    }).toList();

    await FirebaseFirestore.instance.collection('carts').doc(userId).set({
      'cartItems': cartData,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  } catch (e) {
    print("Error saving cart to Firestore: $e");
    // Optionally: queue a retry attempt
  }
}


  // Load cart data from Firestore
  Future<void> loadCartFromFirestore() async {
    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? 'guest';
      final cartSnapshot = await FirebaseFirestore.instance
          .collection('carts')
          .doc(userId)
          .get();

      if (cartSnapshot.exists) {
        final cartData = cartSnapshot.data()?['cartItems'] as List<dynamic>;
        cartItems.value = cartData.map((item) => Product.fromMap(item)).toList();
      }
    } catch (e) {
      print("Error loading cart from Firestore: $e");
    }
  }

  // Save cart data to local storage (using SharedPreferences)
  Future<void> saveCartToLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String cartJson = jsonEncode(cartItems.map((item) => item.toMap()).toList());
      await prefs.setString('cart', cartJson); // Save cart to local storage
    } catch (e) {
      print("Error saving cart to local storage: $e");
    }
  }

  // Load cart data from local storage
  Future<void> loadCartFromLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? cartJson = prefs.getString('cart');
      if (cartJson != null) {
        List<dynamic> cartList = jsonDecode(cartJson);
        cartItems.value = cartList.map((item) => Product.fromMap(item)).toList();
      } else {
        cartItems.value = [];
      }
    } catch (e) {
      print("Error loading cart from local storage: $e");
      cartItems.value = [];
    }
  }
}
