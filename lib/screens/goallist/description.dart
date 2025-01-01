import 'package:flutter/material.dart';
import 'package:business_assistant/widget/button.dart';
import 'package:business_assistant/widget/back_arrow.dart';
import 'package:business_assistant/style/colors.dart';
import 'package:business_assistant/data/goaldata.dart';
import 'package:business_assistant/database/goal_db.dart';
import 'package:intl/intl.dart';

class DataField extends StatelessWidget {
  final String text;
  final String description;
  final bool isDescription;
  final bool isDate;
  final TextEditingController controller;
  final String? errorMessage;

  const DataField({
    super.key,
    required this.text,
    required this.description,
    required this.controller,
    this.isDescription = false,
    this.isDate = false,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                style: const TextStyle(fontSize: 16),
                controller: controller,
                maxLines: isDescription ? 5 : 1,
                readOnly: isDate,
                onTap: isDate
                    ? () async {
                        DateTime? selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        controller.text =
                            DateFormat('dd/MM/yyyy').format(selectedDate!);
                                            }
                    : null,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.lightGreen,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  hintText: description,
                  hintStyle: const TextStyle(color: Colors.grey),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  errorText: errorMessage,
                ),
              ),
            ),
            if (isDate)
              IconButton(
                icon: const Icon(Icons.calendar_today, color: AppColors.purpule),
                onPressed: () async {
                  DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  controller.text =
                      DateFormat('dd/MM/yyyy').format(selectedDate!);
                                },
              ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class AddGoalPage extends StatefulWidget {
  const AddGoalPage({super.key});

  @override
  _AddGoalPageState createState() => _AddGoalPageState();
}

class _AddGoalPageState extends State<AddGoalPage> {
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _limitDateController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? _titleError;
  String? _startDateError;
  String? _limitDateError;

  void _validateAndSubmit() async {
    setState(() {
      _titleError = _titleController.text.isEmpty ? 'Title is required' : null;
      _startDateError = _startDateController.text.isEmpty
          ? 'Start date is required'
          : null;
      _limitDateError = _limitDateController.text.isEmpty
          ? 'Limit date is required'
          : null;

      if (_startDateController.text.isNotEmpty &&
          DateFormat('dd/MM/yyyy')
              .parse(_startDateController.text)
              .isBefore(DateTime.now())) {
        _startDateError = 'Start date cannot be in the past';
      }
      if (_limitDateController.text.isNotEmpty &&
          DateFormat('dd/MM/yyyy')
              .parse(_limitDateController.text)
              .isBefore(DateTime.now())) {
        _limitDateError = 'Limit date cannot be in the past';
      }
      if (_startDateController.text.isNotEmpty &&
          _limitDateController.text.isNotEmpty &&
          DateFormat('dd/MM/yyyy')
              .parse(_startDateController.text)
              .isAfter(DateFormat('dd/MM/yyyy')
                  .parse(_limitDateController.text))) {
        _limitDateError = 'Start date cannot be after limit date';
      }
    });

          if (_titleError == null &&
          _startDateError == null &&
          _limitDateError == null) {
        final newGoal = Goal(
          title: _titleController.text,
          description: _descriptionController.text,
          startDate: DateFormat('dd/MM/yyyy').parse(_startDateController.text),
          limitDate: DateFormat('dd/MM/yyyy').parse(_limitDateController.text),
          status: 'In Progress',
        );

        // Save the new goal to the database
        await GoalDB.instance.insertGoal(newGoal);

        // Return the new goal to the parent widget
        Navigator.pop(context, newGoal);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackArrow(
        onPressed: () => Navigator.pop(context),
        title: 'Add Goal',
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Goal Details Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.green.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Goal Details',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    const SizedBox(height: 16),
                    DataField(
                      text: 'Title',
                      description: 'Enter goal title',
                      controller: _titleController,
                      errorMessage: _titleError,
                    ),
                    DataField(
                      text: 'Description',
                      description: 'Enter goal description',
                      controller: _descriptionController,
                      isDescription: true,
                    ),
                    const SizedBox(height: 16),
                    DataField(
                      text: 'Start Date',
                      description: 'Select start date',
                      controller: _startDateController,
                      isDate: true,
                      errorMessage: _startDateError,
                    ),
                    DataField(
                      text: 'Limit Date',
                      description: 'Select limit date',
                      controller: _limitDateController,
                      isDate: true,
                      errorMessage: _limitDateError,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Add Goal Button
              ElevatedButton(
                onPressed: _validateAndSubmit,
                style: button,
                child: const Text(
                  'Add Goal',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 