// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
//import 'package:get/get.dart';
import 'package:myapp/common/widgets/appbar/appbar.dart';
//import 'package:myapp/features/personalization/controllers/user_controller/user_controller.dart';
import 'package:myapp/utils/constant/colors.dart';
import 'package:myapp/utils/constant/text_string.dart';

class JHomeAppbar extends StatelessWidget {
  const JHomeAppbar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
   // final userController = Get.put(UserController());
    return JAppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Ensure space between left and right
        children: [
          // Left side - App Logo + Title
          Row(
            children: [
              // App Logo - Circular shape
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ClipOval(
                  child: Image.asset(
                    'assets/logos/jar_logo.png', // 🔥 Your logo path
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Title Column
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // New Text above the main title
                  Text(
                    "Good day for shopping",
                    style: Theme.of(context).textTheme.bodyLarge!.apply(
                          color: JColors.black.withOpacity(0.9),
                        ),
                  ),
                  // Main Title Text
                  Text(
                    JTexts.homeApbarTitle,
                    style: Theme.of(context).textTheme.titleLarge!.apply(
                          color: JColors.black.withOpacity(0.9),
                        ),
                  ),
                ],
              ),
            ],
          ),
          
          // Right side - Username (or Guest User)
        
        ],
      ),
    );
  }
}
