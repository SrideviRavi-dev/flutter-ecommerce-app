// ignore_for_file: use_super_parameters, unnecessary_cast, avoid_types_as_parameter_names, use_build_context_synchronously., avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:myapp/common/widgets/appbar/appbar.dart';
import 'package:myapp/common/widgets/container/rounded_container.dart';
import 'package:myapp/features/shop/models/product_model/product_model.dart';
import 'package:myapp/features/shop/screen/checkout/widgets/billing_address_section.dart';
import 'package:myapp/features/shop/screen/checkout/widgets/billing_amount_section.dart';
import 'package:myapp/features/shop/screen/checkout/widgets/billing_payment_section.dart';
import 'package:myapp/navigation_manu.dart';
import 'package:myapp/services/cart_services/cart_service.dart';
import 'package:myapp/services/order_service/place_order.dart';
import 'package:myapp/utils/constant/sizes.dart';

class CheckoutScreen extends StatefulWidget {
  final List<Product> checkoutItems;

  const CheckoutScreen({Key? key, this.checkoutItems = const []})
      : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  Map<String, dynamic>? shippingAddress;

  @override
  void initState() {
    super.initState();
    fetchShippingAddress();
  }

  void fetchShippingAddress() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('Users').doc(userId).get();

    if (userDoc.exists) {
      setState(() {
        shippingAddress =
            (userDoc.data() as Map<String, dynamic>)['shippingAddress'];
      });
    }
  }

  /// ✅ ONLY SAVES ORDER — NO SNACKBAR, NO NAVIGATION
  Future<void> placeOrder(
    BuildContext context,
    String paymentMethod,
    double totalAmount,
    Map<String, dynamic> shippingAddress,
    List<Map<String, dynamic>> items,
  ) async {
    try {
      final orderRef = FirebaseFirestore.instance.collection('orders').doc();

      final trackingNumber = generateTrackingNumber();

      final orderData = {
        'id': orderRef.id,
        'userId': FirebaseAuth.instance.currentUser?.uid,
        'paymentMethod': paymentMethod,
        'totalAmount': totalAmount,
        'shippingAddress': shippingAddress,
        'items': items,
        'status': 'Pending',
        'trackingNumber': trackingNumber,
        'orderedAt': DateTime.now(),
        'deliveryDate': Timestamp.fromDate(
          DateTime.now().add(const Duration(days: 9)),
        ),
      };

      await orderRef.set(orderData);
    } catch (e) {
      print("ORDER ERROR: $e");
      rethrow;
    }
  }

  Widget _buildCartItemsSection(List<Product> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) {
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Image.network(
            item.imageUrls.first,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
          title: Text(
            item.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      setState(() {
                        if (item.quantity > 1) item.quantity--;
                      });
                    },
                  ),
                  Text('${item.quantity}'),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        item.quantity++;
                      });
                    },
                  ),
                ],
              ),

              /// ✅ SHOW SIZE ONLY IF PRODUCT HAS SIZE AND USER SELECTED IT
              if (item.sizes != null &&
                  item.sizes!.isNotEmpty &&
                  item.selectedSize != null &&
                  item.selectedSize!.isNotEmpty)
                Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      "Size: ${item.selectedSize}",
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    )),
            ],
          ),
          trailing: Text(
            '₹${(item.salePrice * item.quantity).toStringAsFixed(2)}',
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Product> itemsToCheckout = widget.checkoutItems.isNotEmpty
        ? widget.checkoutItems
        : Get.find<CartService>().cartItems;

    final double subtotal = itemsToCheckout.fold(
      0.0,
      (sum, item) => sum + (item.salePrice * item.quantity),
    );

    const double shippingAmount = 30;
    const double taxAmount = 0.0;
    final double totalAmount = subtotal + shippingAmount + taxAmount;

    return Scaffold(
      appBar: JAppBar(
        showBackArrow: true,
        title: Text(
          'Order Review',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(JSizes.defaultSpace),
          child: Column(
            children: [
              _buildCartItemsSection(itemsToCheckout),
              const SizedBox(height: JSizes.spaceBtwSections),
              JRoundedContainer(
                padding: const EdgeInsets.all(JSizes.sm),
                showBorder: true,
                child: Column(
                  children: [
                    JBillingAmountSecetion(
                      subtotal: subtotal,
                      shippingAmount: shippingAmount,
                      taxAmount: taxAmount,
                      totalAmount: totalAmount,
                    ),
                    const SizedBox(height: JSizes.spaceBtwItems),
                    JBillingAddressSecetion(
                      onAddressUpdated: fetchShippingAddress,
                      addressData: shippingAddress,
                    ),
                    const SizedBox(height: JSizes.spaceBtwItems),
                    JBillingPaymentSecetion(
                      totalAmount: totalAmount,
                      shippingAddress: shippingAddress ?? {},
                      items:
                          itemsToCheckout.map((item) => item.toMap()).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: JSizes.borderRadiusMd,
          vertical: JSizes.xs,
        ),
        child: ElevatedButton(
          onPressed: () async {
            try {
              final user = FirebaseAuth.instance.currentUser;
              if (user == null) {
                Get.snackbar('Error', 'You need to log in first.');
                return;
              }

              final userDoc = await FirebaseFirestore.instance
                  .collection('Users')
                  .doc(user.uid)
                  .get();

              final userData = userDoc.data() as Map<String, dynamic>? ?? {};
              final Map<String, dynamic> userShippingAddress =
                  userData['shippingAddress'] ?? {};

              if (userShippingAddress.isEmpty) {
                Get.snackbar('Error', 'Please add a shipping address.');
                return;
              }

              await placeOrder(
                context,
                'Cash on Delivery',
                totalAmount,
                userShippingAddress,
                itemsToCheckout.map((item) => item.toMap()).toList(),
              );

              final cartService = Get.find<CartService>();
              cartService.cartItems.clear();
              cartService.saveCart();

              // ✅ SUCCESS MESSAGE
              Get.snackbar(
                'Success',
                'Order placed successfully!',
                duration: const Duration(seconds: 1),
              );

              // ✅ REDIRECT TO HOME
              Future.delayed(const Duration(milliseconds: 800), () {
                Get.offAll(() => NavigationMenu());
              });
            } catch (e) {
              Get.snackbar('Error', 'Something went wrong');
            }
          },
          child: Text('Checkout ₹${totalAmount.toStringAsFixed(2)}'),
        ),
      ),
    );
  }
}
