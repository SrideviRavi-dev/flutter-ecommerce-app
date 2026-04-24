// ignore_for_file: avoid_print

import 'package:get/get.dart';
import 'package:myapp/features/shop/models/banner_model/banner_model.dart';
import 'package:myapp/services/banner_services/banner_services.dart';

class HomeController extends GetxController {
  static HomeController get instance => Get.find();

  // Observable for the current index of the carousel
  final carouselCurrentIndex = 0.obs;

  // Observable for banners and products
  var banners = <Banner>[].obs;
  

  // Loading and error states
  var isLoading = true.obs;
  var hasError = false.obs;

  final BannerService _bannerService = BannerService();

  @override
  void onInit() {
    fetchBanners();
    super.onInit();
  }

  void updatePageIndicator(int index) {
    carouselCurrentIndex.value = index;
  }

  void fetchBanners() async {
    try {
      isLoading.value = true; // Set loading state
      banners.value = await _bannerService.fetchBanners();
      hasError.value = false; // Reset error state
    } catch (e) {
      hasError.value = true; // Set error state
     
    } finally {
      isLoading.value = false; // Reset loading state
    }
  }

  
}
