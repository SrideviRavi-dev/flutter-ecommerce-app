// ignore_for_file: unused_field, library_private_types_in_public_api, unused_local_variable, deprecated_member_use, unused_element

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:upi_india/upi_india.dart';  // Commented UPI import
import 'package:myapp/services/order_service/order_service.dart';
import 'package:myapp/utils/constant/sizes.dart';
import 'package:myapp/utils/helpers/helper_function.dart';
import 'package:myapp/common/widgets/container/rounded_container.dart';
import 'package:myapp/common/widgets/text/section_heading.dart';
import 'package:myapp/utils/constant/colors.dart';
import 'package:myapp/utils/constant/image_string.dart';

class JBillingPaymentSecetion extends StatefulWidget {
  final double totalAmount;
  final Map<String, dynamic> shippingAddress;
  final List<Map<String, dynamic>> items;

  const JBillingPaymentSecetion({
    super.key,
    required this.totalAmount,
    required this.shippingAddress,
    required this.items,
  });

  @override
  _JBillingPaymentSecetionState createState() => _JBillingPaymentSecetionState();
}

class _JBillingPaymentSecetionState extends State<JBillingPaymentSecetion> {
  String _selectedPaymentMethod = 'Cash on Delivery';
  final OrderService _orderService = OrderService();

  @override
  Widget build(BuildContext context) {
    final dark = JHelperFunction.isDarkMode(context);

    return Column(
      children: [
        JSectionHeading(
          title: 'Payment Methods',
         // buttontitle: 'Change',
          onPressed: () {},  // Optional: you can disable this too if only COD is used
        ),
       // const SizedBox(height: JSizes.spaceBtwItems / 2),

        // Commented UPI payment options:
        /*
        _paymentMethodRow('Gpay', JImages.gpay),
        _paymentMethodRow('Paytm', JImages.paytm),
        _paymentMethodRow('PhonePe', JImages.phonepay),
        */

        // Only show Cash on Delivery option
        _paymentMethodRow('Cash on Delivery', JImages.cod),

        // const SizedBox(height: JSizes.spaceBtwItems),
        // ElevatedButton(
        //   onPressed: _startPayment,
        //   child: const Text('Confirm Payment'),
        // ),
      ],
    );
  }

  Widget _paymentMethodRow(String method, String logo) {
    return GestureDetector(
      onTap: () => setState(() => _selectedPaymentMethod = method),
      child: Row(
        children: [
          JRoundedContainer(
            width: 60,
            height: 40,
            backgroundColor: _selectedPaymentMethod == method
                ? JColors.primary
                : (JHelperFunction.isDarkMode(context) ? JColors.light : JColors.white),
            padding: const EdgeInsets.all(JSizes.sm),
            child: Image.asset(logo, fit: BoxFit.contain),
          ),
          const SizedBox(width: JSizes.spaceBtwItems),
          Text(
            method,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: _selectedPaymentMethod == method ? JColors.primary : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _startPayment() async {
    if (_selectedPaymentMethod == 'Cash on Delivery') {
      await _placeOrderToFirebase();
      Get.offAllNamed('/order-success');
      return;
    }

    // Commented UPI payment logic:
    /*
    try {
      UpiIndia upiIndia = UpiIndia();
      List<UpiApp> apps = await upiIndia.getAllUpiApps(mandatoryTransactionId: false);

      UpiApp selectedApp;
      switch (_selectedPaymentMethod) {
        case 'Gpay':
          selectedApp = apps.firstWhere((app) => app.name.contains('Google Pay'), orElse: () => throw 'Google Pay not installed.');
          break;
        case 'Paytm':
          selectedApp = apps.firstWhere((app) => app.name.contains('Paytm'), orElse: () => throw 'Paytm not installed.');
          break;
        case 'PhonePe':
          selectedApp = apps.firstWhere((app) => app.name.contains('PhonePe'), orElse: () => throw 'PhonePe not installed.');
          break;
        default:
          Get.snackbar('Error', 'Invalid payment method.');
          return;
      }

      UpiResponse response = await upiIndia.startTransaction(
        app: selectedApp,
        receiverUpiId: "ammusri0504@oksbi",
        receiverName: "Jardion",
        transactionRefId: "ORDER_${DateTime.now().millisecondsSinceEpoch}",
        transactionNote: "Shopping Payment",
        amount: widget.totalAmount,
      );

      _handleUPIResponse(response);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
    */
  }

  // Commented UPI Response Handler
  /*
  void _handleUPIResponse(UpiResponse response) async {
    switch (response.status) {
      case UpiPaymentStatus.SUCCESS:
        await _placeOrderToFirebase();
        Get.offAllNamed('/order-success');
        break;
      case UpiPaymentStatus.SUBMITTED:
        Get.snackbar('Pending', 'Transaction submitted. Please check your UPI app / bank account.');
        break;
      case UpiPaymentStatus.FAILURE:
      default:
        Get.snackbar('Payment Failed', 'The transaction was not completed.');
        break;
    }
  }
  */

  Future<void> _placeOrderToFirebase() async {
    final userId = FirebaseAuth.instance.currentUser;

  if (userId == null) {
    Get.snackbar('Error', 'User not signed in.');
    return;
  }  // Replace with your FirebaseAuth user ID
    await _orderService.saveOrder(
      userId.uid,
      widget.totalAmount,
      widget.shippingAddress,
      _selectedPaymentMethod,
      widget.items,
    );
  }
}
