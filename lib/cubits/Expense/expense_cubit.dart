import 'package:flutter_bloc/flutter_bloc.dart';
import 'expense_state.dart';  // Make sure to create this file if not already present
import 'expense_repository.dart';  // Make sure to create this file if not already present
import 'package:business_assistant/models/expense.dart';

class ExpenseCubit extends Cubit<ExpenseState> {
  final ExpenseRepository repository;

  ExpenseCubit({required this.repository}) : super(ExpenseInitial());

  Future<void> loadExpenses() async {
  try {
    emit(ExpenseLoading());
    final expenses = await repository.getExpenses();
    print('Expenses loaded: ${expenses.length}'); // Debugging line
    emit(ExpenseLoaded(expenses.cast<Map<String, dynamic>>(), expenses: []));
  } catch (e) {
    print('Error loading expenses: $e'); // Debugging line
    emit(ExpenseError(e.toString()));
  }
}


  Future<void> addExpense(Expense expense) async {
    try {
      emit(ExpenseLoading());
      await repository.insertExpense(expense);
      await loadExpenses();  // Refresh the list after adding
    } catch (e) {
      emit(ExpenseError(e.toString()));
    }
  }
}