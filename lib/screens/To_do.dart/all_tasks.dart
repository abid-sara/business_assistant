import 'package:business_assistant/data/Task.dart';
import 'package:business_assistant/database/task_db.dart';
import 'package:business_assistant/screens/To_do.dart/update.dart';
import 'package:business_assistant/widget/sidebar.dart';
import 'add_task.dart';
import 'package:business_assistant/widget/button.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:business_assistant/widget/customindicator.dart';
import 'package:business_assistant/style/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:business_assistant/cubits/tasks/task_cubit.dart';
import 'package:business_assistant/cubits/tasks/task_state.dart';

class Tasks extends StatefulWidget {
  const Tasks({super.key});

  @override
  _TasksState createState() => _TasksState();
}

class _TasksState extends State<Tasks> with SingleTickerProviderStateMixin {
  DateTime _selectedDate = DateTime.now();
  late TabController _tabController;  // Define the TabController

  List<Task> _tasks = []; // List to hold tasks fetched from the database

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this); // Initialize the TabController
    _loadTasks();
  }

  // Fetch tasks from the database
  void _loadTasks() async {
    final tasks = await TaskDB.instance.fetchTasks();
    setState(() {
      _tasks = tasks;
    });
  }

  // Filter tasks for the selected date
  List<Task> _getTasksForSelectedDate({String? filterStatus}) {
    final tasksForSelectedDate = _tasks.where((task) {
      return task.date.year == _selectedDate.year &&
          task.date.month == _selectedDate.month &&
          task.date.day == _selectedDate.day;
    }).toList();

    if (filterStatus == null) {
      return tasksForSelectedDate;
    }

    return tasksForSelectedDate.where((task) => task.status == filterStatus).toList();
  }

 void _updateTaskInParent(Task updatedTask) {
  setState(() {
    // Update the task in the list by replacing the old one with the updated task
    _tasks = _tasks.map((task) {
      return task.id == updatedTask.id ? updatedTask : task;
    }).toList();
  });
}

 // Delete a task from the UI (task stays in the database)
void _deleteTask(Task task) async {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task from the UI?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                task.deleted = true; 
                _tasks.remove(task); 
              });

              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      );
    },
  );
}


  // Mark a task as completed
  void _markTaskAsCompleted(Task task) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Mark as Completed'),
          content: const Text('Are you sure you want to mark this task as completed?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  task.status = "Completed";
                });
                _updateTaskInParent(task); // Update task status in database
                Navigator.of(context).pop();
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTaskList({String? filterStatus}) {
  return BlocBuilder<TaskCubit, TaskState>(
    builder: (context, state) {
      if (state is TaskLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (state is TaskLoaded) {
        // Filter tasks based on the selected date and optional filter status
        final filteredTasks = state.tasks.where((task) {
          final isOnSelectedDate = task.date.year == _selectedDate.year &&
              task.date.month == _selectedDate.month &&
              task.date.day == _selectedDate.day;
          final matchesFilter = filterStatus == null || task.status == filterStatus;
          return isOnSelectedDate && matchesFilter;
        }).toList();

        // If no tasks match, show a placeholder message
        if (filteredTasks.isEmpty) {
          return const Center(
            child: Text('No tasks found for the selected criteria.'),
          );
        }

        // Build the list of tasks
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          itemCount: filteredTasks.length,
          itemBuilder: (context, index) {
            final task = filteredTasks[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: task.status == "Completed"
                    ? Colors.green[50]
                    : task.status == "Missed"
                        ? Colors.red[50]
                        : Colors.orange[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => context.read<TaskCubit>().updateTask(
                          task..status = "Completed",
                        ),
                    child: CircleAvatar(
                      backgroundColor: task.status == "Completed"
                          ? Colors.green
                          : task.status == "Missed"
                              ? Colors.red
                              : Colors.orange,
                      child: Icon(
                        task.status == "Completed"
                            ? Icons.check
                            : task.status == "Missed"
                                ? Icons.error_outline
                                : Icons.hourglass_top,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: task.status == "Missed" ? Colors.red : Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          task.description.isNotEmpty
                              ? task.description
                              : "No description provided",
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(
                              "${DateFormat('h:mm a').format(task.startTime)} - ${DateFormat('h:mm a').format(task.endTime)}",
                              style: const TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RescheduleTaskPage(
                                  task: task,
                                onUpdateTask: (updatedTask) {
                                  context.read<TaskCubit>().updateTask(updatedTask); // Update task using Cubit
                                },
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            'Reschedule',
                            style: TextStyle(color: AppColors.green, fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => context.read<TaskCubit>().deleteTask(task.id!),
                  ),
                ],
              ),
            );
          },
        );
      } else if (state is TaskError) {
        return Center(
          child: Text(state.message),
        );
      }
      return const Center(
        child: Text('Unexpected state encountered.'),
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Sidebar(),
      appBar: AppBar(
        title: const Text('Tasks', style: TextStyle(color: AppColors.darkGreen)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildDateHeader(),
          _buildDatePicker(),

          const SizedBox(height: 20),
          Expanded(
            child: Column(
              children: [
                _buildTabBar(),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildTaskList(),
                      _buildTaskList(filterStatus: "In progress"),
                      _buildTaskList(filterStatus: "Completed"),
                      _buildTaskList(filterStatus: "Missed"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTaskPage(
                 onAddTask: (newTask) {
                context.read<TaskCubit>().addTask(newTask); // Use TaskCubit to add the task
              },
              ),
            ),
          );
        },
        style: button,
        child: const Text('Add task', style: TextStyle(color: Colors.white),),
      ),
    );
  }

  Widget _buildDateHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            DateFormat.yMMMMd().format(DateTime.now()),
            style: const TextStyle(
              color: AppColors.green,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
            IconButton(
            icon: const Icon(Icons.calendar_today),
                        onPressed: () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          ).then((pickedDate) {
                            setState(() {
                              if (pickedDate != null) {
                                final formattedDate =
                                    DateFormat('MMMM yyyy').format(pickedDate);
                                _selectedDate = formattedDate as DateTime;
                            
                              }
                            });
                          });
                        },
                      ),
        ],
      ),
    );
  }

  Widget _buildDatePicker() {
    return DatePicker(
      DateTime.now(),
      height: 100,
      width: 60,
      initialSelectedDate: DateTime.now(),
      selectionColor: AppColors.darkGreen,
      selectedTextColor: Colors.white,
      onDateChange: (date) {
        setState(() {
          _selectedDate = date;
        });
      },
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15.0),
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: const CustomTabIndicator(
          color: AppColors.darkGreen,
          radius: 25.0, horizontalPadding: 2,
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey,
        tabs: const [
          Tab(text: "All tasks"),
          Tab(text: "In progress"),
          Tab(text: "Completed"),
          Tab(text: "Missed"),
        ],
      ),
    );
  }
}
