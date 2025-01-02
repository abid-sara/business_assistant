import 'package:business_assistant/models/expense.dart';

abstract class ExpenseState {
 
}

class ExpenseInitial extends ExpenseState {}

class ExpenseLoading extends ExpenseState {}

class ExpenseLoaded extends ExpenseState {
  final List<Expense> expenses;

  ExpenseLoaded({required this.expenses});
}

class ExpenseError extends ExpenseState {
  final String message;

  ExpenseError(this.message);
}
class ExpenseGroupedByDateLoaded extends ExpenseState {
  final Map<String, double> expenses;

  ExpenseGroupedByDateLoaded({required this.expenses});
}