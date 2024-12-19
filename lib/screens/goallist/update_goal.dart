import 'package:business_assistant/database/goal_db.dart';
import 'package:business_assistant/screens/goallist/description.dart';
import 'package:business_assistant/widget/button.dart';
import 'package:flutter/material.dart';
import '../../style/colors.dart';
import '../../data/goaldata.dart';
import 'package:intl/intl.dart';
import 'package:business_assistant/widget/back_arrow.dart';
import '../../database/goal_db.dart'; // Import GoalDB for database operations

class UpdateGoalPage extends StatefulWidget {
  final Goal goal; // Existing goal to be updated
  final Function(Goal) onUpdate; // Callback function for updating goal

  const UpdateGoalPage({super.key, required this.goal, required this.onUpdate});

  @override
  _UpdateGoalPageState createState() => _UpdateGoalPageState();
}


class _UpdateGoalPageState extends State<UpdateGoalPage> {
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _limitDateController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _status = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  late String? _titleError;
  late String? _startDateError;
  late String? _limitDateError;

  @override
  void initState() {
    super.initState();

    // Initialize the controllers with existing goal data
    _titleController.text = widget.goal.title;
    _startDateController.text =
        DateFormat('dd/MM/yyyy').format(widget.goal.startDate);
    _limitDateController.text =
        DateFormat('dd/MM/yyyy').format(widget.goal.limitDate);
    _descriptionController.text = widget.goal.description;
    _status.text = widget.goal.status;

    _titleError = null;
    _startDateError = null;
    _limitDateError = null;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _startDateController.dispose();
    _limitDateController.dispose();
    _descriptionController.dispose();
    _status.dispose();
    super.dispose();
  }

  // Method to validate and update goal
  Goal _prepareUpdatedGoal() {
    DateTime startDate =
        DateFormat('dd/MM/yyyy').parse(_startDateController.text);
    DateTime limitDate =
        DateFormat('dd/MM/yyyy').parse(_limitDateController.text);

    return Goal(
      id: widget.goal.id, // Retain the existing goal ID
      title: _titleController.text,
      status: _status.text.isNotEmpty ? _status.text : 'In Progress',
      startDate: startDate,
      limitDate: limitDate,
      description: _descriptionController.text,
    );
  }

  bool _validateForm() {
    setState(() {
      _titleError = null;
      _startDateError = null;
      _limitDateError = null;
    });

    if (_titleController.text.isEmpty) {
      setState(() {
        _titleError = 'Please enter a title';
      });
      return false;
    }
    if (_startDateController.text.isEmpty) {
      setState(() {
        _startDateError = 'Please enter a start date';
      });
      return false;
    }
    if (_limitDateController.text.isEmpty) {
      setState(() {
        _limitDateError = 'Please enter a limit date';
      });
      return false;
    }
    if (DateFormat('dd/MM/yyyy')
        .parse(_startDateController.text)
        .isBefore(DateTime.now())) {
      setState(() {
        _startDateError = 'Start date cannot be in the past';
      });
      return false;
    }
    if (DateFormat('dd/MM/yyyy')
        .parse(_limitDateController.text)
        .isBefore(DateTime.now())) {
      setState(() {
        _limitDateError = 'Limit date cannot be in the past';
      });
      return false;
    }
    if (DateFormat('dd/MM/yyyy')
        .parse(_startDateController.text)
        .isAfter(DateFormat('dd/MM/yyyy').parse(_limitDateController.text))) {
      setState(() {
        _limitDateError = 'Start date cannot be after limit date';
      });
      return false;
    }
    return true;
  }

  Future<void> _updateGoalInDatabase() async {
  if (!_validateForm()) return;

  try {
    Goal updatedGoal = _prepareUpdatedGoal();
    await GoalDB.instance.updateGoal(updatedGoal); // Update goal in the database

    // Call the onUpdate callback with the updated goal
    widget.onUpdate(updatedGoal);

    Navigator.pop(context, updatedGoal); // Return the updated goal to the previous screen
  } catch (error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to update goal: $error')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackArrow(
        onPressed: () {
          Navigator.pop(context);
        },
        title: 'Update Goal',
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                decoration: BoxDecoration(
                  color: AppColors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Title Field
                    DataField(
                      text: 'Title',
                      description: 'Enter the title',
                      controller: _titleController,
                    ),
                    if (_titleError != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          _titleError!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    // Description Field
                    DataField(
                      text: 'Description',
                      description: 'Enter the description',
                      isDescription: true,
                      controller: _descriptionController,
                    ),
                    // Start Date and Limit Date Fields
                    Row(
                      children: [
                        Flexible(
                          child: Column(
                            children: [
                              DataField(
                                text: 'Start date',
                                description: 'DD/MM/YYYY',
                                controller: _startDateController,
                                isDate: true,
                              ),
                              if (_startDateError != null)
                                Text(
                                  _startDateError!,
                                  style: const TextStyle(color: Colors.red),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Flexible(
                          child: Column(
                            children: [
                              DataField(
                                text: 'Limit date',
                                description: 'DD/MM/YYYY',
                                controller: _limitDateController,
                                isDate: true,
                              ),
                              if (_limitDateError != null)
                                Text(
                                  _limitDateError!,
                                  style: const TextStyle(color: Colors.red),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateGoalInDatabase,
                style: button,
                child: const Text(
                  'Update Goal',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
