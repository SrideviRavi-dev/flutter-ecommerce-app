// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:myapp/utils/constant/colors.dart';

class JProductPriceText extends StatelessWidget {
  const JProductPriceText({
    super.key,
    this.currenncySign = '₹',
    this.price = '0',
    this.maxLines = 1,
    this.isLarge = false,
    this.lineThrough = false,
    this.fontSize,
    this.salePrice = '0',
  });

  final String currenncySign, price;
  final int maxLines;
  final bool isLarge;
  final bool lineThrough;
  final double? fontSize;
  final String salePrice;

  @override
  Widget build(BuildContext context) {
    TextStyle baseStyle = isLarge
        ? Theme.of(context).textTheme.headlineMedium!.apply(color: JColors.black.withOpacity(0.9))
        : Theme.of(context).textTheme.titleLarge!.apply(color: JColors.black.withOpacity(0.9));

    // Create the display text
    String displayText = '';

    // Only include the sale price if it is valid and not '0'
    if (salePrice.isNotEmpty && salePrice != '0' && salePrice != '0.0' && salePrice != '0.00') {
      displayText = '$currenncySign$salePrice ';
    }

    // Always include the original price, but only if it's not '0'
    if (price != '0' && price != '0.0' && price != '0.00') {
      displayText += '$currenncySign$price';
    } else if (displayText.isEmpty) {
      // If displayText is still empty, consider showing a default message
      displayText = '$currenncySign$price'; // This handles cases where price might be 0
    }

    return Text(
      displayText.trim(), // Trim any leading or trailing spaces
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: baseStyle.copyWith(
        fontSize: fontSize,
        decoration: lineThrough && price != '0' ? TextDecoration.lineThrough : null,
      ),
    );
  }
}
