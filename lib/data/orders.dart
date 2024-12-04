import 'customers.dart';
import 'products.dart';

//things to consider, in each time someone makes an order, the quantity bought must be removed from the current stock level automatically
class Order {
  Map<Product, int> products; // Map of products and their quantities
  Customer customer; //customer that ordered
  double totalPrice; //total price of the order
  double deliveryPrice;
  bool delivered = false; //default not delivered
  String deliveryDate;
  String deliveryAddress;
  String orderCode;
  String orderDate;

  Order({
    required this.orderCode,
    required this.products,
    required this.customer,
    required this.totalPrice,
    required this.deliveryPrice,
    required this.deliveryDate,
    required this.deliveryAddress,
    required this.orderDate,
  });

  double getTotalPrice() {
    double total = 0;
    products.forEach((product, quantity) {
      total += product.unitPrice * quantity;
    });
    return total;
  }

  double getTotalWithDelivery() {
    double total = getTotalPrice();
    total += deliveryPrice;
    return total;
  }

  bool setDelivered(bool setTo) {
    delivered = setTo;
    return delivered;
  }

  void removeProduct(Product product) {
    products.remove(product);
    totalPrice = getTotalPrice();
  }
}

bool deleteOrder(Order orderToDelete) {
  ordersCenter
      .removeWhere((order) => orderToDelete.orderCode == order.orderCode);
  return true;
}

// List of orders
List<Order> ordersCenter = [
  Order(
    orderCode: "YUOP09",
    products: {
      products[0]: 3, // the product itself and the quantity
      products[1]: 4,
    },
    customer: customers[0],
    totalPrice: products[0].unitPrice * 3 + 4 * products[1].unitPrice,
    deliveryPrice: 500.0,
    deliveryDate: '23-04-2024',
    deliveryAddress: customers[0].address,
    orderDate: "23-04-2024",
  ),
  Order(
    orderCode: "JKLOY78",
    products: {
      products[2]: 3,
      products[3]: 1,
    },
    customer: customers[1],
    totalPrice: products[2].unitPrice * 3 + products[3].unitPrice,
    deliveryPrice: 700.0,
    deliveryDate: '24-04-2024',
    deliveryAddress: customers[1].address,
    orderDate: "23-04-2024",
  ),
  Order(
    orderCode: "GHDK98",
    products: {
      products[4]: 1,
    },
    customer: customers[0],
    totalPrice: products[4].unitPrice,
    deliveryPrice: 500.0,
    deliveryDate: '25-04-2024',
    deliveryAddress: customers[0].address,
    orderDate: "23-04-2024",
  ),
];
