import 'package:animations/animations.dart';
import 'package:billit/modules/Account/account_view.dart';
import 'package:billit/modules/Home/home_view.dart';
import 'package:billit/modules/Products/product_view.dart';
import 'package:billit/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solar_icons/solar_icons.dart';

import 'Controller/layout_controller.dart';

class LayoutView extends GetView<LayoutController> {
  const LayoutView({super.key});

  @override
  Widget build(BuildContext context) {
    const activeColor = Color(0xFF000000);
    const inactiveColor = Color(0XFFBCBCBC);
    final bottomNavBarController = Get.put(LayoutController());

    return Obx(() {
      if (bottomNavBarController.isLoading.value) {
        return const Scaffold(
          backgroundColor: Color(0XFFFFFFFF),
          body: Center(
            child: CircularProgressIndicator(
              color: Color(0XFF0373F3),
              strokeWidth: 0.8,
            ),
          ),
        );
      }

      List<Widget> _userPages = [
        HomeView(),
        ProductView(),
        AccountView(),
      ];
      List<Widget> _userDestinations = [
        const NavigationDestination(
          icon: Icon(
            SolarIconsOutline.document,
            color: inactiveColor,
          ),
          selectedIcon: Icon(
            SolarIconsOutline.document,
            color: activeColor,
          ),
          label: 'Invoice',
          tooltip: '',
        ),
        const NavigationDestination(
          icon: Icon(
            SolarIconsOutline.cart,
            color: inactiveColor,
          ),
          selectedIcon: Icon(
            SolarIconsOutline.cart,
            color: activeColor,
          ),
          label: 'Products',
          tooltip: '',
        ),
        NavigationDestination(
          icon: Icon(
            SolarIconsOutline.user,
            color: inactiveColor,
          ),
          selectedIcon: Icon(
            SolarIconsOutline.user,
            color: activeColor,
          ),
          label: 'Account',
          tooltip: '',
        ),
      ];

      final double bottomNavBarHeight = 60.h;
      return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: PageTransitionSwitcher(
              duration: const Duration(milliseconds: 400),
              reverse: bottomNavBarController.currentIndex <
                  bottomNavBarController.previousPageIndex,
              transitionBuilder: (child, animation, secondaryAnimation) =>
                  SharedAxisTransition(
                    fillColor: Colors.white,
                    animation: animation,
                    secondaryAnimation: secondaryAnimation,
                    transitionType: SharedAxisTransitionType.horizontal,
                    child: child,
                  ),
              child: _userPages.elementAt(bottomNavBarController.currentIndex)),
          bottomNavigationBar: NavigationBarTheme(
            data: NavigationBarThemeData(
              labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
                (Set<WidgetState> states) =>
                    states.contains(WidgetState.selected)
                        ? GoogleFonts.kantumruyPro(
                            color: activeColor,
                            fontWeight: FontWeight.w700,
                          )
                        : GoogleFonts.kantumruyPro(
                            color: inactiveColor,
                          ),
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.grey.shade400,
                    width: 1.0,
                  ),
                ),
              ),
              child: NavigationBar(
                backgroundColor: AppColors.scaffoldBg,
                indicatorColor: AppColors.appPrimary.withOpacity(0.1),
                elevation: 0,
                destinations: _userDestinations,
                selectedIndex: bottomNavBarController.currentIndex,
                onDestinationSelected: (index) {
                  HapticFeedback.lightImpact();
                  bottomNavBarController.updatePageIndex(index);
                },
              ),
            ),
          ),
        ),
      );
    });
  }
}
