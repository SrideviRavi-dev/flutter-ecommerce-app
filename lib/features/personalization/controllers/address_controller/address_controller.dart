// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:myapp/features/shop/models/address_model.dart';

class AddressController extends GetxController {
  RxList<AddressModel> addresses = <AddressModel>[].obs;

  @override
  void onInit() {
    fetchUserAddresses();
    super.onInit();
  }
Future<void> fetchUserAddresses() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  try {
    final userDoc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .get();

    final data = userDoc.data();

    if (data != null && data['shippingAddress'] != null) {
      final addressData = data['shippingAddress'] as Map<String, dynamic>;

      addresses.value = [
        AddressModel.fromMap(addressData),
      ];
    } else {
      print("No shippingAddress found in user document.");
      addresses.clear(); // Ensure it clears old addresses if none found
    }
  } catch (e) {
    print("Error fetching user address: $e");
    addresses.clear();
  }
}

}
