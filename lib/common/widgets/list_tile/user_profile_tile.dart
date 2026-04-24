// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/common/widgets/images/circular_images.dart';
import 'package:myapp/features/personalization/controllers/user_controller/user_controller.dart';
import 'package:myapp/utils/constant/colors.dart';
import 'package:myapp/utils/constant/image_string.dart';

class JUserProfileTile extends StatelessWidget {
  const JUserProfileTile({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.put(UserController());

    return Obx(() {
      final user = userController.user.value;

     
       final email = user.email.isNotEmpty ? user.email : "jardion@zohomail.in";

      return ListTile(
        leading: JCircularImage(
          image: JImages.user,
          width: 50,
          height: 50,
          padding: 0,
        ),
        subtitle: Text(
          " Jardion",
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .apply(color: JColors.black),
        ),
      );
    });
  }
}
