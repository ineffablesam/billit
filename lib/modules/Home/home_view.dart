import 'package:billit/modules/Home/Controller/home_controller.dart';
import 'package:billit/modules/Invoice/add_invoice.dart';
import 'package:billit/utils/colors.dart';
import 'package:billit/utils/custom_tap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
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
                      "Invoices",
                      style: GoogleFonts.dmSans(
                        color: Color(0XFF040404),
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Spacer(),
                    CustomTap(
                      onTap: () {
                        Get.to(() => AddInvoicePage());
                      },
                      child: CircleAvatar(
                        radius: 20.r,
                        backgroundColor: Colors.black,
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                    ),
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
                  return ListView.builder(
                    itemCount: controller.invoices.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (_, i) {
                      final invoice = controller.invoices[i];
                      final formattedDate =
                          DateFormat.yMMMd().format(invoice.invoiceCreatedAt);
                      final formattedTotal =
                          NumberFormat.currency(locale: 'en_IN', symbol: '₹')
                              .format(invoice.invoiceTotal);

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "#${invoice.invoiceNumber}",
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                  ),
                                ),
                                Text("Customer: ${invoice.customerName}"),
                                Text("Total: $formattedTotal"),
                                Text("Date: $formattedDate"),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                })
              ],
            ),
          )
        ],
      ),
    );
  }
}
