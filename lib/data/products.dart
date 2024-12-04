import 'orders.dart';

// product_data.dart
class Product {
  final int id;
  String name;
  double quantity;
  String image;
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
    name: 'NoteBook',
    quantity: 100.0,
    image: "assets/images/notebookBlack.jpeg",
    unitPrice: 1000.0,
    description: "Delicious cookies23",
    remainingQuantity: 1.0,
    minThreshold: 10,
    unitCost: 800.0,
    unitsBought: 10.0,
    supplierName: "Supplier1",
    supplierPhone: "123456789",
    supplierAddress: "Algeria",
  ),
  Product(
    id: 2,
    name: 'Sticky Notes',
    quantity: 100.0,
    image: "assets/images/stickyNotes.jpg",
    unitPrice: 200.0,
    description: "100 note page",
    remainingQuantity: 80.0,
    minThreshold: 10, //maybe we add that the user enters
    unitCost: 100.0,
    unitsBought: 10.0,
    supplierName: "Supplier2",
    supplierPhone: "06748392",
    supplierAddress: "Algiers",
  ),
  Product(
    id: 3,
    name: 'Pink Book',
    quantity: 100,
    image: "assets/images/pinkBook.jpeg",
    unitPrice: 900.0,
    description: "Special flowers ",
    remainingQuantity: 4,
    minThreshold: 5,
    unitCost: 400.0,
    unitsBought: 150.0,
    supplierName: "Supplier3",
    supplierPhone: "123456789",
    supplierAddress: "Algeria",
  ),
  Product(
    id: 4,
    name: 'Stickers sheet',
    quantity: 100,
    image: "assets/images/stickersSheet.jpg",
    unitPrice: 300.0,
    description: "Delicious cookies",
    remainingQuantity: 23.0,
    minThreshold: 30,
    unitCost: 150.0,
    unitsBought: 150.0,
    supplierName: "Supplier4",
    supplierPhone: "067283927",
    supplierAddress: "Algeria",
  ),
  Product(
    id: 5,
    name: 'Pink pen',
    quantity: 5,
    image: "assets/images/pinkPens.jpeg",
    unitPrice: 50,
    description: "Delicious cookies",
    remainingQuantity: 50,
    minThreshold: 20,
    unitCost: 20,
    unitsBought: 300,
    supplierName: "Supplier5",
    supplierPhone: "055673829",
    supplierAddress: "Algiers",
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



//For the min threshold the owner of the project will decide when it is low stock (he knows )