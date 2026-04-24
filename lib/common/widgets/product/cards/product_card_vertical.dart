// ignore_for_file: avoid_print, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:myapp/common/style/shadow_style.dart';
import 'package:myapp/common/widgets/container/rounded_container.dart';
import 'package:myapp/common/widgets/icons/favorite_icon.dart';
import 'package:myapp/common/widgets/images/rounded_images.dart';
import 'package:myapp/common/widgets/text/product_price_text.dart';
import 'package:myapp/common/widgets/text/product_title_text.dart';
import 'package:myapp/features/shop/models/product_model/product_model.dart';
import 'package:myapp/utils/constant/colors.dart';
import 'package:myapp/utils/constant/image_string.dart';
import 'package:myapp/utils/constant/sizes.dart';
import 'package:myapp/utils/helpers/helper_function.dart';

class JProductCardsVertical extends StatelessWidget {
  const JProductCardsVertical({
    super.key,
    this.title = 'Red Long Gown',
    this.price = '400',
    this.salePrice = '300',
    required this.imageUrl,
    required this.productId,
    required this.discountPercentage,
    required this.product,
    required this.description,
     this.onTap,
  });

  final String title;
  final String price;
  final String salePrice;
  final List<String> imageUrl;
  final String productId;
  final String discountPercentage;
  final Product product;
  final List<String> description;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final dark = JHelperFunction.isDarkMode(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 180,
        decoration: BoxDecoration(
          boxShadow: [JShadowStyle.verticalProductShadow],
          borderRadius: BorderRadius.circular(JSizes.productImageRadius),
          color: dark ? JColors.darkerGrey : Color(0xFFF5DEB3),
        ),
        child: Column(
          children: [
            /// IMAGE + BADGES
            JRoundedContainer(
              height: 180,
              padding: const EdgeInsets.all(JSizes.sm),
              backgroundColor: dark ? JColors.dark :Color(0xFFF5DEB3),
              child: Stack(
                children: [
                  JRoundedImage(
                    width: double.infinity,
                    height: double.infinity,
                    imageUrl:
                        imageUrl.isNotEmpty ? imageUrl[0] : JImages.dress1,
                    applyImageRadius: true,
                    isNetworkImage: true,
                    fit: BoxFit.cover,
                  ),
                  // Positioned(
                  //   top: 12,
                  //   child: JRoundedContainer(
                  //     radius: JSizes.sm,
                  //     backgroundColor: JColors.secondary.withOpacity(0.8),
                  //     padding: const EdgeInsets.symmetric(
                  //         horizontal: JSizes.sm, vertical: JSizes.sm),
                  //     child: Text(
                  //       '$discountPercentage%',
                  //       style: Theme.of(context)
                  //           .textTheme
                  //           .labelLarge!
                  //           .apply(color: JColors.black),
                  //     ),
                  //   ),
                  // ),
                  Positioned(
                    top: 10,
                    right: 0,
                    child: FavoriteIconButton(
                      productId: productId,
                      title: title,
                      imageUrl: imageUrl[0],
                      price: price,
                      salePrice: salePrice,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: JSizes.spaceBtwItems / 2),

            /// TEXT + PRICE
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: JSizes.sm),
                child: SingleChildScrollView(
                  child: Column(
                     mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      JProductTitleText(title: title, smallSize: true,maxLines: 2,),
                      const SizedBox(height: 2),
                      Text(
                        '$discountPercentage off',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      // const Spacer(),
                       const SizedBox(height: 2),
                      /// PRICE + BUTTON
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                JProductPriceText(
                                    price: price, lineThrough: true),
                                JProductPriceText(salePrice: salePrice),
                              ],
                            ),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              color: JColors.dark,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(JSizes.cardRadiusMd),
                                bottomRight:
                                    Radius.circular(JSizes.productImageRadius),
                              ),
                            ),
                            child: const SizedBox(
                              width: JSizes.iconLg * 1.2,
                              height: JSizes.iconLg * 1.2,
                              child: Center(
                                child: Icon(Iconsax.add, color: JColors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                       const SizedBox(height: 4),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
