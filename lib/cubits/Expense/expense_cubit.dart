import 'package:flutter_bloc/flutter_bloc.dart';
import 'expense_state.dart';
import 'expense_repository.dart';
import 'package:business_assistant/models/expense.dart';

class ExpenseCubit extends Cubit<ExpenseState> {
  final ExpenseRepository repository;

  ExpenseCubit({required this.repository}) : super(ExpenseInitial());

  Future<void> loadExpenses() async {
    try {
      emit(ExpenseLoading());
      final expenses = await repository.getExpenses();
      print('Expenses loaded: ${expenses.length}'); // Debugging line
      emit(ExpenseLoaded(expenses: expenses));
    } catch (e) {
      print('Error loading expenses: $e'); // Debugging line
      emit(ExpenseError(e.toString()));
    }
  }

  Future<void> addExpense(Expense expense) async {
    try {
      await repository.insertExpense(expense);
      await loadExpenses();  // Refresh the list after adding
    } catch (e) {
      emit(ExpenseError(e.toString()));
    }
  }
  
  Future<void> loadExpensesGroupedByDate() async {
    try {
      emit(ExpenseLoading());
      final expenses = await repository.getExpensesGroupedByDate();
      print('Expenses grouped by date: $expenses'); // Debugging line
      emit(ExpenseGroupedByDateLoaded(expenses: expenses));
    } catch (e) {
      print('Error loading expenses: $e'); // Debugging line
      emit(ExpenseError(e.toString()));
    }
  }
}