import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/features/shop/models/product_model/product_model.dart';
import 'package:myapp/services/cart_services/cart_service.dart';
import 'package:myapp/utils/constant/colors.dart';
import 'package:myapp/utils/constant/sizes.dart';

class JAddToCartButton extends StatelessWidget {
  final Product product;
 final String? selectedColor;
  final String? selectedSize;
  const JAddToCartButton({
    super.key,
    required this.product, required this.selectedColor,required this.selectedSize,
  });

  @override
  Widget build(BuildContext context) {
    final CartService cartService = Get.put(CartService());

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: JSizes.defaultSpace),
      child: Center(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
               cartService.addProductWithSelection(product, selectedColor, selectedSize);
              Get.snackbar('Success', '${product.title} added to cart!');
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(JSizes.md),
              backgroundColor: JColors.black,
              side: const BorderSide(color: JColors.black),
            ),
            child: const Text('Add to Cart'),
          ),
        ),
      ),
    );
  }
}
