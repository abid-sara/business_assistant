import 'package:business_assistant/data/goaldata.dart';
import 'package:business_assistant/database/goal_db.dart';

class GoalRepository {
  final GoalDB _goalDB = GoalDB.instance;

  Future<List<Goal>> fetchGoals() async {
    return await _goalDB.fetchGoals();
  }

  Future<void> addGoal(Goal goal) async {
    await _goalDB.insertGoal(goal);
  }

  Future<void> updateGoal(Goal goal) async {
    await _goalDB.updateGoal(goal);
  }

  Future<void> deleteGoal(int goalId) async {
    await _goalDB.deleteGoal(goalId);
  }
}
