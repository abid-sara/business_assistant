import 'package:flutter_bloc/flutter_bloc.dart';
import 'task_state.dart';
import 'task_repository.dart';
import 'package:business_assistant/data/Task.dart';

class TaskCubit extends Cubit<TaskState> {
  final TaskRepository _repository;

  TaskCubit(this._repository) : super(TaskInitial());

  void fetchTasks() async {
  emit(TaskLoading());
  try {
    final tasks = await _repository.fetchTasks();
    emit(TaskLoaded(tasks));
  } catch (e) {
    emit(TaskError('Failed to fetch tasks: ${e.toString()}'));
  }
}


  void addTask(Task task) async {
    try {
      await _repository.addTask(task);
      fetchTasks(); // Refresh the task list
    } catch (e) {
      emit(TaskError('Failed to add task'));
    }
  }

  void updateTask(Task task) async {
    try {
      await _repository.updateTask(task);
      fetchTasks(); // Refresh the task list
    } catch (e) {
      emit(TaskError('Failed to update task'));
    }
  }

  void deleteTask(int taskId) async {
    try {
      await _repository.deleteTask(taskId);
      fetchTasks(); // Refresh the task list
    } catch (e) {
      emit(TaskError('Failed to delete task'));
    }
  }
}
