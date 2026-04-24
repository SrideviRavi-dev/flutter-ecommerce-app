import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart'; // Import the share_plus package
import 'package:myapp/common/widgets/text/product_offer_text.dart';
import 'package:myapp/common/widgets/text/product_price_text.dart';
import 'package:myapp/common/widgets/text/product_title_text.dart';
import 'package:myapp/features/shop/screen/product_details/product_detail.dart';
import 'package:myapp/utils/constant/sizes.dart';

class JProductPriceAndOffer extends StatelessWidget {
  const JProductPriceAndOffer({
    super.key,
    required this.widget,
  });

  final ProductDetailScreen widget;

  // Method to handle the sharing functionality
  void _shareProduct() {
    final productUrl =
        "https://jardion.in/product/${widget.productId}"; // Assuming you have product ID in widget
    final shareMessage =
        "Check out this amazing product: ${widget.title}\n\nPrice: ${widget.salePrice}\n\nDetails: $productUrl";

    Share.share(shareMessage);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(JSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Display the product title
              JProductTitleText(title: widget.title!, smallSize: false),
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: _shareProduct, // Call the share method when clicked
                color: Colors.black, // Customize icon color
              ),
            ],
          ),
          Row(
            children: [
              // Display the offer percentage
              JProductOfferText(
                offerPercentage: widget.offerPercentage!,
              ),
              const SizedBox(width: JSizes.spaceBtwItems),
              // Display the sale price
              JProductPriceText(
                price: widget
                    .salePrice!, // Change to salePrice for discounted price
                fontSize: 28,
              ),
            ],
          ),
          Row(
            children: [
              const JProductTitleText(title: 'MRP : ', smallSize: false),
              // Display the original price with a line through
              JProductPriceText(
                price: widget.price!, // Display original price
                lineThrough: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
