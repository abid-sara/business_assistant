import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:business_assistant/data/Task.dart';
import 'package:business_assistant/style/colors.dart';
import 'package:business_assistant/widget/back_arrow.dart';
import 'package:business_assistant/widget/button.dart';

class RescheduleTaskPage extends StatefulWidget {
  final Task task;
  final Function(Task) onUpdateTask;

  const RescheduleTaskPage({
    super.key,
    required this.task,
    required this.onUpdateTask,
  });

  @override
  _RescheduleTaskPageState createState() => _RescheduleTaskPageState();
}

class _RescheduleTaskPageState extends State<RescheduleTaskPage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime _selectedDate;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  String? _reminder;
  String _repeatFrequency = "None";

  @override
  void initState() {
    super.initState();
    // Initialize with the task data
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(text: widget.task.description);
    _selectedDate = widget.task.date;
    _startTime = TimeOfDay.fromDateTime(widget.task.date);
    _endTime = TimeOfDay.fromDateTime(widget.task.date);
    _reminder = widget.task.reminder ?? "15 Minutes";
    _repeatFrequency = widget.task.repeatFrequency ?? "None";
  }

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

  void rescheduleTask() {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title cannot be empty!')),
      );
      return;
    }

    final updatedTask = Task(
      title: _titleController.text,
      description: _descriptionController.text,
      date: DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _startTime.hour,
        _startTime.minute,
      ),
      reminder: _reminder,
      repeatFrequency: _repeatFrequency,
      status: "In progress",
    );

    widget.onUpdateTask(updatedTask); // Pass updated task back to parent
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackArrow(title: 'Reschedule Task'),
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
                          const SizedBox(height: 3),
                          Flexible(
                             child: Text(
                              _startTime.format(context),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
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
                          const SizedBox(height: 3),
                          Flexible(
                            child: Text(
                              _endTime.format(context),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
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
                  onPressed: rescheduleTask,
                  style: button,
                  child: const Text('Done', style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
