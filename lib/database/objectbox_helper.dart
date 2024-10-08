import 'package:billit/database/invoice_schema.dart';
import 'package:billit/database/product_schema.dart';

import '../objectbox.g.dart';

class ObjectBoxHelper {
  // Singleton instance
  static ObjectBoxHelper? _instance;

  late final Store store;
  late final Box<Product> productBox;
  late final Box<Invoice> invoiceBox;

  ObjectBoxHelper._create(this.store) {
    productBox = Box<Product>(store);
    invoiceBox = Box<Invoice>(store);
  }

  // Singleton method to create or return the existing instance
  static Future<ObjectBoxHelper> getInstance() async {
    if (_instance == null) {
      final store = await openStore();
      _instance = ObjectBoxHelper._create(store);
    }
    return _instance!;
  }

  // Product Management Functions

  void insertProduct(Product product) {
    productBox.put(product);
  }

  List<Product> getAllProducts() {
    return productBox.getAll();
  }

  Product? getProductById(int id) {
    return productBox.get(id);
  }

  void updateProduct(Product p) {
    final product = productBox.get(p.id); // Get product by ID
    if (product != null) {
      product.name = p.name;
      product.quantity = p.quantity;
      product.price = p.price;
      productBox.put(product);
    }
  }

  void deleteProduct(int id) {
    productBox.remove(id);
  }

  // Invoice Management Functions

  void insertInvoice(Invoice invoice) {
    // Add products associated with the invoice
    invoiceBox.put(invoice);
  }

  List<Invoice> getAllInvoices() {
    return invoiceBox.getAll();
  }

  Invoice? getInvoiceById(int id) {
    return invoiceBox.get(id);
  }

  void updateInvoice(Invoice i) {
    final invoice = invoiceBox.get(i.id); // Get invoice by ID
    if (invoice != null) {
      invoice.customerName = i.customerName;
      invoice.invoiceTotal = i.invoiceTotal;
      invoice.products.clear();
      invoice.products.addAll(i.products); // Update associated products
      invoiceBox.put(invoice);
    }
  }

  void deleteInvoice(int id) {
    invoiceBox.remove(id);
  }

  // Closing the store
  void close() {
    store.close();
  }
}
