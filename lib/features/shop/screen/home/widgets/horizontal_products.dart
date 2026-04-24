// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/common/widgets/product/cards/product_card_vertical.dart';
import 'package:myapp/features/shop/models/product_model/product_model.dart';
import 'package:myapp/features/shop/screen/home/widgets/all_products_by_category.dart';
import 'package:myapp/features/shop/screen/product_details/product_detail.dart';
import 'package:myapp/services/product_services/product_service.dart';

class JCategoryProductSection extends StatelessWidget {
  final String categoryId;
  final String categoryName;

  const JCategoryProductSection({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: ProductService()
          .fetchProductsByCategoryLimited(categoryId, 10), // get max 10
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox.shrink();
        }

        final products = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and View All
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(categoryName,
                      style: Theme.of(context).textTheme.titleLarge),
                  TextButton(
                    onPressed: () {
                      Get.to(() => AllProductsByCategoryScreen(
                            categoryId: categoryId,
                            categoryName: categoryName,
                          ));
                    },
                    child: const Text("View All ➜"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Horizontal Products
            SizedBox(
              height: 250, // adjust based on card height
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: products.length,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemBuilder: (context, index) {
                  final product = products[index];
                  return JProductCardsVertical(
                    product: product,
                    title: product.title,
                    price: product.price.toString(),
                    salePrice: product.salePrice.toString(),
                    imageUrl: product.imageUrls,
                    productId: product.id,
                    description: product.description,
                    discountPercentage: product.discountPercentage,
                    onTap: () {
                      if (product.id.isNotEmpty &&
                          product.categoryId.isNotEmpty) {
                        Get.to(() => ProductDetailScreen(
                              title: product.title,
                              price: product.price.toString(),
                              imageUrls: product.imageUrls,
                              offerPercentage:
                                  product.discountPercentage.toString(),
                              productId: product.id,
                              salePrice: product.salePrice.toString(),
                              description: product.description,
                              categoryId: product.categoryId,
                            ));
                      } else {
                        print('Error: Missing product ID or category ID');
                      }
                    },
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(width: 12),
              ),
            ),
            const SizedBox(height: 24),
          ],
        );
      },
    );
  }
}
