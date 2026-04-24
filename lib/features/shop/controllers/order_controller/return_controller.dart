// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:myapp/features/shop/models/order/return_model.dart';

class ReturnController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> submitReturnRequest(ReturnRequestModel returnRequest) async {
    try {
      await _db.collection('returns').doc(returnRequest.id).set(returnRequest.toJson());
      Get.snackbar("Request Sent", "Your return request was submitted.");
    } catch (e) {
      Get.snackbar("Error", "Failed to submit return request.");
      print("Error: $e");
    }
  }
}
