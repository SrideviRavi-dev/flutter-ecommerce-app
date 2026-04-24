// ignore_for_file: prefer_null_aware_operators

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/features/shop/models/address_model.dart';
import 'package:myapp/features/shop/models/cart_item/cart_item_model.dart';
import 'package:myapp/utils/constant/enum.dart';

class OrderModel {
  final String id;
  final String userId;
  final double totalAmount;
  final double taxCost;
  final DateTime orderDate;
  final DateTime? deliveryDate;
  final String paymentMethod;
  OrderStatus status;
  final AddressModel? address;
  final List<CartItemModel> items; // ✅ Added items list
  final String trackingNumber;
  

  OrderModel({
    required this.id,
    required this.userId,
    required this.totalAmount,
    this.taxCost = 0.0, // Default tax cost if missing
    required this.orderDate,
    this.deliveryDate, // Nullable
    required this.paymentMethod,
    required this.status,
    this.address,
    required this.items, // ✅ Now included

    required this.trackingNumber,
  });
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'totalAmount': totalAmount,
      'taxCost': taxCost,
      'orderDate': Timestamp.fromDate(orderDate),
      'deliveryDate':
          deliveryDate != null ? Timestamp.fromDate(deliveryDate!) : null,
      'paymentMethod': paymentMethod,
      'status': status.toString(), // Convert Enum to String
      'address': address?.toJson() ?? {},
      // Convert AddressModel to Map
      'items': items
          .map((item) => item.toMap())
          .toList(), // ✅ Convert CartItemModel list to Firestore-compatible format

      'trackingNumber': trackingNumber,
    };
  }

  // Convert Firestore DocumentSnapshot to OrderModel
  factory OrderModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    return OrderModel(
      id: snapshot.id,
      userId: data['userId'] ?? '',
      totalAmount: (data['totalAmount'] as num?)?.toDouble() ?? 0.0,
      taxCost: (data['taxCost'] as num?)?.toDouble() ?? 0.0,
      orderDate: (data['orderDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      deliveryDate: (data['deliveryDate'] as Timestamp?)?.toDate(),
      paymentMethod: data['paymentMethod'] ?? 'Unknown',
      status: OrderStatus.values.firstWhere(
        (e) => e.name == (data['status'] ?? 'pending'), // Default to "pending"
        orElse: () => OrderStatus.pending,
      ),
      address: data['address'] != null
          ? AddressModel.fromMap(data['address'] as Map<String, dynamic>)
          : null,
      items: (data['items'] as List<dynamic>?)
              ?.map(
                  (item) => CartItemModel.fromMap(item as Map<String, dynamic>))
              .toList() ??
          [], // ✅ Converts Firestore items to List<CartItemModel>

      trackingNumber: data['trackingNumber'] ?? '',
    );
  }

  // Convert OrderModel to JSON (for Firestore)
}
