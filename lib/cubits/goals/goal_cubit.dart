import 'package:bloc/bloc.dart';
import 'goal_repository.dart';
import 'goal_state.dart';
import 'package:business_assistant/data/goaldata.dart';

class GoalCubit extends Cubit<GoalState> {
  final GoalRepository _goalRepository;

  GoalCubit(this._goalRepository) : super(GoalInitial());

  void fetchGoals() async {
    emit(GoalLoading());
    try {
      final goals = await _goalRepository.fetchGoals();
      print('Goals fetched successfully: $goals');
      emit(GoalLoaded(goals));
    } catch (e) {
      emit(GoalError('Failed to fetch goals: ${e.toString()}'));
    }
  }

  void addGoal(Goal goal) async {
    try {
      await _goalRepository.addGoal(goal);
      fetchGoals(); // Refresh the goal list after adding
    } catch (e) {
      emit(GoalError('Failed to add goal: ${e.toString()}'));
    }
  }

  void updateGoal(Goal goal) async {
    try {
      await _goalRepository.updateGoal(goal);
      fetchGoals(); // Refresh the goal list after updating
    } catch (e) {
      emit(GoalError('Failed to update goal: ${e.toString()}'));
    }
  }

  void deleteGoal(int goalId) async {
    try {
      await _goalRepository.deleteGoal(goalId);
      fetchGoals(); // Refresh the goal list after deleting
    } catch (e) {
      emit(GoalError('Failed to delete goal: ${e.toString()}'));
    }
  }
}
