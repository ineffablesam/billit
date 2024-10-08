import 'dart:typed_data';

import 'package:billit/database/objectbox_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

import '../../../database/product_schema.dart';

class ProductController extends GetxController {
  var isLoading = false.obs;
  var products = <Product>[].obs;
  late ObjectBoxHelper _objectBox;

  // Track if editing
  Product? selectedProduct;

  // TextEditingController instances for the input fields
  TextEditingController nameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  Future<void> loadProducts() async {
    isLoading.value = true;
    _objectBox = await ObjectBoxHelper.getInstance();
    products.value = _objectBox.getAllProducts();
    isLoading.value = false;
  }

  Future<void> addOrUpdateProduct() async {
    isLoading.value = true;

    // Fetch values from the TextFields
    final name = nameController.text.trim();
    final quantity = int.tryParse(quantityController.text.trim()) ?? 0;

    // Remove commas before parsing the price to double
    final priceString = priceController.text.trim().replaceAll(',', '');
    final price = double.tryParse(priceString) ?? 0.0;

    if (selectedProduct != null) {
      // Editing existing product
      selectedProduct!.name = name;
      selectedProduct!.quantity = quantity;
      selectedProduct!.price = price;
      _objectBox.updateProduct(selectedProduct!);
    } else {
      // Adding new product
      final sku = "SKU-${DateTime.now().millisecondsSinceEpoch}";
      final product =
          Product(name: name, quantity: quantity, price: price, sku: sku);
      _objectBox.insertProduct(product);
    }

    await loadProducts();
    clearFields();
    isLoading.value = false;
  }

  void deleteProduct(int id) async {
    isLoading.value = true;
    _objectBox.deleteProduct(id);
    await loadProducts();
  }

  // Method to prefill the fields when editing
  void editProduct(Product product) {
    selectedProduct = product;
    nameController.text = product.name;
    quantityController.text = product.quantity.toString();
    priceController.text = product.price.toString();
  }

  void clearFields() {
    nameController.text = "";
    quantityController.text = "";
    priceController.text = "";
    selectedProduct = null;
  }

  var screenshotController = ScreenshotController();

  Future<void> saveBarcodeImage(Uint8List barcodeImage) async {
    try {
      // Request storage permission
      var status = await Permission.storage.request();

      if (status.isGranted) {
        // Get a directory to save the file
        final directory = await getExternalStorageDirectory();
        final path = p.join(directory!.path, 'barcode_image.png');

        // Save the file as PNG
        ImageGallerySaver.saveImage(barcodeImage);

        // Provide feedback
        Get.snackbar('Success', 'Barcode saved to Gallery',
            backgroundColor: Colors.green);
      } else {
        // If permission is denied
        Get.snackbar('Permission Denied',
            'Storage permission is required to save the barcode');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to save barcode: $e');
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    quantityController.dispose();
    priceController.dispose();
    super.onClose();
  }
}
