import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:myapp/common/widgets/layout/grid_layout.dart';
import 'package:myapp/common/widgets/product/cards/product_card_vertical.dart';
import 'package:myapp/features/shop/controllers/product_controller/product_controller.dart';
import 'package:myapp/utils/constant/sizes.dart';

class JSortableProducts extends StatelessWidget {
  const JSortableProducts({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductController productController = Get.put(ProductController());

    return Column(
      children: [
        // Dropdown
        DropdownButtonFormField(
          decoration: const InputDecoration(prefixIcon: Icon(Iconsax.sort)),
          onChanged: (value) {},
          items: [
            'Name',
            'Higher Price',
            'Lower Price',
            'Sale',
            'Newest',
            'Popularity'
          ]
              .map((option) => DropdownMenuItem(value: option, child: Text(option)))
              .toList(),
        ),
        const SizedBox(height: JSizes.spaceBtwSections),

        // Products
        JGridLayot(
          itemCount: productController.products.length,
          itemBuilder: (_, index) {
            final product = productController.products[index];
            final productId = product.id; // Ensure your Product model has an id field
            return JProductCardsVertical(
              product: product,
              title: product.title, // Use the product title
              price: product.price.toString(), // Assuming price is a numeric type
              salePrice: product.salePrice.toString(), // Assuming salePrice is numeric too
              imageUrl: product.imageUrls, // Assuming product has a list of image URLs
              productId: productId,
              description: product.description, // Pass the product description here
              discountPercentage: product.discountPercentage,
            );
          },
        ),
      ],
    );
  }
}
