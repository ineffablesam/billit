import 'package:billit/database/product_schema.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Invoice {
  int id = 0; // Auto increment ID
  String invoiceNumber;
  String invoiceStatus;
  String customerName;
  double invoiceTotal;
  DateTime invoiceCreatedAt;
  final products = ToMany<Product>();

  Invoice({
    required this.invoiceNumber,
    required this.invoiceStatus,
    required this.customerName,
    required this.invoiceTotal,
    required this.invoiceCreatedAt,
  });
}
