import 'package:flutter/material.dart';
import 'package:myapp/utils/constant/colors.dart';
import 'package:myapp/utils/constant/sizes.dart';

class JRoundedContainer extends StatelessWidget {
  const JRoundedContainer(
      {super.key, this.width,
      this.height,
       this.radius = JSizes.cardRadiusLg,
      this.child,
       this.showBorder = false,
       this.borderColor = JColors.borderPrimary,
       this.backgroundColor = JColors.white,
      this.padding,
      this.margin
      });
  final double? width;
  final double? height;
  final double radius;
  final Widget? child;
  final bool showBorder;
  final Color borderColor;
  final Color backgroundColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  @override
  Widget build(BuildContext context) {
   
   return Container(
    width: width,
    height: height,
    padding: padding,
    margin: margin,
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(radius),
      border: showBorder ? Border.all(color: borderColor) : null,
    ),
    child: child,
   );
  }
}
