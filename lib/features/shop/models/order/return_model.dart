import 'package:cloud_firestore/cloud_firestore.dart';

class ReturnRequestModel {
  final String id;
  final String orderId;
  final String productId;
  final String userId;
  final String reason;
  final String status;
  final DateTime requestDate;
  final String? responseMessage;

  ReturnRequestModel({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.userId,
    required this.reason,
    required this.status,
    required this.requestDate,
    this.responseMessage,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'orderId': orderId,
        'productId': productId,
        'userId': userId,
        'reason': reason,
        'status': status,
        'requestDate': requestDate,
        'responseMessage': responseMessage ?? '',
      };

  factory ReturnRequestModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return ReturnRequestModel(
      id: snapshot.id,
      orderId: data['orderId'],
      productId: data['productId'],
      userId: data['userId'],
      reason: data['reason'],
      status: data['status'],
      requestDate: (data['requestDate'] as Timestamp).toDate(),
      responseMessage: data['responseMessage'],
    );
  }
}
