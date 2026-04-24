// ignore_for_file: avoid_print, use_build_context_synchronously, unused_local_variable, unnecessary_cast

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:myapp/features/shop/models/order/order_model.dart';
import 'package:myapp/features/shop/screen/product_review/widgets/write_review_screen.dart';
import 'package:myapp/utils/constant/colors.dart';
import 'package:myapp/utils/constant/sizes.dart';

class OrderDetailScreen extends StatefulWidget {
  final OrderModel order;
  const OrderDetailScreen({super.key, required this.order});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final List<String> steps = [
    'Order Confirmed',
    'Processing',
    'Shipped',
    'Out for Delivery',
    'Delivered',
  ];

  late Stream<DocumentSnapshot<Map<String, dynamic>>> statusStream;

  @override
  void initState() {
    super.initState();
    statusStream = FirebaseFirestore.instance
        .collection('orders')
        .doc(widget.order.id)
        .snapshots();
  }

  int getCurrentStep(String? status) {
    if (status == null) return 0;
    final index =
        steps.indexWhere((s) => s.toLowerCase() == status.toLowerCase());
    return index != -1 ? index : 0;
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Details"),
        centerTitle: true,
        backgroundColor: JColors.buttonPrimary,
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: statusStream,
        builder: (context, snapshot) {
          final currentStatus =
              snapshot.data?.data()?['status'] ?? widget.order.status.name;
          final currentStep = getCurrentStep(currentStatus);

          // ✅ Safe conversion of deliveryDate from Timestamp or DateTime or null
          final rawDate = widget.order.deliveryDate;
          final deliveryDate = (rawDate is Timestamp)
              ? (rawDate as Timestamp?)?.toDate()
              : rawDate as DateTime?;

          final isDelivered = currentStatus.toLowerCase() == 'delivered';

          bool isReturnVisible = false;

          if (isDelivered && deliveryDate != null) {
            final difference = DateTime.now().difference(deliveryDate).inDays;
            isReturnVisible = difference < 3; // shows only for 3 days
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(JSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Order ID: ${widget.order.id}",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text("Total Amount: ₹${widget.order.totalAmount}"),
                const SizedBox(height: 10),
                Text("Tax: ₹${widget.order.taxCost}"),
                const SizedBox(height: 10),
                if (widget.order.address != null)
                  Text(
                      "Shipping Address: ${widget.order.address!.address} ${widget.order.address!.city}, ${widget.order.address!.postalCode}"),
                const SizedBox(height: 10),
                Text("Payment Method: ${widget.order.paymentMethod}"),
                const SizedBox(height: 10),
                Text("Order Status: $currentStatus"),
                const SizedBox(height: 10),
                Text(
                    "Delivery Date: ${deliveryDate != null ? deliveryDate.toLocal().toString().split(' ')[0] : 'Not assigned'}"),
                const SizedBox(height: 20),

                Stepper(
                  currentStep: currentStep,
                  physics: const NeverScrollableScrollPhysics(),
                  steps: steps.asMap().entries.map((entry) {
                    final index = entry.key;
                    final title = entry.value;

                    return Step(
                      title: Text(
                        title,
                        style: TextStyle(
                          color: index == currentStep
                              ? Colors.green
                              : Colors.black,
                          fontWeight: index == currentStep
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      content: const SizedBox.shrink(),
                      isActive: index <= currentStep,
                      state: index < currentStep
                          ? StepState.complete
                          : index == currentStep
                              ? StepState.editing
                              : StepState.disabled,
                    );
                  }).toList(),
                  controlsBuilder: (_, __) => const SizedBox(),
                ),

                const SizedBox(height: 10),
                const Text("Items",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),

                /// ✅ Render each item using a `Column`
                ...widget.order.items.map((item) => Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          item.imageUrls != null
                              ? Image.network(item.imageUrls!,
                                  width: 60, height: 60, fit: BoxFit.cover)
                              : const Icon(Iconsax.box, size: 50),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.title,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Text(
                                    "Qty: ${item.quantity} - ₹${item.salePrice}"),
                               
                                if (item.selectedSize != null &&
                                    item.selectedSize!.isNotEmpty)
                                Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      "Size: ${item.selectedSize}",
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => WriteReviewScreen(
                                              productId: item.productId,
                                              title: item.title,
                                            ),
                                          ),
                                        );
                                      },
                                      icon: const Icon(Iconsax.edit, size: 16),
                                      label: const Text('Review',
                                          style: TextStyle(fontSize: 12)),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: JColors.primary,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 6),
                                      ),
                                    ),
                                    const SizedBox(width: 8),

                                    /// ✅ Show Return button only if delivered and within 3 days
                                    if (isReturnVisible)
                                      ElevatedButton.icon(
                                        onPressed: () => _showReturnDialog(
                                            item, widget.order.id),
                                        icon: const Icon(Iconsax.refresh,
                                            size: 16),
                                        label: const Text('Return',
                                            style: TextStyle(fontSize: 12)),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.orange,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 6),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showReturnDialog(dynamic item, String orderId) {
    final TextEditingController reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Return Product"),
        content: TextField(
          controller: reasonController,
          decoration: const InputDecoration(hintText: "Reason for return"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              final reason = reasonController.text.trim();
              if (reason.isNotEmpty) {
                try {
                  await FirebaseFirestore.instance.collection('returns').add({
                    'orderId': orderId,
                    'productId': item.productId,
                    'title': item.title,
                    'userId':
                        FirebaseAuth.instance.currentUser?.uid ?? 'unknown',
                    'reason': reason,
                    'timestamp': FieldValue.serverTimestamp(),
                    'status': 'pending',
                  });

                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Return request submitted.')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a reason')),
                );
              }
            },
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }
}
