// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/common/widgets/product/cards/product_card_vertical.dart';
import 'package:myapp/features/shop/controllers/product_controller/product_controller.dart';
import 'package:myapp/features/shop/screen/product_details/product_detail.dart';

class CategoryListScreen extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const CategoryListScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  final ProductController productController = Get.find<ProductController>();

  @override
  void initState() {
    super.initState();
    // Fetch products specific to this category
    WidgetsBinding.instance.addPostFrameCallback((_) {
      productController.fetchProductsByCategory(widget.categoryId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Reset product list when going back
        Future.delayed(const Duration(milliseconds: 100), () {
          productController.resetProducts();
        });
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.categoryName),
        ),
        body: Obx(() {
          if (productController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (productController.hasError.value) {
            return const Center(child: Text('Error fetching category products.'));
          }

          final products = productController.filteredProducts;

          if (products.isEmpty) {
            return const Center(child: Text('No products available in this category.'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 300,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (_, index) {
              final product = products[index];

              return JProductCardsVertical(
                product: product,
                title: product.title,
                price: product.price.toString(),
                salePrice: product.salePrice.toString(),
                imageUrl: product.imageUrls,
                productId: product.id,
                discountPercentage: product.discountPercentage,
                description: product.description,
                onTap: () {
                  Get.to(() => ProductDetailScreen(
                        title: product.title,
                        price: product.price.toString(),
                        imageUrls: product.imageUrls,
                        offerPercentage: product.discountPercentage.toString(),
                        productId: product.id,
                        salePrice: product.salePrice.toString(),
                        description: product.description,
                        categoryId: product.categoryId ?? '',   
                      ));
                },
              );
            },
          );
        }),
      ),
    );
  }
}    
