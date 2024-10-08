import 'package:get/get.dart';

import '../modules/Home/Controller/home_binding.dart';
import '../modules/Home/home_view.dart';
import '../modules/Splash/Controller/splash_binding.dart';
import '../modules/Splash/splash_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
  ];
}
