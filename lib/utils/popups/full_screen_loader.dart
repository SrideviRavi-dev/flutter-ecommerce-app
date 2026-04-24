import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/utils/constant/colors.dart';
import 'package:myapp/utils/helpers/helper_function.dart';
import 'package:myapp/utils/loaders/animation_loader.dart';

class JFullScreenLoader {
  static void openLoadingDialog(String text, String animation) {
    showDialog(
      context: Get.overlayContext!,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: Container(
          color: JHelperFunction.isDarkMode(Get.context!)
              ? JColors.dark
              : JColors.white,
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 250,
                ),
                JAnimationLoaderWidget(text: text, animation: animation),
              ],
            ),
          ),
        ),
      ),
    );
  }
   static stopLoading(){
    Navigator.of(Get.overlayContext!).pop();
  }

}
