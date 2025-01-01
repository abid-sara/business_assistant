import 'package:business_assistant/cubits/Income/income_repository.dart';
import 'package:business_assistant/cubits/Income/income_state.dart';
import 'package:business_assistant/models/income.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IncomeCubit extends Cubit<IncomeState> {
  final IncomeRepository _incomeRepository;

  IncomeCubit(this._incomeRepository) : super(IncomeInitial());

  // Method to insert income data
  Future<void> insertIncome(Income income) async {
    try {
      emit(IncomeLoading());
      int? isInserted = await _incomeRepository.insertIncome(income);
      if (isInserted != null) {
        emit(IncomeInsertedSuccess());
      } else {
        emit(IncomeInsertFailure(error: 'Failed to insert income.'));
      }
    } catch (e) {
      emit(IncomeInsertFailure(error: e.toString()));
    }
  }

  // Method to fetch all income records
  Future<void> fetchIncome() async {
    try {
      emit(IncomeLoading());
      List<Income> incomeList = await _incomeRepository.getIncome();
      if (incomeList.isNotEmpty) {
        emit(IncomeLoaded(incomeList: incomeList));
      } else {
        emit(IncomeEmpty());
      }
    } catch (e) {
      emit(IncomeLoadFailure(error: e.toString()));
    }
  }
}
