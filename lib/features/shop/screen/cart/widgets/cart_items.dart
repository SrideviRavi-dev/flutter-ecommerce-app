import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/common/widgets/product/cart/add_remove_button.dart';
import 'package:myapp/common/widgets/product/cart/cart_item.dart';
import 'package:myapp/common/widgets/text/product_price_text.dart';
import 'package:myapp/services/cart_services/cart_service.dart';
import 'package:myapp/utils/constant/sizes.dart';

class JCartItems extends StatelessWidget {
  const JCartItems({
    super.key,
    this.showAddRemoveButton = true,
  });

  final bool showAddRemoveButton;

  @override
  Widget build(BuildContext context) {
    final CartService cartService = Get.find(); // Get the CartService

    return Obx(() {
      if (cartService.cartItems.isEmpty) {
        return const Center(child: Text('Your cart is empty.'));
      }

      return ListView.separated(
        shrinkWrap: true,
        itemCount: cartService.cartItems.length,
        separatorBuilder: (_, __) => const SizedBox(
          height: JSizes.defaultSpace,
        ),
        itemBuilder: (_, index) {
          final product = cartService.cartItems[index];

          return Column(
            children: [
              JCartItem(
                  product: product), // Pass the product to your CartItem widget
              if (showAddRemoveButton)
                const SizedBox(height: JSizes.spaceBtwItems),
              if (showAddRemoveButton)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 70),
                        JProductQuantityWithAddRemoveButton(
                         quantity: product.quantity, 
                          onIncrement: () {
                            cartService.incrementQuantity(product.id);
                          },
                          onDecrement: () {
                            cartService.decrementQuantity(product.id);
                          },
                        ),
                      ],
                    ),
                    JProductPriceText(
                        price: product.price
                            .toString()), // Display the product price
                  ],
                ),
            ],
          );
        },
      );
    });
  }
}
