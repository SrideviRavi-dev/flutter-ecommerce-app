// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:myapp/features/shop/models/category_model/category_model.dart';

class CategoryController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static CategoryController get instance => Get.find();

  var categories = <CategoryModel>[].obs;
  var isLoading = true.obs;
  var hasError = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  /// Fetch categories and return a list of `CategoryModel`
  Future<List<CategoryModel>> getCategories() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await _db.collection('categories').get();

      return snapshot.docs
          .map((doc) => CategoryModel.fromSnapshot(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to load categories: $e');
    }  
  }     

  /// Fetch categories and update observable list
  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      List<CategoryModel> fetchedCategories = await getCategories();
      categories.value = fetchedCategories;
    } catch (e) {
      hasError.value = true;
      print('Failed to load categories: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
}     
