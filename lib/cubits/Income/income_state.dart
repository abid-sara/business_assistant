import 'package:business_assistant/models/income.dart';

abstract class IncomeState {}

class IncomeInitial extends IncomeState {}

class IncomeLoading extends IncomeState {}

class IncomeLoaded extends IncomeState {
  final List<Income> incomeList;

  IncomeLoaded({required this.incomeList});
}

class IncomeInsertFailure extends IncomeState {
  final String error;

  IncomeInsertFailure({required this.error});
}

class IncomeInsertedSuccess extends IncomeState {}

class IncomeLoadFailure extends IncomeState {
  final String error;

  IncomeLoadFailure({required this.error});
}

class IncomeEmpty extends IncomeState {}
