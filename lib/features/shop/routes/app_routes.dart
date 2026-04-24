import 'package:get/get.dart';
import 'package:myapp/features/shop/routes/routes.dart';
import 'package:myapp/features/shop/screen/product_details/product_detail.dart';
import 'package:myapp/navigation_manu.dart';
class AppRoutes {
  static final pages = [
  GetPage(name: JRoutes.home, page: ()=> const NavigationMenu()),
  GetPage(name: JRoutes.productDetail, page: ()=> const ProductDetailScreen()),
  


  ];
}

