// lib/common/widgets/page_indicator.dart
import 'package:flutter/material.dart';
import 'package:myapp/utils/constant/colors.dart';

class PageIndicator extends StatelessWidget {
  final int currentPage;
  final int itemCount;

  const PageIndicator({
    super.key,
    required this.currentPage,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(itemCount, (index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            width: currentPage == index ? 10 : 6,
            height: currentPage == index ? 10 : 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: currentPage == index ? JColors.primary : Colors.grey,
            ),
          );
        }),
      ),
    );
  }
}
