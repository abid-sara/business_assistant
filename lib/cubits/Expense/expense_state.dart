import 'package:business_assistant/models/expense.dart';

abstract class ExpenseState {}

class ExpenseInitial extends ExpenseState {}

class ExpenseLoading extends ExpenseState {}

class ExpenseLoaded extends ExpenseState {
  final List<Expense> expenses;

  ExpenseLoaded(List<Map<String, dynamic>> expensesData, {required this.expenses});
}

class ExpenseError extends ExpenseState {
  final String error;

  ExpenseError(this.error);
}
