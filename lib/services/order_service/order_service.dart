import 'package:cloud_firestore/cloud_firestore.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveOrder(
    String userId,
    double totalAmount,
    Map<String, dynamic> shippingAddress,
    String paymentMethod,
    List<Map<String, dynamic>> items,
  ) async {
    // Create order document
    final orderRef = _firestore.collection('orders').doc();

    await orderRef.set({
      'userId': userId,
      'totalAmount': totalAmount,
      'shippingAddress': shippingAddress,
      'paymentMethod': paymentMethod,
    });

    // Create items sub-collection
    for (var item in items) {
      await orderRef.collection('items').add(item);
    }
  }
}
