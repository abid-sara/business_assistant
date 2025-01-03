import 'package:business_assistant/data/Task.dart';
import 'package:business_assistant/database/task_db.dart';

class TaskRepository {
  final TaskDB _taskDB = TaskDB.instance;

  Future<List<Task>> fetchTasks() async {
    return await _taskDB.fetchTasks();
  }

  Future<void> addTask(Task task) async {
    await _taskDB.insertTask(task);
  }

  Future<void> updateTask(Task task) async {
    await _taskDB.updateTask(task);
  }

  Future<void> deleteTask(int taskId) async {
    await _taskDB.deleteTask(taskId);
  }
}
