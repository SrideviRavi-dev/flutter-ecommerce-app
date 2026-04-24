// ignore_for_file: unnecessary_null_comparison, unnecessary_overrides, avoid_print

import 'package:get/get.dart';
import 'package:myapp/features/shop/models/product_model/product_model.dart';
import 'package:myapp/services/product_services/product_service.dart';

class SimilarProductController extends GetxController {
  var similarProducts = <Product>[].obs;
  var isLoading = true.obs;
  var hasError = false.obs;
  final ProductService _productService = ProductService();

  @override
  void onInit() {
    super.onInit();
  }

  // Fetch similar products by categoryId
  Future<bool> fetchSimilarProducts(String categoryId) async {
    if (categoryId.isEmpty) {
      hasError.value = true;
      Get.log('Error: Invalid categoryId');
      return false;
    }

    try {
      isLoading.value = true;
      similarProducts.value =
          await _productService.fetchProductsByCategoryLimited(categoryId, 20);
      hasError.value = false;
      return true;
    } catch (e) {
      hasError.value = true;
      Get.log('Error fetching similar products: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
