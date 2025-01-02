import 'package:flutter_bloc/flutter_bloc.dart';
import 'income_state.dart';
import 'income_repository.dart';
import 'package:business_assistant/models/income.dart';
import 'package:business_assistant/cubits/Income/income_state.dart';

class IncomeCubit extends Cubit<IncomeState> {
  final IncomeRepository repository;

  IncomeCubit({required this.repository}) : super(IncomeInitial());

  Future<void> loadIncome() async {
    try {
      emit(IncomeLoading());
      final income = await repository.getIncome();
      print('Income loaded: ${income.length}'); // Debugging line
      emit(IncomeLoaded(incomeList: income));
    } catch (e) {
      print('Error loading income: $e'); // Debugging line
      emit(IncomeError(e.toString()));
    }
  }

  Future<void> addIncome(Income income) async {
    try {
      emit(IncomeLoading());
      await repository.insertIncome(income);
      await loadIncome();  // Refresh the list after adding
    } catch (e) {
      emit(IncomeError(e.toString()));
    }
  }
  Future<void> loadIncomeGroupedByDate() async {
    try {
      emit(IncomeLoading());
      final income = await repository.getIncomeGroupedByDate();
      print('Income grouped by date: $income'); // Debugging line
      emit(IncomeGroupedByDateLoaded(income: income));
    } catch (e) {
      print('Error loading income: $e'); // Debugging line
      emit(IncomeError(e.toString()));
    }
  }

}