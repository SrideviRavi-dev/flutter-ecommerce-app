// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/common/shimmer_effect/category_shimmer.dart';
import 'package:myapp/common/widgets/image_text_widget/vertical_image_text.dart';
import 'package:myapp/features/shop/controllers/category_controller/category_controller.dart';
import 'package:myapp/features/shop/controllers/product_controller/product_controller.dart';
import 'package:myapp/features/shop/screen/categories/widgets/category_list_screen.dart';

class JHomeCategories extends StatelessWidget {
  const JHomeCategories({super.key});

  @override
  Widget build(BuildContext context) {
    final CategoryController categoryController =
        Get.find<CategoryController>();
    final ProductController productController = Get.find<ProductController>();
    return SizedBox(
      height: 100,
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: categoryController.getCategories().then(
              (categories) =>
                  categories.map((category) => category.toMap()).toList(),
            ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const JCategoryShimmer();
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // Check if data is not null and has items
          final categories = snapshot.data ?? [];
          if (categories.isEmpty) {
            return const Center(child: Text('No categories available.'));
          }

          return ListView.builder(
            shrinkWrap: true,
            itemCount: categories.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, index) {
              final category = categories[index];
              return JVerticalImageText(
                  image: category['image'] ??
                      '', // Ensure a fallback in case of null
                  title: category['name'] ??
                      'Unnamed Category', // Provide a default title
                  onTap: () async {
                    // 👇 Navigate immediately, loader will show there
                    Get.to(
                      () => CategoryListScreen(
                        categoryName: category['name'] ?? '',
                        categoryId: category['id'],
                      ),
                      transition: Transition.noTransition,
                    );
                  });
            },
          );
        },
      ),
    );
  }
}
