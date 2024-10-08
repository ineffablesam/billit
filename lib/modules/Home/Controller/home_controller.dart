import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../database/invoice_schema.dart';
import '../../../database/objectbox_helper.dart';
import '../../../database/product_schema.dart';

class HomeController extends GetxController {
  var isLoading = false.obs;
  var isIconLoading = false.obs;
  late ObjectBoxHelper _objectBox;

  // Observable lists for invoices and products
  var invoices = <Invoice>[].obs;
  var products = <Product>[].obs;

  // TextEditingController for customer name input
  TextEditingController customerNameController = TextEditingController();

  // List to store selected products and their quantities
  var selectedProducts = <Product>[].obs;
  var selectedProductQuantities = <Product, int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    initializeObjectBox();
  }

  Future<void> initializeObjectBox() async {
    isLoading.value = true;
    _objectBox = await ObjectBoxHelper.getInstance();
    await loadInvoices();
    await loadProducts();
    isLoading.value = false;
  }

  Future<void> loadInvoices() async {
    invoices.value = _objectBox.getAllInvoices();
  }

  Future<void> loadProducts() async {
    products.value = _objectBox.getAllProducts();
  }

  // Add a product with a specified quantity
  void addProductToInvoice(Product product, int quantity) {
    isIconLoading.value = true;
    if (!selectedProducts.contains(product)) {
      selectedProducts.add(product);
    }
    selectedProductQuantities[product] = quantity;
    isIconLoading.value = false;
    update(); // Notify listeners to refresh UI
  }

  void removeProductFromInvoice(Product product) {
    isIconLoading.value = true;
    selectedProducts.remove(product);
    selectedProductQuantities.remove(product); // Remove quantity as well
    isIconLoading.value = false;
    update();
  }

  // Add an invoice and deduct quantities
  Future<void> addInvoice() async {
    isLoading.value = true;

    // Calculate total from selected products
    double invoiceTotal = calculateTotal();

    // Generate the invoice
    final invoice = Invoice(
      invoiceNumber: generateInvoiceNumber(),
      customerName: customerNameController.text.trim(),
      invoiceTotal: invoiceTotal,
      invoiceCreatedAt: DateTime.now(),
      invoiceStatus: 'Paid',
    );

    // Add selected products to the invoice
    invoice.products.addAll(selectedProducts);

    // Save invoice to ObjectBox
    _objectBox.insertInvoice(invoice);

    // Deduct quantities from products
    for (Product product in selectedProducts) {
      int quantity = selectedProductQuantities[product] ?? 0;
      // Update product quantity in ObjectBox
      product.quantity -= quantity;
      _objectBox.updateProduct(product);
    }

    // Reload the products to reflect the updated quantities
    await loadProducts();

    isLoading.value = false;
    clearSelections(); // Clear selected products and quantities
  }

  // Generate a random invoice number
  String generateInvoiceNumber() {
    var rng = Random();
    int randomNumber =
        rng.nextInt(90000) + 10000; // Generate a random 5-digit number
    int suffix = rng.nextInt(900) + 100; // Generate a random 3-digit suffix
    return '$randomNumber-$suffix';
  }

  double calculateTotal() {
    double total = 0;
    selectedProducts.forEach((product) {
      int quantity = selectedProductQuantities[product] ?? 0;
      total += product.price * quantity;
    });
    return total;
  }

  int calculateTotalForRazorpay() {
    double totalInRupees = calculateTotal(); // Get the total in rupees
    int totalInPaise =
        (totalInRupees * 100).round(); // Convert to paise and round
    return totalInPaise;
  }

  void clearSelections() {
    selectedProducts.clear();
    selectedProductQuantities.clear();
  }

  @override
  void onClose() {
    customerNameController.dispose();
    super.onClose();
  }
}
