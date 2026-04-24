import 'package:flutter/material.dart';
import 'package:myapp/utils/constant/colors.dart';
import 'package:myapp/utils/constant/sizes.dart';
import 'package:myapp/utils/helpers/helper_function.dart';

class JCircularImage extends StatelessWidget {
  const JCircularImage({
    super.key,
    this.fit = BoxFit.cover,
    required this.image,
    this.isNetworkImage = false,
    this.overlayColor,
    this.backgroundColor,
    this.width = 56,
    this.height = 56,
    this.padding = JSizes.sm,
  });

  final BoxFit? fit;
  final String image;
  final bool isNetworkImage;
  final Color? overlayColor;
  final Color? backgroundColor;
  final double width, height, padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: backgroundColor ??
            (JHelperFunction.isDarkMode(context)
                ? JColors.black
                : JColors.white),
        borderRadius: BorderRadius.circular(100),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Center(
          child: isNetworkImage
              ? Image.network(
                  image,
                  fit: fit,
                  color: overlayColor,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                        Icons.broken_image); // Or a placeholder asset
                  },
                )
              : Image.asset(
                  image,
                  fit: fit,
                  color: overlayColor,
                ),
        ),
      ),
    );
  }
}
