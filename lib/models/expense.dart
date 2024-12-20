class Expense {
  final int id;
  final DateTime date; 
  final double amount; 

  Expense({
    required this.id,
    required this.date,
    required this.amount,
  });

  // Factory constructor to create an Expense from a Map
  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      date: DateTime.now(), 
      amount: map['amount'],
    );
  }

  // Convert an Expense to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'amount': amount,
    };
  }
}