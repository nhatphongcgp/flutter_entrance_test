import 'package:get/get.dart';

import '../modules/categories/bindings/categories_binding.dart';
import '../modules/categories/views/categories_view.dart';
import '../modules/authentication/sign_up/bindings/sign_up_binding.dart';
import '../modules/authentication/sign_up/views/sign_up_view.dart';

part 'app_routes.dart';

class AppPages {
  static const initial = Routes.SIGN_UP;

  static final routes = [
    GetPage(
      name: Routes.SIGN_UP,
      page: () => const SignUpView(),
      binding: SignUpBinding(),
    ),
    GetPage(
      name: Routes.CATEGORIES,
      page: () => const CategoriesView(),
      binding: CategoriesBinding(),
    ),
  ];
}
