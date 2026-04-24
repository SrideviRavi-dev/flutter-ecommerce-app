import 'package:flutter/material.dart';
import 'package:myapp/common/widgets/images/circular_images.dart';
import 'package:myapp/utils/constant/colors.dart';
import 'package:myapp/utils/constant/sizes.dart';

class JVerticalImageText extends StatelessWidget {
  const JVerticalImageText({
    super.key,
    required this.image,
    required this.title,
    this.textColor = JColors.black,
    this.backgroundColor = JColors.white,
    this.onTap,
    this.isNetworkImage = true,
  });
  final String image, title;
  final Color textColor;
  final Color? backgroundColor;
  final void Function()? onTap;
  final bool isNetworkImage;
  @override
  Widget build(BuildContext context) {
    //final dark = JHelperFunction.isDarkMode(context);
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: JSizes.spaceBtwItems),
        child: Column(
          children: [
            SizedBox(
              width: 55, // ✅ Add fixed width to image
              height: 55,
              child: JCircularImage(
                image: image,
                fit: BoxFit.fitWidth,
                padding: 3,
                isNetworkImage: isNetworkImage,
                backgroundColor: backgroundColor,
                // overlayColor: JHelperFunction.isDarkMode(context) ? JColors.light : JColors.dark,
              ),
            ),
            const SizedBox(
              height: JSizes.spaceBtwItems / 3,
            ),
            SizedBox(
              width: 55,
              child: Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .labelSmall!
                    .apply(color: textColor),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
