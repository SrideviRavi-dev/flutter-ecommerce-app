// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:myapp/utils/constant/colors.dart';
import 'package:myapp/utils/constant/sizes.dart';
import 'package:myapp/utils/helpers/helper_function.dart';

class JCircularIcon extends StatelessWidget {
  const JCircularIcon({
    super.key,
    
    this.width,
    this.height,
    this.size = JSizes.lg,
    required this.icon,
    this.color,
    this.backgroundColor,
    this.onPressed,
  });

  
  final double? width, height, size;
  final IconData icon;
  final Color? color;
  final Color? backgroundColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: backgroundColor != null
            ? backgroundColor!
            : JHelperFunction.isDarkMode(context)
            ? JColors.black.withOpacity(0.9)
            : JColors.white.withOpacity(0.9),
      ),
      child: IconButton(onPressed: onPressed, icon:Icon(icon,color: color,size : size)),
    );
  }
}
