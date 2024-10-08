import 'package:billit/modules/Home/Controller/home_controller.dart';
import 'package:billit/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

import '../../database/product_schema.dart';
import '../../utils/custom_tap.dart';

class AddInvoicePage extends StatefulWidget {
  const AddInvoicePage({super.key});

  @override
  State<AddInvoicePage> createState() => _AddInvoicePageState();
}

class _AddInvoicePageState extends State<AddInvoicePage> {
  Future<void> scanBarcodeAndAddProduct(
      HomeController controller, BuildContext ctx) async {
    String barcodeScanRes;

    try {
      var res = await Navigator.push(
          ctx,
          MaterialPageRoute(
            builder: (context) => const SimpleBarcodeScannerPage(),
          ));
      if (res != '-1') {
        // Assuming barcodeScanRes is the SKU
        Product? scannedProduct = controller.products.firstWhere(
          (product) => product.sku == res,
          orElse: () => Product(
            name: '',
            price: 0,
            quantity: 0,
            sku: '',
          ),
        );

        if (scannedProduct != null) {
          // If product is found, add it to the invoice with default quantity of 1
          controller.addProductToInvoice(scannedProduct, 1);
        } else {
          Get.snackbar(
            "Error",
            "Product not found.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      }
    } catch (e) {
      barcodeScanRes = 'Failed to scan barcode.';
      Get.snackbar(
        "Error",
        barcodeScanRes,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  String merchantKeyValue = "rzp_live_ILgsfZCZoFIKMb";
  String amountValue = "100";
  String orderIdValue = "";
  String mobileNumberValue = "8888888888";

  late Razorpay razorpay;

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg,
        title: Text(
          "Add Invoice",
          style: GoogleFonts.poppins(
            color: Color(0XFF040404),
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: controller.customerNameController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(20.0),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(7.r)),
                        borderSide: const BorderSide(
                            width: 0.0, color: Colors.transparent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(7.r)),
                        borderSide:
                            BorderSide(width: 0.8, color: AppColors.appPrimary),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(7.r)),
                        borderSide: const BorderSide(
                            width: 0.0, color: Colors.transparent),
                      ),
                      fillColor: Colors.grey.shade300,
                      hintText: 'Enter Customer Name',
                      prefixIcon: Icon(CupertinoIcons.pen),
                    ),
                  ),
                  10.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Select Products",
                        style: GoogleFonts.poppins(
                          color: AppColors.appPrimaryDark,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  10.verticalSpace,
                  Obx(() {
                    if (controller.isIconLoading.value)
                      return CircularProgressIndicator();
                    else
                      return Column(
                        children: [
                          GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1.5,
                              crossAxisSpacing: 8.0,
                              mainAxisSpacing: 8.0,
                            ),
                            shrinkWrap: true,
                            itemCount: controller.products.length,
                            itemBuilder: (_, index) {
                              final product = controller.products[index];
                              return GestureDetector(
                                onTap: () {
                                  if (controller.selectedProducts
                                      .contains(product)) {
                                    controller
                                        .removeProductFromInvoice(product);
                                  } else {
                                    controller.addProductToInvoice(product, 1);
                                  }
                                },
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 300),
                                  padding: EdgeInsets.all(12.0),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(
                                      color: controller.selectedProducts
                                              .contains(product)
                                          ? Colors.green.shade400
                                          : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(product.name,
                                              style: TextStyle(fontSize: 16)),
                                          Text(
                                            "Price: ₹${product.price}, Available: ${product.quantity}",
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                      if (controller.selectedProducts
                                          .contains(product))
                                        InputQty(
                                          maxVal: product.quantity,
                                          initVal: controller
                                                      .selectedProductQuantities[
                                                  product] ??
                                              1,
                                          minVal: 1,
                                          steps: 1,
                                          onQtyChanged: (val) {
                                            if (val > product.quantity) {
                                              Get.snackbar(
                                                "Error",
                                                "Quantity exceeds available stock.",
                                                snackPosition:
                                                    SnackPosition.BOTTOM,
                                                backgroundColor: Colors.red,
                                                colorText: Colors.white,
                                              );
                                            } else {
                                              controller
                                                      .selectedProductQuantities[
                                                  product] = val.toInt();
                                              controller.update();
                                            }
                                          },
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Obx(() {
                              double total = controller.calculateTotal();
                              return Text(
                                "Total: ₹$total",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              );
                            }),
                          ),
                        ],
                      );
                  }),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTap(
                          onTap: () {
                            Razorpay razorpay = Razorpay();
                            var options = {
                              'key': 'rzp_live_ILgsfZCZoFIKMb',
                              'amount': controller.calculateTotalForRazorpay(),
                              'name': 'Acme Corp.',
                              'description': 'Fine T-Shirt',
                              'retry': {'enabled': true, 'max_count': 1},
                              'send_sms_hash': true,
                              'prefill': {
                                'contact': '8888888888',
                                'email': 'test@razorpay.com'
                              },
                              'external': {
                                'wallets': ['paytm']
                              }
                            };
                            // var options = {
                            //   'amount': 10000,
                            //   'currency': 'INR',
                            //   'prefill': {
                            //     'contact': '9877597717',
                            //     'email': 'pshibu567@gmail.com'
                            //   },
                            //   'theme': {'color': '#0CA72F'},
                            //   'send_sms_hash': true,
                            //   'retry': {'enabled': false, 'max_count': 4},
                            //   'key': 'rzp_test_5sHeuuremkiApj',
                            //   'order_id': 'order_N0fmkHxFIp7wQh',
                            //   'disable_redesign_v15': false,
                            //   'experiments.upi_turbo': true,
                            //   'ep':
                            //       'https://api-web-turbo-upi.ext.dev.razorpay.in/test/checkout.html?branch=feat/turbo/tpv'
                            // };
                            razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,
                                handlePaymentErrorResponse);
                            razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
                                handlePaymentSuccessResponse);
                            razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,
                                handleExternalWalletSelected);
                            razorpay.open(options);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.blue.shade800,
                                borderRadius: BorderRadius.circular(12.r)),
                            padding: EdgeInsets.symmetric(
                              vertical: 15.h,
                              horizontal: 30.w,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.payments,
                                  color: Colors.white,
                                  size: 16.sp,
                                ),
                                4.horizontalSpace,
                                Text(
                                  "Checkout with RazorPay",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  10.verticalSpace,
                  Row(
                    children: [
                      Expanded(
                        child: CustomTap(
                          onTap: () {
                            scanBarcodeAndAddProduct(controller, context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(12.r)),
                            padding: EdgeInsets.symmetric(
                              vertical: 15.h,
                              horizontal: 30.w,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.barcode_reader,
                                  color: Colors.white,
                                  size: 16.sp,
                                ),
                                4.horizontalSpace,
                                Text(
                                  "Scan Barcode",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  10.verticalSpace,
                  Row(
                    children: [
                      Expanded(
                        child: CustomTap(
                          onTap: () {
                            controller.addInvoice();
                            Get.back();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(12.r)),
                            padding: EdgeInsets.symmetric(
                              vertical: 15.h,
                              horizontal: 30.w,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.save,
                                  color: Colors.white,
                                  size: 16.sp,
                                ),
                                4.horizontalSpace,
                                Text(
                                  "Save Invoice",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    /** PaymentFailureResponse contains three values:
     * 1. Error Code
     * 2. Error Description
     * 3. Metadata
     **/
    showAlertDialog(context, "Payment Failed",
        "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) {
    /** Payment Success Response contains three values:
     * 1. Order ID
     * 2. Payment ID
     * 3. Signature
     **/
    showAlertDialog(
        context, "Payment Successful", "Payment ID: ${response.paymentId}");
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    showAlertDialog(
        context, "External Wallet Selected", "${response.walletName}");
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    // set up the buttons
    Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed: () {},
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class RZPButton extends StatelessWidget {
  String labelText;
  VoidCallback onPressed;
  double widthSize = 100.0;

  RZPButton(
      {required this.widthSize,
      required this.labelText,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widthSize,
      height: 50.0,
      margin: EdgeInsets.fromLTRB(12.0, 8.0, 8.0, 12.0),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          labelText,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.indigoAccent),
        ),
      ),
    );
  }
}
