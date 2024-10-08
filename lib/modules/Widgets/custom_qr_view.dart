import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';

import '../../database/product_schema.dart';
import '../../utils/assets.dart';
import '../../utils/custom_tap.dart';
import '../Products/Controller/product_controller.dart';

class CustomBarCodeView extends StatefulWidget {
  final Product data;
  const CustomBarCodeView({
    super.key,
    required this.data,
  });

  @override
  State<CustomBarCodeView> createState() => _CustomBarCodeViewState();
}

class _CustomBarCodeViewState extends State<CustomBarCodeView> {
  final ProductController controller = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: true,
        extendBody: true,
        floatingActionButton: CustomTap(
          onTap: () {
            Get.back();
          },
          child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                'Close',
                style: GoogleFonts.kantumruyPro(
                  color: Colors.black,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ).paddingSymmetric(
                horizontal: 25.w,
                vertical: 10.h,
              )),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        backgroundColor: Colors.transparent,
        body: FadeIn(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Positioned(
                  top: -55,
                  right: 0,
                  left: 0,
                  child: Container(
                    height: 1.sh,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                    ),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      // physics: BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          SlideInDown(
                            delay: const Duration(milliseconds: 200),
                            from: 1000,
                            child: SizedBox(
                              height: 700.w,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SvgPicture.asset(
                                    AppAssets.idBG,
                                    fit: BoxFit.cover,
                                    width: 1.sw,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      150.verticalSpace,
                                      CircleAvatar(
                                        radius: 40.w,
                                        backgroundColor: Colors.white,
                                      ),
                                      20.verticalSpace,
                                      Text(
                                        widget.data.name,
                                        style: GoogleFonts.kantumruyPro(
                                          fontSize: 24.sp,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        NumberFormat.currency(
                                                locale: 'en_IN', symbol: '₹')
                                            .format(widget.data.price),
                                        style: GoogleFonts.kantumruyPro(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                        ),
                                      ),
                                      10.verticalSpace,
                                      Screenshot(
                                        controller:
                                            controller.screenshotController,
                                        child: Container(
                                          color: Colors.white,
                                          child: Padding(
                                            padding: const EdgeInsets.all(20),
                                            child: BarcodeWidget(
                                              data: widget.data.sku,
                                              backgroundColor: Colors.white,
                                              barcode: Barcode
                                                  .code128(), // Type of barcode
                                              width: 0.7
                                                  .sw, // Width of the barcode
                                              height:
                                                  50.h, // Height of the barcode
                                              drawText:
                                                  true, // Hide the SKU text under the barcode
                                            ),
                                          ),
                                        ),
                                      ),
                                      CustomTap(
                                        onTap: () async {
                                          final barcodeImage = await controller
                                              .screenshotController
                                              .capture();

                                          if (barcodeImage != null) {
                                            // Save the image
                                            await controller
                                                .saveBarcodeImage(barcodeImage);
                                          } else {
                                            Get.snackbar("Error",
                                                "Failed to save barcode.",
                                                snackPosition:
                                                    SnackPosition.BOTTOM);
                                          }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius:
                                                  BorderRadius.circular(12.r)),
                                          padding: EdgeInsets.symmetric(
                                            vertical: 10.h,
                                            horizontal: 30.w,
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.download,
                                                color: Colors.white,
                                                size: 16.sp,
                                              ),
                                              4.horizontalSpace,
                                              Text(
                                                "Save to Gallery",
                                                style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          99.verticalSpace,
                        ],
                      ),
                    ),
                  ),
                ),
                IgnorePointer(
                  ignoring: true,
                  child: Container(
                    height: 0.2.sh,
                    decoration: BoxDecoration(
                      // color: Colors.black,
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: FractionalOffset.topCenter,
                        colors: [
                          Colors.black.withOpacity(1),
                          Colors.transparent,
                        ],
                        stops: const [0, 0.30],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
