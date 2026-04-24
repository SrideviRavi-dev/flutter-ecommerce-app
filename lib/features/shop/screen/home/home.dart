// ignore_for_file: avoid_print, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/common/shimmer_effect/box_shimmer.dart';
import 'package:myapp/common/widgets/container/primary_container.dart';
import 'package:myapp/common/widgets/product/cards/product_card_vertical.dart';
import 'package:myapp/common/widgets/text/section_heading.dart';
import 'package:myapp/features/shop/controllers/home_controller/home_controller.dart';
import 'package:myapp/features/shop/controllers/product_controller/product_controller.dart';
import 'package:myapp/features/shop/screen/home/widgets/home_appbar.dart';
import 'package:myapp/features/shop/screen/home/widgets/home_cateogeries.dart';
import 'package:myapp/features/shop/screen/home/widgets/promo_slider.dart';
import 'package:myapp/features/shop/screen/product_details/product_detail.dart';
import 'package:myapp/utils/constant/colors.dart';
import 'package:myapp/utils/constant/sizes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController controller = Get.put(HomeController());
  final ProductController productController = Get.find<ProductController>();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        productController.fetchMoreProducts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController, // <- Attach here!
        slivers: [
          SliverToBoxAdapter(
            child: JPrimaryHeaderContainer(
              child: Column(
                children: [
                  const JHomeAppbar(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: JSizes.defaultSpace,
                        vertical: JSizes.spaceBtwItems),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: _searchController,
                          onChanged: (value) =>
                              productController.searchProducts(value),
                          decoration: InputDecoration(
                            hintText: 'Search Products...',
                            prefixIcon:
                                Icon(Icons.search, color: JColors.darkerGrey),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: JColors.darkerGrey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: JColors.primary),
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        // ✅ Suggestions list
                        Obx(() {
                          if (productController.searchSuggestions.isEmpty)
                            return const SizedBox();
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                )
                              ],
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: productController.searchSuggestions
                                  .map((suggestion) {
                                return GestureDetector(
                                  onTap: () {
                                    _searchController.text =
                                        suggestion; // ✅ Show suggestion in search bar
                                    productController.searchProducts(
                                        suggestion); // ✅ Run the search
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 6.0),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.arrow_forward_ios,
                                            size: 14, color: JColors.darkGrey),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            suggestion,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: JColors.darkGrey,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: JSizes.defaultSpace),
                    child: Column(
                      children: [
                        JSectionHeading(
                          title: 'Popular Categories',
                          showActionButton: false,
                        ),
                        SizedBox(height: JSizes.spaceBtwItems),
                        JHomeCategories(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const JBoxesShimmer();
              }
              if (controller.hasError.value) {
                return const Text('Error fetching banners');
              }
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: JSizes.defaultSpace),
                child: JPromoSlider(
                  banners: controller.banners
                      .map((banner) => banner.imageUrl)
                      .toList(),
                ),
              );
            }),
          ),
          SliverToBoxAdapter(
            child: const Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: JSizes.defaultSpace,
                  vertical: JSizes.spaceBtwSections / 2),
              child: JSectionHeading(
                title: 'Popular Products',
                showActionButton: false,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(JSizes.defaultSpace),
            sliver: Obx(() {
              if (productController.isLoading.value) {
                return const SliverToBoxAdapter(child: JBoxesShimmer());
              }
              if (productController.hasError.value) {
                return const SliverToBoxAdapter(
                    child: Text('Error fetching products'));
              }
              if (productController.filteredProducts.isEmpty) {
                return const SliverToBoxAdapter(
                    child: Text('❌ No products found.'));
              }
              return SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final product = productController.filteredProducts[index];
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
                        }
                      },
                    );
                  },
                  childCount: productController.filteredProducts.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 300,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
              );
            }),
          ),
          SliverToBoxAdapter(
            child: Obx(() {
              return productController.isFetchingMore.value
                  ? const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : const SizedBox();
            }),
          ),
        ],
      ),
    );
  }
}
