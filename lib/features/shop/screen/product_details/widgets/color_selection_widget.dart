import 'package:flutter/material.dart';
import 'package:myapp/features/shop/models/product_variation_model.dart';

class ColorSelectionWidget extends StatelessWidget {
  final List<ProductOption> colors;
  final String? selectedColor;
  final ValueChanged<String?> onColorSelected; // Change type to String?

  const ColorSelectionWidget({
    super.key,
    required this.colors,
    required this.selectedColor,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Select Color', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8.0),
          Row(
            children: colors.map((colorOption) {
              return GestureDetector(
                onTap: () => onColorSelected(colorOption.name), // Pass the color name
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 8.0),
                      width: 33,
                      height: 33,
                      decoration: BoxDecoration(
                        color: colorOption.color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: selectedColor == colorOption.name ? Colors.white : Colors.black,
                          width: 2,
                        ),
                      ),
                    ),
                    if (selectedColor == colorOption.name)
                      const Icon(Icons.check, color: Colors.white, size: 25),
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
