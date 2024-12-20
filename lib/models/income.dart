// import 'order.dart';

// class Income {
//   final int id;
//   final DateTime date;
//   final double amount;
//   final int orderId;
//   final Order order;

//   Income({
//     required this.id,
//     required this.date,
//     required this.amount,
//     required this.orderId,
//     required this.order,
//   });

//   // Factory constructor to create an Income from a Map
//   factory Income.fromMap(Map<String, dynamic> map) {
//     // Create an Order object from the map
//     Order order = Order.fromMap(map['order']) as Order;

//     return Income(
//       id: map['id'],
//       date: DateTime.parse(map['date']),
//       amount: map['amount'],
//       orderId: map['order_id'],
//       order: order,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'date': date.toIso8601String(),
//       'amount': amount,
//       'order_id': orderId,
//     };
//   }
// }