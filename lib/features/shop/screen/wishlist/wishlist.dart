// ignore_for_file: avoid_print, unused_local_variable

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:myapp/common/widgets/appbar/appbar.dart';
import 'package:myapp/common/widgets/product/cards/product_card_vertical.dart';
import 'package:myapp/features/shop/models/product_model/product_model.dart';
import 'package:myapp/navigation_manu.dart';
import 'package:myapp/utils/constant/image_string.dart';
import 'package:myapp/utils/constant/sizes.dart';
import 'package:myapp/utils/loaders/animation_loader.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Color(0xFFFAF0E6),
      appBar: const JAppBar(
        title: Text('WishList'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('favorites').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final favorites = snapshot.data!.docs;

          // Debugging output for fetched favorites
          for (var doc in favorites) {
            // Show document data
          }

          if (favorites.isEmpty) {
            return JAnimationLoaderWidget(
              text: 'Your wishlist is empty',
              animation: JImages.emptyFav,
              showAction: true,
              actionText: 'Let\'s Add',
              onActionPressed: () {
                final controller = Get.find<NavigationController>();
                controller.resetIndex();
                Get.offAll(() => const NavigationMenu());
              },
            );
          }

          return Padding(
            padding: const EdgeInsets.all(JSizes.defaultSpace),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.6,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final favorite =
                    favorites[index].data() as Map<String, dynamic>;

                // Extract product details
                String productId = favorite['productId'] ?? '';
                String title = favorite['title'] ?? 'No Title';
                String imageUrl = favorite['imageUrl'] ?? '';
                String price = favorite['price'] ?? '0';
                String salePrice = favorite['salePrice'] ?? '0';
                String description = favorite['description'] ??
                    'No Description'; // Fetch description
                List<String> colors =
                    favorite['colors']?.cast<String>() ?? []; // Fetch colors
                List<String> sizes =
                    favorite['sizes']?.cast<String>() ?? []; // Fetch sizes

                // Convert prices to double for calculations
                double originalPrice = double.tryParse(price) ?? 0.0;
                double discountedPrice = double.tryParse(salePrice) ?? 0.0;

                // Calculate discount percentage
                double discountPercentage =
                    ((originalPrice - discountedPrice) / originalPrice) * 100;
                String discountText = discountPercentage.isNaN
                    ? '0%'
                    : '${discountPercentage.toStringAsFixed(0)}% off';

                Product product = Product(
                  id: productId,
                  title: title,
                  price: originalPrice,
                  salePrice: discountedPrice,
                  imageUrls: [imageUrl],
                  discountPercentage: discountText,
                  description: [],
                  colors: [],
                  sizes: [],
                   colorOptions: [], 
                   categoryId: '',
                  // Add any other required fields here
                );
                return JProductCardsVertical(
                  product: product,
                  title: title,
                  price: price,
                  salePrice: salePrice,
                  imageUrl: [imageUrl],
                  productId: productId,
                  discountPercentage: discountText,
                  description: product.description,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
