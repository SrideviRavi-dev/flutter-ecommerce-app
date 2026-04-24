import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/services/cart_services/cart_service.dart';
import 'package:myapp/common/widgets/product/cart/cart_item.dart';
import '../checkout/checkout.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
   final CartService cartService = Get.put(CartService(), permanent: true);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: Obx(() {
        if (cartService.cartItems.isEmpty) {
          return const Center(child: Text('Your cart is empty.'));
        }
        return ListView.builder(
          itemCount: cartService.cartItems.length,
          itemBuilder: (context, index) {
            final product = cartService.cartItems[index];
            return Dismissible(
              key: Key(product.id),
              onDismissed: (direction) {
                cartService.removeFromCart(product.id);
                Get.snackbar('Removed', '${product.title} removed from cart!');
              },
              child: JCartItem(product: product),
            );
          },
        );
      }),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            final cartService = Get.find<CartService>();
            if (cartService.cartItems.isNotEmpty) {
              Get.to(() => CheckoutScreen(
                    checkoutItems: cartService.cartItems.toList(),
                  ));
            } else {
              Get.snackbar(
                  'Cart Empty', 'Please add products to your cart first.');
            }
          },
          child: const Text('CheckOut'),
        ),
      ),
    );
  }
}
