// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:myapp/utils/constant/colors.dart';

class JShadowStyle{
  static final verticalProductShadow = BoxShadow(
    color: JColors.darkerGrey.withOpacity(0.1),
    blurRadius: 50,
    spreadRadius: 7,
    offset: const Offset(0, 2)
  );

  static final horizontalProductShadow = BoxShadow(
    color: JColors.darkerGrey.withOpacity(0.1),
    blurRadius: 50,
    spreadRadius: 7,
    offset: const Offset(0, 2)
  );
}