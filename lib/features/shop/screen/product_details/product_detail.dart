// ignore_for_file: library_private_types_in_public_api, avoid_print, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:myapp/common/widgets/container/circular_container.dart';
import 'package:myapp/common/widgets/icons/favorite_icon.dart';
import 'package:myapp/common/widgets/page_indicator/page_indicator.dart';
import 'package:myapp/common/widgets/text/section_heading.dart';
import 'package:myapp/features/shop/models/product_model/product_model.dart';
import 'package:myapp/features/shop/models/product_variation_model.dart';
import 'package:myapp/features/shop/screen/checkout/checkout.dart';
import 'package:myapp/features/shop/screen/product_details/widgets/add_to_cart_button.dart';
import 'package:myapp/features/shop/screen/product_details/widgets/product_description.dart';
import 'package:myapp/features/shop/screen/product_details/widgets/product_image_slider.dart';
import 'package:myapp/features/shop/screen/product_details/widgets/product_price_and_offer.dart';
import 'package:myapp/features/shop/screen/product_details/widgets/similar_products.dart';
import 'package:myapp/features/shop/screen/product_details/widgets/size_selection_widget.dart';
import 'package:myapp/features/shop/screen/product_review/product_review.dart';
import 'package:myapp/services/product_services/product_service.dart';
import 'package:myapp/utils/constant/colors.dart';
import 'package:myapp/utils/constant/sizes.dart';
import 'widgets/color_selection_widget.dart';

class ProductDetailScreen extends StatefulWidget {
  final String? title;
  final String? price;
  final String? salePrice;
  final String? offerPercentage;
  final List<String>? imageUrls;
  final String? productId;
  final List<String>? description;
  final String? categoryId;

  const ProductDetailScreen({
    super.key,
    this.title,
    this.price,
    this.salePrice,
    this.imageUrls,
    this.offerPercentage,
    this.productId,
    this.description,
    this.categoryId,
  });

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ProductService _productService = ProductService();
  late Future<Product> _productFuture; // Declare Future variable
  late PageController _pageController;
  int _currentPage = 0;

  // State variables for selected color and size
  String? selectedColor;
  String? selectedSize;

  @override
  void initState() {
    super.initState();
    _productFuture = _productService.fetchProductDetails(widget.productId!);
    _pageController = PageController();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.round() ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Product>(
      future: _productFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || widget.imageUrls!.isEmpty) {
          return const Center(
              child: Text('No product found or no images available.'));
        }

        final product = snapshot.data!;

        // Check if colors and sizes are available
        final availableColors = product.colors
                ?.map((color) =>
                    ProductOption(name: color, color: getColorFromName(color)))
                .toList() ??
            [];
        final availableSizes =
            product.sizes?.map((size) => ProductOption(name: size)).toList() ??
                [];

        return Scaffold(
          appBar: AppBar(title: Text(widget.title!)),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image Slider with Favorite Icon
                Stack(
                  children: [
                    JProductImageSlider(
                      pageController: _pageController,
                      imageUrls: widget.imageUrls!,
                    ),
                    Positioned(
                      right: 16,
                      top: 0,
                      child: FavoriteIconButton(
                        productId: widget.productId!,
                        title: widget.title!,
                        imageUrl: widget.imageUrls!.isNotEmpty
                            ? widget.imageUrls![0]
                            : '',
                        price: widget.price!,
                        salePrice: widget.salePrice!,
                      ),
                    ),
                    Positioned(
                      left: 30,
                      top: 0,
                      child: JCircularContainer(
                        height: 50,
                        width: 50,
                        backgroundColor: JColors.error,
                        child: Center(
                          child: Text(
                            '${widget.offerPercentage!}%',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .apply(color: JColors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Page Indicator
                PageIndicator(
                  currentPage: _currentPage,
                  itemCount: widget.imageUrls!.length,
                ),

                
                const Divider(),

                // Product Title and Price
                JProductPriceAndOffer(widget: widget),

                // Add to Cart Button
                JAddToCartButton(
                  product: product,
                  selectedColor: selectedColor,
                  selectedSize: selectedSize,
                ),
              
                // Product Description
                JProductDescription(bulletPoints: product.description),
                 const Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: JSizes.defaultSpace, vertical: 9),
                  child: Text(
                    'Delivered within 7 days',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: JSizes.defaultSpace, vertical: 9),
                  child: Text(
                    'Within 3 Days Return',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.redAccent,
                    ),
                  ),
                ),
                  

                // Color Selection (only show if colors are available)
                if (availableColors.isNotEmpty)
                  ColorSelectionWidget(
                    colors: availableColors,
                    selectedColor: selectedColor,
                    onColorSelected: (String? colorName) {
                      // Now this is a String?
                      setState(() {
                        selectedColor =
                            colorName; // Directly assign the color name
                        selectedSize =
                            null; // Reset size selection when color changes
                      });
                    },
                  ),

               

                // Size Selection Widget
                if (availableSizes.isNotEmpty)
                  SizeSelectionWidget(
                    sizes: availableSizes,
                    selectedSize: selectedSize,
                    onSizeSelected: (String? sizeName) {
                      // Now this is a String?
                      setState(() {
                        selectedSize =
                            sizeName; // Directly assign the size name
                      });
                    },
                  ),

                // Checkout Button
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(JSizes.defaultSpace),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          final selectedProduct = product;
                          selectedProduct.selectedColor = selectedColor;
                          selectedProduct.selectedSize = selectedSize;
                          selectedProduct.quantity = 1;

                          Get.to(() => CheckoutScreen(
                                checkoutItems: [
                                  selectedProduct
                                ], // Pass only this single product
                              ));
                        },
                        child:
                            const Text('Buy', style: TextStyle(fontSize: 19)),
                      ),
                    ),
                  ),
                ),

                // Product Review and Ratings
                Padding(
                  padding: const EdgeInsets.only(
                      left: JSizes.defaultSpace, right: JSizes.defaultSpace),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const JSectionHeading(
                          title: 'Reviews', showActionButton: false),
                      IconButton(
                        onPressed: () => Get.to(
                            () => ProductReviewsScreen(productId: product.id)),
                        icon: const Icon(Iconsax.arrow_right_3, size: 18),
                      ),
                    ],
                  ),
                ),

                // **Similar Products Section**
                JSimilarProductsSection(categoryId: widget.categoryId!),
              ],
            ),
          ),
        );
      },
    );
  }
}
