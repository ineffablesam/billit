import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../utils/assets.dart';
import '../../utils/colors.dart';
import 'Controller/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});
  @override
  Widget build(BuildContext context) {
    // init splash controller
    final SplashController controller = Get.put(SplashController());
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Stack(
        children: [
          Center(
            child: Image.asset(
              AppAssets.splashIcon,
              height: 120.h,
            )
                .animate(
                  delay: const Duration(seconds: 2),
                )
                .fadeOut(
                  duration: const Duration(milliseconds: 200),
                )
                .swap(
                  builder: (_, __) => SvgPicture.asset(
                    AppAssets.logoWithColorSVG,
                    width: 180.w,
                  ).animate().fadeIn(
                        curve: Curves.easeIn,
                        duration: Duration(
                          seconds: 1,
                        ),
                      ),
                ),
          ),
        ],
      ),
    );
  }
}
