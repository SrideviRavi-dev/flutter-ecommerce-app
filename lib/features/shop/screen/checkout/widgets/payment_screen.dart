// // ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';

// class PaymentScreen extends StatefulWidget {
//   final double totalAmount;

//   const PaymentScreen({required this.totalAmount});

//   @override
//   _PaymentScreenState createState() => _PaymentScreenState();
// }

// class _PaymentScreenState extends State<PaymentScreen> {
//   late Razorpay _razorpay;

//   @override
//   void initState() {
//     super.initState();
//     _razorpay = Razorpay();

//     // Register Razorpay events using event names as strings
//     _razorpay.on('payment.success', _handlePaymentSuccess);
//     _razorpay.on('payment.error', _handlePaymentError);
//     _razorpay.on('payment.cancel', _handlePaymentCancel);  // Corrected event name for payment cancel
//   }

//   // Payment success handler
//   void _handlePaymentSuccess(PaymentSuccessResponse response) {
//     Get.snackbar('Success', 'Payment completed successfully!');
//     // Handle successful payment (e.g., save the order)
//   }

//   // Payment failure handler
//   void _handlePaymentError(PaymentFailureResponse response) {
//     Get.snackbar('Error', 'Payment failed. Please try again.');
//   }

//   // Payment cancel handler (Use PaymentFailureResponse for cancellations as well)
//   void _handlePaymentCancel(PaymentFailureResponse response) {
//     Get.snackbar('Cancelled', 'Payment was cancelled.');
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _razorpay.clear();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Payment Screen')),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             var options = {
//               'key': 'YOUR_RAZORPAY_API_KEY',  // Use your Razorpay API key here
//               'amount': (widget.totalAmount * 100).toInt(),  // Convert amount to paise (multiply by 100)
//               'name': 'Your Business',
//               'description': 'Order Payment',
//               'prefill': {'contact': '1234567890', 'email': 'email@example.com'},
//             };
//             _razorpay.open(options);
//           },
//           child: const Text('Pay Now'),
//         ),
//       ),
//     );
//   }
// }
