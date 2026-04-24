import 'package:cloud_firestore/cloud_firestore.dart';

class AddressModel {
  final String id;
  final String name;
  final String phone;
  final String address;
  final String city;
  final String state;
  final String country;
  final String postalCode;
  final bool selectedAddress;

  AddressModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    required this.postalCode,
    this.selectedAddress = false,
  });

  // ✅ Convert Model to Firestore-Compatible Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone, // ✅ Fixed: Now matches constructor
      'address': address,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'country': country,
      'selectedAddress': selectedAddress,
    };
  }

  // ✅ Convert Firestore Document to Model
  factory AddressModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return AddressModel(
      id: doc.id,
      name: data['name'] ?? '',
      phone: data['phone'] ?? '', // ✅ Fixed field name
      address: data['address'] ?? '',
      city: data['city'] ?? '',
      state: data['state'] ?? '',
      country: data['country'] ?? '',
      postalCode: data['postalCode'] ?? '',
      selectedAddress: data['selectedAddress'] ?? false,
    );
  }

  // ✅ Convert Map to Model (Null Safety Handled)
  factory AddressModel.fromMap(Map<String, dynamic> data) {
    return AddressModel(
      id: data['id'] as String? ?? '',
      name: data['name'] as String? ?? '',
      phone: data['phone'] as String? ?? '', // ✅ Fixed field name
      address: data['address'] as String? ?? '',
      city: data['city'] as String? ?? '',
      state: data['state'] as String? ?? '',
      postalCode: data['postalCode'] as String? ?? '',
      country: data['country'] as String? ?? '',
      selectedAddress: data['selectedAddress'] as bool? ?? false,
    );
  }

  @override
  String toString() {
    return '$address, $city, $state $postalCode, $country';
  }
}
