import 'package:billit/modules/Auth/auth_view.dart';
import 'package:flutter/animation.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(seconds: 5), () {
      checkLogin();
    });
  }

  // function to return the 'token' from the shared preferences to navigate to the home page or login page
  Future<void> checkLogin() async {
    Get.off(
      () => const AuthView(),
      transition: Transition.fadeIn,
      curve: Curves.easeInOut,
      duration: const Duration(
        milliseconds: 900,
      ),
    );
  }
}
