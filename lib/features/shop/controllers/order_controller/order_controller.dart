// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/features/shop/models/order/order_model.dart';
import 'package:myapp/utils/constant/enum.dart';

class OrderController extends GetxController {
  static OrderController get instance => Get.find();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  RxList<OrderModel> orders = <OrderModel>[].obs;
  RxBool loading = false.obs;

  Future<void> fetchOrders() async {
    try {
      loading(true);

      // ✅ Get current user ID from Firebase
      final userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId == null) {
        orders.value = []; // No user logged in
        return;
      }

      final result = await _db
          .collection('orders')
          .where('userId',
              isEqualTo: FirebaseAuth
                  .instance.currentUser?.uid) // ✅ Filter orders by userId
          .get();

      final fetchedOrders =
          result.docs.map((e) => OrderModel.fromSnapshot(e)).toList();

      print(
          "Fetched orders count: ${fetchedOrders.length}"); // Log the count of fetched orders

      orders.assignAll(
          fetchedOrders); // Assign the filtered orders to the orders list
    } catch (e) {
      debugPrint('Error fetching orders: $e');
      orders.value = [];
    } finally {
      loading(false);
    }
  }

  Future<void> placeOrder(OrderModel order) async {
    try {
      await _db.collection('orders').doc(order.id).set(order.toJson());
    } catch (e) {
      print('Error placing order: $e');
    }
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      await _db.collection('orders').doc(orderId).update({'status': newStatus});

      // Convert newStatus (String) to OrderStatus Enum
      final updatedStatus = OrderStatus.values.firstWhere(
        (e) => e.name == newStatus,
        orElse: () => OrderStatus.pending, // Default if invalid string
      );

      // Update the local orders list
      final orderIndex = orders.indexWhere((order) => order.id == orderId);
      if (orderIndex != -1) {
        orders[orderIndex].status = updatedStatus;
        orders.refresh(); // Notify UI of the change
      }
    } catch (e) {
      print('Error updating order status: $e');
    }
  }

  Future<bool> cancelOrder(String orderId) async {
    try {
      await _db.collection('orders').doc(orderId).delete();
      orders.removeWhere((order) => order.id == orderId);
      return true;
    } catch (e) {
      return false;
    }
  }
}
