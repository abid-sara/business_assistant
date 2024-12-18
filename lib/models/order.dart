import 'package:business_assistant/models/customer.dart';

class Order {
  final int id;
  final double totalPrice;
  final Customer customer;
  final double deliveryPrice;
  final String deliveryDate;
  final String deliveryAddress;
  final String orderDate;
  final String status; // 'pending' or 'delivered'
  final int deleted;

  Order({
    required this.id,
    required this.totalPrice,
    required this.customer,
    required this.deliveryPrice,
    required this.deliveryDate,
    required this.deliveryAddress,
    required this.orderDate,
    this.status = 'pending',
    this.deleted = 0,
  });

  // Factory constructor to create an Order from a Map
  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
        id: map['id'],
        totalPrice: (map['price'] ?? 0.0).toDouble(),
        customer: map['customer_id'],
        deliveryPrice: (map['delivery_price'] ?? 0.0).toDouble(),
        deliveryDate: map['delivery_date'] ?? '',
        deliveryAddress: map['delivery_address'] ?? '',
        orderDate: map['order_date'] ?? '',
        status: map['status'] ?? 'pending',
        deleted: map['deleted']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'price': totalPrice,
      'status': status,
      'deleted': deleted,
      'order_date': orderDate,
      'delivery_date': deliveryDate,
      'delivery_address': deliveryAddress,
      'delivery_price': deliveryPrice,
      'customer_id': customer.id,
    };
  }
}
