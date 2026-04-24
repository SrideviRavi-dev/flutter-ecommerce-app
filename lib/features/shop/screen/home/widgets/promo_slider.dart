import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/common/shimmer_effect/box_shimmer.dart';
import 'package:myapp/common/widgets/images/rounded_images.dart';
import 'package:myapp/features/shop/controllers/home_controller/home_controller.dart';
import 'package:myapp/utils/constant/colors.dart';
import 'package:myapp/utils/constant/sizes.dart';

class JPromoSlider extends StatelessWidget {
  const JPromoSlider({
    super.key,
    required this.banners,
  });
  final List<String> banners;
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>(); 

    return Column(
      children: [
        Obx(() {
          if (controller.isLoading.value) {
            return const JBoxesShimmer(); // Show loading indicator
          }
          if (controller.hasError.value) {
            return const Text('Error fetching banners'); // Show error message
          }
          return CarouselSlider(
            options: CarouselOptions(
              viewportFraction: 1,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              onPageChanged: (index, _) =>
                  controller.updatePageIndicator(index),
            ),
            items: controller.banners
                .map((banner) => JRoundedImage(
                      imageUrl: banner.imageUrl,
                      isNetworkImage: true,
                    ))
                .toList(),
          );
        }),
        const SizedBox(height: JSizes.spaceBtwItems),

        // Carousel indicators
        Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(controller.banners.length, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: controller.carouselCurrentIndex.value == index
                        ? JColors.primary // Active color
                        : JColors.grey, // Inactive color
                  ),
                );
              }),
            )),
      ],
    );
  }
}
