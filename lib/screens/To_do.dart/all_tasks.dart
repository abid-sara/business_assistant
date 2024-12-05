import 'package:business_assistant/data/Task.dart';
import 'package:business_assistant/screens/To_do.dart/update.dart';
import 'package:business_assistant/widget/sidebar.dart';
import 'add_task.dart';
import 'package:business_assistant/widget/button.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:business_assistant/widget/customindicator.dart';
import 'package:business_assistant/style/colors.dart';
import 'update.dart';

class Tasks extends StatefulWidget {
  const Tasks({super.key});

  @override
  _TasksState createState() => _TasksState();
}

class _TasksState extends State<Tasks> with SingleTickerProviderStateMixin {
  DateTime _selectedDate = DateTime.now();
  TabController? _tabController;
   
  // Dummy Task List
  final List<Task> _tasks = [
    Task(title: "Meeting with client", date: DateTime.now(), status: "In progress", description: 'in the library'),
    Task(title: "Submit project report", date: DateTime.now(), status: "Completed", description: 'writing the report of the se project ..'),
    Task(title: "Design wireframes", date: DateTime.now().add(const Duration(hours: 2)), status: "Missed", description: ''),
    Task(title: "Plan sprint", date: DateTime.now().subtract(const Duration(days: 1)), status: "Completed", description: 'doing the tasks'),
    Task(title: "Update dashboard", date: DateTime.now(), status: "In progress", description: 'changing the appbar'),
  ];
  
final Map<String, WidgetBuilder> routes = {
  '/': (context) => Tasks(),
  '/addtask': (context) => AddTaskPage(
    onAddTask: (task) {
      // Here, we will eventually handle the task addition logic
    },
  ),
};
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }
  void addTask(Task task) {
  setState(() {
    _tasks.add(task);  // Adds the new task to the list
  });
  print("Task added: ${task.title}"); // Debugging
}

  List<Task> _getTasksForSelectedDate() {
    return _tasks.where((task) {
      return task.date.year == _selectedDate.year &&
          task.date.month == _selectedDate.month &&
          task.date.day == _selectedDate.day;
    }).toList();
  }

  void _markTaskAsCompleted(Task task) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Mark as Completed'),
          content: const Text('Are you sure you want to mark this task as completed?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  task.status = "Completed"; // Mark the task as completed
                });
                Navigator.of(context).pop();
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const  Sidebar(),
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Tasks',
          style: TextStyle(
            color: AppColors.darkGreen,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      body: Column(
        children: [
          // Row displaying date and calendar icon
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat.yMMMMd().format(DateTime.now()),
                  style: const TextStyle(
                    color: AppColors.green,
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Icon(Icons.calendar_today),
              ],
            ),
          ),

          // DatePicker widget
          Container(
            margin: const EdgeInsets.only(top: 15),
            child: DatePicker(
              DateTime.now(),
              height: 100,
              width: 60,
              initialSelectedDate: DateTime.now(),
              selectionColor: AppColors.darkGreen,
              selectedTextColor: Colors.white,
              dateTextStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
              onDateChange: (date) {
                setState(() {
                  _selectedDate = date;
                });
              },
            ),
          ),

          const SizedBox(height: 16),

          // Row for "Today . Wednesday" and "Reschedule"
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Today . ${DateFormat('EEEE').format(_selectedDate)}",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Tabs and their content
          Expanded(
            child: _tabController == null
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      // Tab Bar
                      Container(
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
                            radius: 25.0,
                            horizontalPadding: 16.0,
                          ),
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.grey,
                          labelStyle: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                          ),
                          tabs: const [
                            Tab(text: "All tasks"),
                            Tab(text: "In progress"),
                            Tab(text: "Completed"),
                            Tab(text: "Missed"),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Tab Bar Views
                      Expanded(
  child: TabBarView(
    controller: _tabController,
    children: [
      _buildTaskList(), // All tasks (no filter)
      _buildTaskList(filterStatus: "In progress"), // In progress tasks
      _buildTaskList(filterStatus: "Completed"), // Completed tasks
      _buildTaskList(filterStatus: "Missed"), // Missed tasks
    ],
  ),
)

                    ],
                  ),
          ),
        ],
      ),
    );
  }
Widget _buildTaskList({String? filterStatus}) {
  // Get tasks for the selected date
  final tasksForSelectedDate = _getTasksForSelectedDate();

  // Filter tasks based on status if filterStatus is provided
  final filteredTasks = filterStatus == null
      ? tasksForSelectedDate
      : tasksForSelectedDate.where((task) {
          // Directly compare the task's status with the filterStatus string
          return task.status == filterStatus;
        }).toList();

  return Stack(
    children: [
      // Task List
      filteredTasks.isEmpty
          ? const Center(
              child: Text(
                "No tasks for the selected date",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              itemCount: filteredTasks.length,
              itemBuilder: (context, index) {
                final task = filteredTasks[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: task.status == "Completed"
                        ? Colors.green[50]
                        : task.status == "Missed"
                            ? Colors.red[50]
                            : Colors.orange[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: task.status == "Missed"
                          ? Colors.red
                          : Colors.transparent,
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Status Indicator
                      GestureDetector(
                        onTap: () => _markTaskAsCompleted(task),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: task.status == "Completed"
                                ? Colors.green
                                : task.status == "Missed"
                                    ? Colors.red
                                    : Colors.orange,
                          ),
                          child: Icon(
                            task.status == "Completed"
                                ? Icons.check
                                : task.status == "Missed"
                                    ? Icons.error_outline
                                    : Icons.hourglass_top,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Task Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: task.status == "Missed"
                                    ? Colors.red
                                    : Colors.grey[800],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              task.description.isNotEmpty
                                  ? task.description
                                  : "No description provided",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  size: 16,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  DateFormat('h:mm a').format(task.date),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            TextButton(
                                    onPressed: (){Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RescheduleTaskPage(
                                      task: _tasks[index],  // Pass the specific task to edit
                                      onUpdateTask: (updatedTask) {
                                        // Handle updated task
                                        setState(() {
                                          // Update the task list with the updated task
                                          _tasks[index] = updatedTask;
                                        });
                                      },
                                    ),
                                  ),
                                );
                     }, child: Text('Reschedule' , style: TextStyle( color: AppColors.green, fontSize: 15),), 
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

      // Add Task Button
      Positioned(
        bottom: 16,
        right: 16,
       child: ElevatedButton(
             onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddTaskPage(
                            onAddTask: (newTask) {
                              setState(() {
                                _tasks.add(newTask);
                                print(_tasks); // Add the task to the list
                              });
                            },
                          ),
                        ),
                      );



                  },
              style: button,
              child: Text("Add Task",
              style: TextStyle( color: Colors.white , fontSize: 20),)
              ,
            ),

      ),
    ],
  );
}



  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }
}
