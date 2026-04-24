import 'package:get/get.dart';
import 'package:myapp/features/authentication/controllers/auth_controller/auth_controller.dart';
import 'package:myapp/features/authentication/controllers/signup/network_manager.dart';
import 'package:myapp/features/personalization/controllers/user_controller/user_controller.dart';
import 'package:myapp/features/shop/controllers/category_controller/category_controller.dart';
import 'package:myapp/features/shop/controllers/product_controller/product_controller.dart';

class GeneralBindings extends Bindings{
  @override
  void dependencies(){
    Get.put(NetworkManager());
    Get.put(AuthController());      // ✅ Register AuthController
    Get.put(UserController());
    Get.lazyPut(() => ProductController(), fenix: true);
    Get.lazyPut(() => CategoryController(), fenix: true);

  }
}