import 'package:business_assistant/widget/back_arrow.dart';
import 'package:business_assistant/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:business_assistant/data/Task.dart';
import 'package:business_assistant/style/colors.dart';

class AddTaskPage extends StatefulWidget {
  final Function(Task) onAddTask;

  const AddTaskPage({Key? key, required this.onAddTask}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 10, minute: 0);
  String? _reminder = "15 Minutes";
  String _repeatFrequency = "None";

  @override
  void initState() {
    super.initState();
    // Debugging line to check if onAddTask is passed correctly
    print(widget.onAddTask);
  }

  // Time picker for Start and End Times
  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: isStartTime ? _startTime : _endTime,
    );
    if (pickedTime != null) {
      setState(() {
        if (isStartTime) {
          _startTime = pickedTime;
        } else {
          _endTime = pickedTime;
        }
      });
    }
  }

  void _addTask() {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title cannot be empty!')),
      );
      return;
    }

    // Ensure start time is before end time
    if (_startTime.hour > _endTime.hour ||
        (_startTime.hour == _endTime.hour && _startTime.minute >= _endTime.minute)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Start time must be before end time!')),
      );
      return;
    }

    final task = Task(
      title: _titleController.text,
      date: DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
      ),
      status: "In progress",
      description: _descriptionController.text,
      reminder: _reminder,
      repeatFrequency: _repeatFrequency,
    );

    widget.onAddTask(task); // Send the task back to parent widget
    Navigator.pop(context); // Navigate back
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  BackArrow(title: 'Add task'),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             
              // Calendar Section
              SafeArea(
                child: TableCalendar(
                  focusedDay: _selectedDate,
                  firstDay: DateTime(2000),
                  lastDay: DateTime(2100),
                  selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
                  onDaySelected: (selectedDay, _) {
                    setState(() {
                      _selectedDate = selectedDay;
                    });
                  },
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: AppColors.green.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: const BoxDecoration(
                      color: AppColors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Title Input
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: "Title",
                  border: UnderlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              // Grid Section
              GridView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 2,
                ),
                children: [
                  // Start Time
                  GestureDetector(
                    onTap: () => _selectTime(context, true),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppColors.yellowGreen,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Start Time",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _startTime.format(context),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // End Time
                  GestureDetector(
                    onTap: () => _selectTime(context, false),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppColors.yellowGreen,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "End Time",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _endTime.format(context),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Repeat Task
                  DropdownButtonFormField<String>(
                    value: _repeatFrequency,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(16),
                      filled: true,
                      fillColor: AppColors.yellowGreen,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      labelText: "Repeat Task",
                    ),
                    items: ["None", "Daily", "Weekly", "Monthly"]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _repeatFrequency = value ?? "None";
                      });
                    },
                  ),
                  // Reminder
                  DropdownButtonFormField<String>(
                    value: _reminder,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(16),
                      filled: true,
                      fillColor: AppColors.yellowGreen,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      labelText: "Reminder",
                    ),
                    items: ["15 Minutes", "30 Minutes", "1 Hour", "None"]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _reminder = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Description Input
              TextField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              // Done Button
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: _addTask,
                  style: button,
                  child: const Text('Done', style: TextStyle(color: Colors.white, fontSize: 20),) ,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
