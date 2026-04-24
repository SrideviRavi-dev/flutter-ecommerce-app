import 'package:flutter/material.dart';
import 'package:myapp/common/widgets/container/rounded_container.dart';
import 'package:myapp/common/widgets/text/section_heading.dart';
import 'package:myapp/utils/constant/colors.dart';
import 'package:myapp/utils/constant/sizes.dart';

class JProductDescription extends StatelessWidget {
  final List<String> bulletPoints; // Change to a list of strings for bullet points

  const JProductDescription({
    super.key,
    required this.bulletPoints, // Require it in the constructor
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(JSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const JSectionHeading(
              title: 'Product Description', showActionButton: false),
          const SizedBox(height: JSizes.spaceBtwItems),
          JRoundedContainer(
            padding: const EdgeInsets.all(JSizes.sm),
            width: double.infinity,
            showBorder: true,
            borderColor: JColors.grey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: bulletPoints.map((point) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(fontSize: 16)), // Bullet character
                    Expanded(
                      child: Text(point, style: const TextStyle(fontSize: 14)),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
