// ignore_for_file: no_leading_underscores_for_local_identifiers,avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/common/widgets/success_screen/success_screen.dart';
import 'package:myapp/utils/constant/image_string.dart';

Future<void> placeOrder(
  BuildContext context,
  String paymentMethod,
  double totalAmount,
  Map<String, dynamic> address,
  List<Map<String, dynamic>> cartItems, {
  String deliveryMethod = 'Standard',
  double deliveryFee = 40.0,
}) async {
  try {
    final FirebaseFirestore _db = FirebaseFirestore.instance;
    final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    if (userId.isEmpty) {
      Get.snackbar('Error', 'User not logged in');
      return;
    }

    DocumentReference orderRef = _db.collection('orders').doc();

    List<Map<String, dynamic>> itemsList = cartItems
        .map((item) => {
              'productId': item['productId'] ?? '',
              'title': item['title'] ?? 'Unknown',
              'quantity': item['quantity'] ?? 1,
              'price': (item['price'] as num?)?.toDouble() ?? 0.0,
              'imageUrls': item['imageUrls'] ?? [],
              'variationId': item['variationId'] ?? '',
              'selectedVariation': item['selectedVariation'] ?? '',
            })
        .toList();

    final trackingNumber = generateTrackingNumber(); // ✅ Generate Tracking ID

    Map<String, dynamic> orderData = {
      'id': orderRef.id,
      'userId': userId,
      'address': {
        'id': address['id'] ?? '',
        'name': address['name'] ?? '',
        'phone': address['phone'] ?? '',
        'street': address['street'] ?? '',
        'city': address['city'] ?? '',
        'state': address['state'] ?? '',
        'postalCode': address['postalCode'] ?? '',
        'country': address['country'] ?? '',
        'selectedAddress': address['selectedAddress'] ?? false,
      },
      'paymentMethod': paymentMethod,
      'totalAmount': totalAmount,
      'taxCost': 0.0,
      'shippingCost': deliveryFee,
      'trackingNumber': trackingNumber,
      'orderDate': Timestamp.now(),
      'deliveryDate': Timestamp.fromDate(DateTime.now().add(const Duration(days: 9))),
      'status': 'pending',
      'items': itemsList,
    };
print("Final deliveryDate: ${orderData['deliveryDate']}");

    await orderRef.set(orderData);

  // Save address if not saved before
    String addressId = address['id'] ?? '';
    if (addressId.isEmpty) {
      DocumentReference addressRef = _db
          .collection('Users')
          .doc(userId)
          .collection('shippingAddress')
          .doc();
      addressId = addressRef.id;
    }

    await _db
        .collection('Users')
        .doc(userId)
        .collection('shippingAddress')
        .doc(addressId)
        .set(address);

    Get.to(() => SuccessScreen(
          image: JImages.paymentSuccessIcon,
          title: 'Order Placed Successfully!',
          subTitle: 'Your order is confirmed and will be shipped soon.',
          onPressed: () {
            Get.back();
          },
        ));
  } catch (e) {
    Get.snackbar('Error', 'Failed to place the order: $e');
  }
}

String generateTrackingNumber() {
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final randomPart =
      (1000 + (9999 - 1000) * (DateTime.now().second / 59)).toInt();
  return 'ETRK$timestamp$randomPart';
}
