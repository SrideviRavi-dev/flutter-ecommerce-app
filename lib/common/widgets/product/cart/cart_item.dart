import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/common/widgets/images/rounded_images.dart';
import 'package:myapp/common/widgets/text/product_title_text.dart';
import 'package:myapp/services/cart_services/cart_service.dart';
import 'package:myapp/utils/constant/colors.dart';
import 'package:myapp/utils/constant/sizes.dart';
import 'package:myapp/utils/helpers/helper_function.dart';
import 'package:myapp/features/shop/models/product_model/product_model.dart';
import 'package:myapp/common/widgets/product/cart/add_remove_button.dart';

class JCartItem extends StatelessWidget {
  final Product product;

  const JCartItem({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final CartService cartService = Get.find();

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: JSizes.sm,
        horizontal: JSizes.sm,
      ),
      child: Row(
        children: [
          JRoundedImage(
            imageUrl: product.imageUrls.isNotEmpty
                ? product.imageUrls[0]
                : 'default_image_url', // Default image if none provided
            width: 60,
            height: 60,
            padding: const EdgeInsets.all(JSizes.sm),
            isNetworkImage: true,
            backgroundColor: JHelperFunction.isDarkMode(context)
                ? JColors.darkerGrey
                : JColors.light,
          ),
          const SizedBox(width: JSizes.spaceBtwItems),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                JProductTitleText(
                  title: product.title,
                  maxLines: 1,
                ),
                const SizedBox(height: JSizes.spaceBtwItems / 3),
                if (product.selectedColor != null &&
                    product.selectedColor!.isNotEmpty)
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Color: ',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        TextSpan(
                          text: product.selectedColor!,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                if (product.selectedSize != null &&
                    product.selectedSize!.isNotEmpty)
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Size: ',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        TextSpan(
                          text: product.selectedSize!,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: JSizes.spaceBtwItems / 3),

                // Display price and quantity
                Obx(() {
                  final currentProduct = cartService.cartItems
                      .firstWhere((p) => p.id == product.id);
                  final totalPrice =
                      currentProduct.quantity * product.salePrice;

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Price: ₹${totalPrice.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      JProductQuantityWithAddRemoveButton(
                        quantity: currentProduct.quantity,
                        onIncrement: () {
                          cartService.incrementQuantity(product.id);
                        },
                        onDecrement: () {
                          cartService.decrementQuantity(product.id);
                        },
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
