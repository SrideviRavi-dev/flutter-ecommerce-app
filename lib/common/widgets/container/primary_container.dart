// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:myapp/common/widgets/container/circular_container.dart';
import 'package:myapp/common/widgets/curved_edges/curved_edges_widgets.dart';
import 'package:myapp/utils/constant/colors.dart';

class JPrimaryHeaderContainer extends StatelessWidget {
  const JPrimaryHeaderContainer({
    super.key,
    required this.child,
  });
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return JCurvedEdgeWidget(
      child: Container(
        color: JColors.primary,
        padding: const EdgeInsets.all(0),
        child: Stack(
          children: [
            Positioned(
                top: -150,
                right: -250,
                child: JCircularContainer(
                    backgroundColor: JColors.textWhite.withOpacity(0.2))),
            Positioned(
              top: 100,
              right: -300,
              child: JCircularContainer(
                  backgroundColor: JColors.textWhite.withOpacity(0.2)),
            ),
            child
          ],
        ),
      ),
    );
  }
}
