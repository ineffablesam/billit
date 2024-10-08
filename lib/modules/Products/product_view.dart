import 'package:billit/modules/Products/Controller/product_controller.dart';
import 'package:billit/utils/custom_tap.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../utils/colors.dart';
import '../../utils/input_formatter.dart';
import '../Widgets/custom_qr_view.dart';

class ProductView extends GetView<ProductController> {
  const ProductView({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductController controller = Get.put(ProductController());

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      resizeToAvoidBottomInset: false,
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.scaffoldBg,
            collapsedHeight: 100.h,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: [
                StretchMode.blurBackground,
                StretchMode.fadeTitle,
                StretchMode.zoomBackground,
              ],
              background: Padding(
                padding: EdgeInsets.only(
                  top: 40.h,
                  left: 10.w,
                  right: 10.w,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Products",
                      style: GoogleFonts.dmSans(
                        color: Color(0XFF040404),
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () async {
                        await Get.bottomSheet(
                          Container(
                            padding: EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: AppColors.scaffoldBg,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16.0),
                                topRight: Radius.circular(16.0),
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: 15.h,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Add Product",
                                        style: GoogleFonts.poppins(
                                          color: Color(0XFF040404),
                                          fontSize: 17.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                15.verticalSpace,
                                TextField(
                                  controller: controller.nameController,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(20.0),
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(7.r)),
                                      borderSide: const BorderSide(
                                          width: 0.0,
                                          color: Colors.transparent),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(7.r)),
                                      borderSide: BorderSide(
                                        width: 0.8,
                                        color: AppColors.appPrimary,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(7.r)),
                                      borderSide: const BorderSide(
                                          width: 0.0,
                                          color: Colors.transparent),
                                    ),
                                    fillColor: Colors.white,
                                    hintText: 'Enter Product Name',
                                    prefixIcon: Icon(
                                      CupertinoIcons.pen,
                                    ),
                                  ),
                                ),
                                10.verticalSpace,
                                TextField(
                                  controller: controller.quantityController,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(20.0),
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(7.r)),
                                      borderSide: const BorderSide(
                                          width: 0.0,
                                          color: Colors.transparent),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(7.r)),
                                      borderSide: BorderSide(
                                        width: 0.8,
                                        color: AppColors.appPrimary,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(7.r)),
                                      borderSide: const BorderSide(
                                          width: 0.0,
                                          color: Colors.transparent),
                                    ),
                                    fillColor: Colors.white,
                                    hintText: 'Enter Available Quantity',
                                    prefixIcon: Icon(
                                      Icons.production_quantity_limits,
                                    ),
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                                10.verticalSpace,
                                TextField(
                                  controller: controller.priceController,
                                  inputFormatters: [
                                    FilteringTextInputFormatter
                                        .digitsOnly, // Only allow digits
                                    CommaInputFormatter(),
                                  ],
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(20.0),
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(7.r)),
                                      borderSide: const BorderSide(
                                          width: 0.0,
                                          color: Colors.transparent),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(7.r)),
                                      borderSide: BorderSide(
                                        width: 0.8,
                                        color: AppColors.appPrimary,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(7.r)),
                                      borderSide: const BorderSide(
                                          width: 0.0,
                                          color: Colors.transparent),
                                    ),
                                    fillColor: Colors.white,
                                    hintText: 'Enter Product Price',
                                    prefixIcon: Icon(
                                      Icons.currency_rupee,
                                    ),
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                                10.verticalSpace,
                                Row(
                                  children: [
                                    Expanded(
                                        child: CustomTap(
                                      onTap: () {
                                        controller.addOrUpdateProduct();
                                        Get.back();
                                      },
                                      child: Container(
                                        height: 46.h,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                        ),
                                        child: Text(
                                          "Add Product",
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ))
                                  ],
                                )
                              ],
                            ),
                          ),
                          isScrollControlled: true,
                        );
                      },
                      child: CircleAvatar(
                        radius: 20.r,
                        backgroundColor: Colors.black,
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Obx(() {
                  if (controller.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return MediaQuery.removePadding(
                    removeTop: true,
                    context: context,
                    child: ListView.builder(
                      itemCount: controller.products.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (_, i) {
                        final product = controller.products[i];
                        return SwipeActionCell(
                          key: ValueKey(product.id),
                          backgroundColor: Colors.transparent,
                          trailingActions: <SwipeAction>[
                            SwipeAction(
                              title: "Delete",
                              nestedAction:
                                  SwipeNestedAction(title: "Delete Product"),
                              onTap: (CompletionHandler handler) async {
                                // Show confirmation dialog
                                bool confirmed = await showDialog<bool>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Confirm Delete?'),
                                          content: Text(
                                              'This Actions is not Reversible!'),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(false),
                                              child: Text('Dismiss'),
                                            ),
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(true),
                                              child: Text('Confirm'),
                                            ),
                                          ],
                                        );
                                      },
                                    ) ??
                                    false;

                                // If confirmed, delete the product
                                if (confirmed) {
                                  await handler(true); // Complete the action
                                  controller.deleteProduct(
                                      product.id); // Call your delete function
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          '${product.name} deleted successfully.'),
                                    ),
                                  );
                                } else {
                                  handler(
                                      false); // Close action buttons without deletion
                                }
                              },
                              color: Colors.red,
                            ),
                            SwipeAction(
                              title: "Edit",
                              onTap: (CompletionHandler handler) async {
                                // Set the current product data in the controller before opening the bottom sheet
                                controller.editProduct(product);

                                await Get.bottomSheet(
                                  Container(
                                    padding: EdgeInsets.all(16.0),
                                    decoration: BoxDecoration(
                                      color: AppColors.scaffoldBg,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(16.0),
                                        topRight: Radius.circular(16.0),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                            top: 15.h,
                                          ),
                                          child: Row(
                                            children: [
                                              Text(
                                                "Edit Product",
                                                style: GoogleFonts.poppins(
                                                  color: Color(0XFF040404),
                                                  fontSize: 17.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        15.verticalSpace,
                                        // Prefilled TextField
                                        TextField(
                                          controller: controller.nameController,
                                          decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.all(20.0),
                                            filled: true,
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(7.r)),
                                              borderSide: const BorderSide(
                                                  width: 0.0,
                                                  color: Colors.transparent),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(7.r)),
                                              borderSide: BorderSide(
                                                  width: 0.8,
                                                  color: AppColors.appPrimary),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(7.r)),
                                              borderSide: const BorderSide(
                                                  width: 0.0,
                                                  color: Colors.transparent),
                                            ),
                                            fillColor: Colors.white,
                                            hintText: 'Enter Product Name',
                                            prefixIcon:
                                                Icon(CupertinoIcons.pen),
                                          ),
                                        ),
                                        10.verticalSpace,
                                        TextField(
                                          controller:
                                              controller.priceController,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly, // Only allow digits
                                            CommaInputFormatter(),
                                          ],
                                          decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.all(20.0),
                                            filled: true,
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(7.r)),
                                              borderSide: const BorderSide(
                                                  width: 0.0,
                                                  color: Colors.transparent),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(7.r)),
                                              borderSide: BorderSide(
                                                width: 0.8,
                                                color: AppColors.appPrimary,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(7.r)),
                                              borderSide: const BorderSide(
                                                  width: 0.0,
                                                  color: Colors.transparent),
                                            ),
                                            fillColor: Colors.white,
                                            hintText: 'Enter Product Price',
                                            prefixIcon: Icon(
                                              Icons.currency_rupee,
                                            ),
                                          ),
                                          keyboardType: TextInputType.number,
                                        ),
                                        10.verticalSpace,
                                        Row(
                                          children: [
                                            Expanded(
                                              child: CustomTap(
                                                onTap: () {
                                                  controller
                                                      .addOrUpdateProduct();
                                                  Get.back();
                                                },
                                                child: Container(
                                                  height: 46.h,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    color: Colors.black,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.r),
                                                  ),
                                                  child: Text(
                                                    "Update Product",
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  isScrollControlled: true,
                                );
                                controller.clearFields();
                                handler(false);
                              },
                              color: Colors.grey,
                            ),
                          ],
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 0.9.sw,
                              // height: 90.h,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 0.6,
                                  color: Colors.grey.shade200,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 14),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              product.name.toString(),
                                              style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 15,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              "Available Quantity: ${product.quantity}",
                                              style: GoogleFonts.poppins(
                                                color: Colors.grey.shade800,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 10,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              "${product.sku}",
                                              style: GoogleFonts.poppins(
                                                color: Colors.grey.shade800,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          NumberFormat.currency(
                                                  locale: 'en_IN', symbol: '₹')
                                              .format(product.price),
                                          style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                    CustomTap(
                                      onTap: () {
                                        context.pushTransparentRoute(
                                          CustomBarCodeView(
                                            data: product,
                                          ),
                                        );
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Icon(
                                            Icons.touch_app_outlined,
                                            color: AppColors.appPrimaryDark,
                                            size: 20.sp,
                                          ),
                                          Text(
                                            "View Barcode",
                                            style: GoogleFonts.poppins(
                                              color: AppColors.appPrimaryDark,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // BarcodeWidget(
                                    //   data: product
                                    //       .sku, // SKU used for generating the barcode
                                    //   barcode:
                                    //       Barcode.code128(), // Type of barcode
                                    //   width: 0.7.sw, // Width of the barcode
                                    //   height: 50.h, // Height of the barcode
                                    //   drawText:
                                    //       false, // Hide the SKU text under the barcode
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),
              ],
            ),
          )
        ],
      ),
    );
  }
}
