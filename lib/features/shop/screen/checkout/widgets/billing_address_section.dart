// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/common/widgets/text/section_heading.dart';
import 'package:myapp/utils/constant/sizes.dart';

class JBillingAddressSecetion extends StatefulWidget {
  const JBillingAddressSecetion({super.key, this.onAddressUpdated, this.addressData});
  final VoidCallback? onAddressUpdated;
  final Map<String, dynamic>? addressData;

  @override
  _JBillingAddressSecetionState createState() =>
      _JBillingAddressSecetionState();
}

class _JBillingAddressSecetionState extends State<JBillingAddressSecetion> {
  // Text Controllers for address input
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Flag to control loading state
  bool isLoading = false;

  // Fetch user's saved address from Firestore
  Future<void> _loadAddress() async {
    try {
      String? userId = _auth.currentUser?.uid;
      if (userId == null) return;

      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        var address = userDoc.data() as Map<String, dynamic>;
        var shippingAddress =
            address['shippingAddress'] as Map<String, dynamic>;

        setState(() {
          nameController.text = shippingAddress['name'] ?? '';
          phoneController.text = shippingAddress['phone'] ?? '';
          addressController.text = shippingAddress['address'] ?? '';
          cityController.text = shippingAddress['city'] ?? '';
          postalCodeController.text = shippingAddress['postalCode'] ?? '';
        });
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load address');
    }
  }

  // Save address to Firestore
  Future<void> _saveAddress() async {
    setState(() {
      isLoading = true; // Set loading state while saving
    });

    try {
      String? userId = _auth.currentUser?.uid;
      if (userId == null) {
        Get.snackbar('Error', 'User not logged in');
        setState(() {
          isLoading = false;
        });
        return;
      }

      // Prepare the address data
      Map<String, dynamic> addressData = {
        'name': nameController.text,
        'phone': phoneController.text,
        'address': addressController.text,
        'city': cityController.text,
        'postalCode': postalCodeController.text,
      };

      // Save the address to Firestore
      await _firestore.collection('Users').doc(userId).update({
        'shippingAddress': addressData,
      });

      Get.snackbar('Success', 'Address updated successfully');

      // Reload the address after saving
      await _loadAddress();

// ❗ Trigger parent to fetch the new address
      if (widget.onAddressUpdated != null) {
        widget.onAddressUpdated!();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update address');
    } finally {
      setState(() {
        isLoading = false; // Reset loading state after saving
      });
    }
  }

@override
void initState() {
  super.initState();
  if (widget.addressData != null) {
    nameController.text = widget.addressData!['name'] ?? '';
    phoneController.text = widget.addressData!['phone'] ?? '';
    addressController.text = widget.addressData!['address'] ?? '';
    cityController.text = widget.addressData!['city'] ?? '';
    postalCodeController.text = widget.addressData!['postalCode'] ?? '';
  } else {
    _loadAddress(); // fallback if addressData not passed
  }
}

@override
void didUpdateWidget(covariant JBillingAddressSecetion oldWidget) {
  super.didUpdateWidget(oldWidget);
  if (widget.addressData != oldWidget.addressData && widget.addressData != null) {
    nameController.text = widget.addressData!['name'] ?? '';
    phoneController.text = widget.addressData!['phone'] ?? '';
    addressController.text = widget.addressData!['address'] ?? '';
    cityController.text = widget.addressData!['city'] ?? '';
    postalCodeController.text = widget.addressData!['postalCode'] ?? '';
  }
}




  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Heading Section
        JSectionHeading(
          title: 'Shipping Address',
          buttontitle: 'Change',
          onPressed: () {
            // Show a form to edit the address
            _showAddressForm(context);
          },
        ),

        // Address Display Section
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                nameController.text.isNotEmpty ? nameController.text : 'Name',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: JSizes.spaceBtwItems / 2),
              Row(
                children: [
                  const Icon(Icons.phone, color: Colors.grey, size: 16),
                  const SizedBox(width: JSizes.spaceBtwItems),
                  Text(
                    phoneController.text.isNotEmpty
                        ? phoneController.text
                        : '93 ** ** ** **',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: JSizes.spaceBtwItems / 2),
              Row(
                children: [
                  const Icon(Icons.location_history,
                      color: Colors.grey, size: 16),
                  const SizedBox(width: JSizes.spaceBtwItems),
                  Expanded(
                    child: Text(
                      addressController.text.isNotEmpty
                          ? addressController.text
                          : '123, Street, City Name',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Show a loading indicator if saving
        if (isLoading) Center(child: CircularProgressIndicator()),
      ],
    );
  }

  // Show the address form dialog
  void _showAddressForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Shipping Address'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField(nameController, 'Name'),
                _buildTextField(phoneController, 'Phone'),
                _buildTextField(addressController, 'Address'),
                _buildTextField(cityController, 'City'),
                _buildTextField(postalCodeController, 'Postal Code'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _saveAddress();
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Helper method to build text fields
  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
