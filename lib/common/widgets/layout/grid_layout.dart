import 'package:flutter/material.dart';
import 'package:myapp/utils/constant/sizes.dart';

class JGridLayot extends StatelessWidget {
  const JGridLayot({
    this.controller,
    super.key,
    required this.itemCount,
    this.mainAxisExtent = 300,
    required this.itemBuilder,
  });
  final ScrollController? controller;
  final int itemCount;
  final double? mainAxisExtent;
  final Widget? Function(BuildContext, int) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: controller,
      itemCount: itemCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: JSizes.gridViewSpacing,
        crossAxisSpacing: JSizes.gridViewSpacing,
        mainAxisExtent: mainAxisExtent,
        childAspectRatio: 0.62,
      ),
      itemBuilder: itemBuilder,
    );
  }
}
