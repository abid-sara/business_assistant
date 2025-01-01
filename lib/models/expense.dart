class Expense {
  final int? id;
  final DateTime date;
  final double amount;
  final bool deleted; 

  Expense({
    this.id,
    required this.date,
    required this.amount,
    this.deleted = false,
  });

  factory Expense.fromMap(Map<String, dynamic> map) {
    try {
      return Expense(
        id: map['id'] as int?,
        amount: map['amount'] as double,
        date: DateTime.parse(map['date'] as String),
        deleted: map['deleted'] == 1,
      );
    } catch (e) {
      print('Error parsing Expense: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'amount': amount,
      'deleted': deleted ? 1 : 0,
    };
  }
}
