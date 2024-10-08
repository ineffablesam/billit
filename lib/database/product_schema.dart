import 'package:objectbox/objectbox.dart';

@Entity()
class Product {
  @Id(assignable: true)
  int id;
  String name;
  int quantity;
  double price;
  String sku;

  Product({
    this.id = 0,
    required this.name,
    required this.quantity,
    required this.price,
    required this.sku,
  });
}
