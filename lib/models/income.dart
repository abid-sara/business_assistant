import 'order.dart';

class Income {
  final int id;
  final DateTime date;
  final double amount;
  final int orderId;
  final Order order;
  final int deleted;  // Change `bool` to `int`

  Income({
    required this.id,
    required this.date,
    required this.amount,
    required this.orderId,
    required this.order,
    this.deleted = 0,  // Default to 0 (false)
  });

  // Factory constructor to create an Income from a Map
  factory Income.fromMap(Map<String, dynamic> map) {
    // Parse order date into DateTime
    DateTime orderDate = DateTime.parse(map['order']['date']);  // Assuming 'date' is a string

    // Create an Order object with the parsed date
    Order order = Order.fromMap(map['order'], map['order']['customer']);
    
    return Income(
      id: map['id'],
      date: DateTime.parse(map['date']),  // Parse income date here
      amount: map['amount'],
      orderId: map['order_id'],
      order: order,
      deleted: map['deleted'] ?? 0,  // Ensure deleted is an int (0 or 1)
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'amount': amount,
      'order_id': orderId,
      'deleted': deleted,  // `deleted` is now an int (0 or 1)
    };
  }
}
