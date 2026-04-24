import 'package:flutter/material.dart';
import 'package:myapp/utils/constant/colors.dart';
import 'package:myapp/features/shop/models/product_variation_model.dart';
import 'package:myapp/utils/constant/sizes.dart'; // Update this import based on your structure

class SizeSelectionWidget extends StatelessWidget {
  final List<ProductOption> sizes;
  final String? selectedSize;
  final ValueChanged<String?> onSizeSelected; // Change type to String?

  const SizeSelectionWidget({
    super.key,
    required this.sizes,
    required this.selectedSize,
    required this.onSizeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: JSizes.defaultSpace, right: JSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Select Size',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8.0),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: sizes.map((sizeOption) {
              return GestureDetector(
                onTap: () =>
                    onSizeSelected(sizeOption.name), // Pass the size name
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 8.0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: selectedSize == sizeOption.name
                            ? Colors.grey.shade300
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey, width: 2),
                      ),
                      child: Text(sizeOption.name),
                    ),
                    if (selectedSize == sizeOption.name)
                      const Icon(
                        Icons.check,
                        color: JColors.black,
                        size: 25,
                      ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
