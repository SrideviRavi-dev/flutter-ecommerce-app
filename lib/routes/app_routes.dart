import 'package:get/get.dart';
import 'package:myapp/features/authentication/screens/login/login.dart';
import 'package:myapp/features/authentication/screens/password_configuration/forgot_password.dart';
import 'package:myapp/features/authentication/screens/signup/signup.dart';
import 'package:myapp/features/authentication/screens/signup/verify_email.dart';
import 'package:myapp/features/personalization/screen/address/address.dart';
import 'package:myapp/features/personalization/screen/settings/settings.dart';
import 'package:myapp/features/shop/screen/cart/cart.dart';
import 'package:myapp/features/shop/screen/categories/category.dart';
import 'package:myapp/features/shop/screen/checkout/checkout.dart';
import 'package:myapp/features/shop/screen/home/home.dart';
import 'package:myapp/features/shop/screen/order/order.dart';
import 'package:myapp/features/shop/screen/product_review/product_review.dart';
import 'package:myapp/features/shop/screen/wishlist/wishlist.dart';

class AppRoutes {
  static final pages = [
    GetPage(name: JRoutes.home, page: () => const HomeScreen()),
    
    GetPage(name: JRoutes.store, page: () =>  CategoryScreen()),
    GetPage(name: JRoutes.favorites, page: () => const FavoriteScreen()),
    GetPage(name: JRoutes.settings, page: () => const SettingsScreen()),
    GetPage(name: JRoutes.prodectReviews, page: () =>  ProductReviewsScreen(productId: Get.arguments)),
    GetPage(name: JRoutes.order, page: () => const OrderScreen()),
    GetPage(name: JRoutes.checkout, page: () =>  CheckoutScreen(checkoutItems: [],)),
    GetPage(name: JRoutes.cart, page: () => const CartScreen()),
    GetPage(name: JRoutes.userAddress, page: () =>  UserAddressScreen()),
    GetPage(name: JRoutes.signup, page: () => const SignUpScreen()),
    GetPage(name: JRoutes.verifyEmail, page: () => const VerifyEmailScreen()),
    GetPage(name: JRoutes.signIn, page: () => const LoginScreen()),
    GetPage(name: JRoutes.forgotPassword, page: () => const ForgotPassword()),
  ];
}

class JRoutes {
  static const home = '/';
  static const store = '/store';
  static const favorites = '/favourites';
  static const settings = '/settings';
  static const subCategories = '/sub-categories';
  static const search = '/search';
  static const prodectReviews = '/product-reviews'; // typo: should be productReviews
  static const productDetails = '/product-details';
  static const order = '/order';
  static const checkout = '/checkout';
  static const cart = '/cart';
  static const brand = '/brand';
  static const allProducts = '/all-products';
  static const userAddress = '/user-address';
  static const signup = '/signup';
  static const signupSuccess = '/signup-success';
  static const verifyEmail = '/verify-email';
  static const signIn = '/sign-in'; // typo: 'sing-in' should be 'sign-in'
  static const resetPassword = '/reset-password';
  static const forgotPassword = '/forgot-password';
}
