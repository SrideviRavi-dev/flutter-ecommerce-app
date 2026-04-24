import 'package:flutter/material.dart';
import 'package:myapp/common/widgets/curved_edges/curved_edges.dart';

class JCurvedEdgeWidget extends StatelessWidget {
  const JCurvedEdgeWidget({
    super.key, this.child,
  });
  
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: JCustomCurvedEdges(),
      child:child,
    );
  }
}
