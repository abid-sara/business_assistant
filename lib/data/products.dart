import 'orders.dart';

// product_data.dart
class Product {
  final int id;
  String name;
  double quantity;
  String image; //default image
  double unitPrice;
  String description;
  double remainingQuantity;
  double minThreshold;
  double unitCost;
  double unitsBought;
  String supplierName;
  String supplierPhone;
  String supplierAddress;

  Product({
    required this.id,
    required this.name,
    required this.quantity,
    required this.unitPrice,
    required this.description,
    required this.remainingQuantity,
    required this.minThreshold,
    required this.unitCost,
    required this.unitsBought,
    required this.supplierName,
    required this.supplierPhone,
    required this.supplierAddress,
    this.image = 'assets/cookies.png', //default image
  });
}

final List<Product> products = [
  Product(
    id: 1,
    name: 'Cookies',
    quantity: 1.0,
    image: "assets/cookies.png",
    unitPrice: 10.0,
    description: "Delicious cookies23",
    remainingQuantity: 1.0,
    minThreshold: 0.5,
    unitCost: 5.0,
    unitsBought: 10.0,
    supplierName: "Supplier1",
    supplierPhone: "123456789",
    supplierAddress: "Algeria",
  ),
  Product(
    id: 2,
    name: 'Cookies2',
    quantity: 13.0,
    image: "assets/cookies.png",
    unitPrice: 20.0,
    description: "Delicious cookies34",
    remainingQuantity: 13.0,
    minThreshold: 0.5,
    unitCost: 5.0,
    unitsBought: 10.0,
    supplierName: "Supplier2",
    supplierPhone: "123456789",
    supplierAddress: "Algeria",
  ),
  Product(
    id: 3,
    name: 'flower',
    quantity: 0.5,
    image: "assets/flower.jpg",
    unitPrice: 30.0,
    description: "Delicious cookies",
    remainingQuantity: 0.5,
    minThreshold: 0.5,
    unitCost: 5.0,
    unitsBought: 10.0,
    supplierName: "Supplier3",
    supplierPhone: "123456789",
    supplierAddress: "Algeria",
  ),
  Product(
    id: 4,
    name: 'Cookies4',
    quantity: 23.0,
    image: "assets/cookies.png",
    unitPrice: 40.0,
    description: "Delicious cookies",
    remainingQuantity: 23.0,
    minThreshold: 0.5,
    unitCost: 5.0,
    unitsBought: 10.0,
    supplierName: "Supplier4",
    supplierPhone: "123456789",
    supplierAddress: "Algeria",
  ),
  Product(
    id: 5,
    name: 'Cookies5',
    quantity: 0.2,
    image: "assets/cookies.png",
    unitPrice: 50.0,
    description: "Delicious cookies",
    remainingQuantity: 0.2,
    minThreshold: 0.5,
    unitCost: 5.0,
    unitsBought: 10.0,
    supplierName: "Supplier5",
    supplierPhone: "123456789",
    supplierAddress: "Algeria",
  ),
];

// Function to get a product by ID
Product getProductById(int id) {
  return products.firstWhere((product) => product.id == id,
      orElse: () => throw StateError('Product not found'));
}

// Function to delete a product by ID
void deleteProductById(int id) {
  Product? productToDelete = products.firstWhere((product) => product.id == id);
  // Remove the product from all orders
  for (var order in ordersCenter) {
    order.removeProduct(productToDelete);
  }
  // Remove the product from the products list
  products.removeWhere((product) => product.id == id);
}
