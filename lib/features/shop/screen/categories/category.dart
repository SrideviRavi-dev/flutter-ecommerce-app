import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/common/widgets/appbar/appbar.dart';
import 'package:myapp/features/shop/controllers/category_controller/category_controller.dart';
import 'package:myapp/features/shop/screen/categories/widgets/category_list_screen.dart';
import 'package:myapp/utils/constant/colors.dart';
import 'package:myapp/utils/constant/sizes.dart';

class CategoryScreen extends StatelessWidget {
  CategoryScreen({super.key});
  final CategoryController categoryController = Get.put(CategoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 191, 237, 243),
        appBar: JAppBar(
          title: const Text('All Categories'),
          showBackArrow: false,
          // actions: [
          //   IconButton(
          //       onPressed: () {}, icon: const Icon(Iconsax.search_normal)),
          // ],
        ),
        body: Obx(() {
          if (categoryController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (categoryController.hasError.value) {
            return const Center(child: Text('Failed to load categories.'));
          }
          if (categoryController.categories.isEmpty) {
            return const Center(child: Text('No categories found.'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(JSizes.spaceBtwItems),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 1.0,
            ),
            itemCount: categoryController.categories.length,
            itemBuilder: (context, index) {
              final category = categoryController.categories[index];
              return GestureDetector(
                onTap: () {
                  Get.to(() => CategoryListScreen(
                        categoryName: category.name,
                        categoryId: category.id,
                      ));
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(JSizes.sm),
                          child: Image.network(
                            category.image,
                            fit: BoxFit.contain,
                            width: double.infinity,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: JSizes.sm),
                          child: Text(
                            category.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(color: JColors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }));
  }
}
