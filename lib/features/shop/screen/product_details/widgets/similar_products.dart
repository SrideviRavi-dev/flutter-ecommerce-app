// ignore_for_file: no_leading_underscores_for_local_identifiers, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/common/widgets/product/cards/product_card_vertical.dart';
import 'package:myapp/common/widgets/text/section_heading.dart';
import 'package:myapp/features/shop/controllers/product_controller/similar_product_controller.dart';
import 'package:myapp/features/shop/screen/product_details/product_detail.dart';
import 'package:myapp/utils/constant/sizes.dart';

class JSimilarProductsSection extends StatefulWidget {
  final String categoryId;

  const JSimilarProductsSection({super.key, required this.categoryId});

  @override
  State<JSimilarProductsSection> createState() =>
      _JSimilarProductsSectionState();
}

class _JSimilarProductsSectionState extends State<JSimilarProductsSection> {
  late final SimilarProductController _similarProductController;

  @override
  void initState() {
    super.initState();
    // Initialize the controller
    _similarProductController = Get.put(SimilarProductController());
    // Use addPostFrameCallback to delay the fetch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _similarProductController.fetchSimilarProducts(widget.categoryId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_similarProductController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (_similarProductController.hasError.value) {
        return const Center(child: Text('*****'));
      }

      final similarProducts = _similarProductController.similarProducts;

      if (similarProducts.isEmpty) {
        return const Center(child: Text('No similar products found.'));
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(JSizes.defaultSpace),
            child: JSectionHeading(
              title: 'You might also like',
              showActionButton: false,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(JSizes.defaultSpace),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.6,
                crossAxisSpacing: 10,
                mainAxisSpacing: 15,
              ),
              itemCount: similarProducts.length,
              itemBuilder: (context, index) {
                final product = similarProducts[index];
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductDetailScreen(
                                title: product.title,
                                price: product.price.toString(),
                                salePrice: product.salePrice.toString(),
                                imageUrls: product.imageUrls,
                                offerPercentage:
                                    product.discountPercentage.toString(),
                                productId: product.id,
                                description: product.description,
                                categoryId: product.categoryId,
                              )),
                    );
                  },
                );
              },
            ),
          ),
        ],
      );
    });
  }
}
