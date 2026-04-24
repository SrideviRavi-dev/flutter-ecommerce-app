// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/features/shop/controllers/product_controller/product_controller.dart';
import 'package:myapp/common/widgets/product/cards/product_card_vertical.dart';

class SearchResultScreen extends StatefulWidget {
  final String searchQuery;
  const SearchResultScreen({super.key, required this.searchQuery});

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  final ProductController productController = Get.find<ProductController>();

  @override
  void initState() {
    super.initState();
    productController.searchProducts(widget.searchQuery);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Results for "${widget.searchQuery}"'),
      ),
      body: Obx(() {
        final products = productController.filteredProducts;

        if (products.isEmpty) {
          return const Center(child: Text('No products found'));
        }

        return GridView.builder(
          itemCount: products.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 300,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ), 
          itemBuilder: (context, index) {
            if (index >= products.length)
              return const SizedBox(); // 🛑Safe access
            final product = products[index];

            return JProductCardsVertical(
              product: product,
              title: product.title,
              price: product.price.toString(),
              salePrice: product.salePrice.toString(),
              imageUrl: product.imageUrls,
              productId: product.id,
              discountPercentage: product.discountPercentage.toString(),
              description: product.description,
              onTap: () {
                // Optional navigation
              },
            );
          },
        );
      }),
    );
  }
}
