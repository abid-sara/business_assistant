import 'order.dart';

class Income {
   int? id; // id can be null initially
  final Order order;
  final DateTime date;
  final double amount;
  final int deleted;

  Income({
    this.id,  // Optional, can be null
    required this.order,
    required this.date,
    required this.amount,
    required this.deleted,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'order_id': order.id,
      'date': date.toIso8601String(),
      'amount': amount,
      'deleted': deleted,
    };
  }

  factory Income.fromMap(Map<String, dynamic> map, Order order) {
    return Income(
      id: map['id'],
      order: order,
      date: DateTime.parse(map['date']),
      amount: map['amount'],
      deleted: map['deleted'] ?? 0,
    );
  }
}
