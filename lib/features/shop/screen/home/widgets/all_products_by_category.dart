// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/common/widgets/appbar/appbar.dart';
import 'package:myapp/common/widgets/product/cards/product_card_vertical.dart';
import 'package:myapp/features/shop/models/product_model/product_model.dart';
import 'package:myapp/services/product_services/product_service.dart';
import 'package:myapp/utils/constant/sizes.dart';

import '../../product_details/product_detail.dart';

class AllProductsByCategoryScreen extends StatelessWidget {
  final String categoryId;
  final String categoryName;

  const AllProductsByCategoryScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: JAppBar(title: Text(categoryName), showBackArrow: true),
      body: FutureBuilder<List<Product>>(
        future: ProductService().fetchProductsByCategory(categoryId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text("No products found in this category."));
          }

          final products = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(JSizes.defaultSpace),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // or your desired number of columns
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.7,
              ),
              itemCount: products.length,
              itemBuilder: (_, index) {
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
            ),
          );
        },
      ),
    );
  }
}
