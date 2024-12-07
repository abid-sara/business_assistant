import 'package:business_assistant/widget/button.dart';
import 'package:flutter/material.dart';
import '../../style/colors.dart';
import '../../data/goaldata.dart';
import 'package:intl/intl.dart';
import 'package:business_assistant/widget/back_arrow.dart';

class DataField extends StatelessWidget {
  final String text;
  final String description;
  final bool isDescription;
  final bool isDate;
  final TextEditingController controller;

  const DataField({
    super.key,
    required this.text,
    required this.description,
    required this.controller,
    this.isDescription = false,
    this.isDate = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      Row(children: [
        Expanded(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  style: const TextStyle(fontSize: 20),
                  controller: controller,
                  maxLines: isDescription ? 5 : 1,
                  decoration: InputDecoration(
                    fillColor: AppColors.lightGreen,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    hintText: description,
                    hintStyle: const TextStyle(color: Colors.grey),
                     contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  ),
                ))),
        if (isDate)
          IconButton(
            icon:
                const Icon(Icons.calendar_month_outlined, color: Colors.white),
            onPressed: () async {
              DateTime? selectedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (selectedDate != null) {
                controller.text = DateFormat('dd/MM/yyyy').format(selectedDate);
              }
            },
          )
      ])
    ]);
  }
}

class Description extends StatefulWidget {
  final Goal? goal;
  const Description({super.key, this.goal});
  @override
  _DescriptionState createState() => _DescriptionState();
}

class _DescriptionState extends State<Description>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _limitDateController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _status = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  List<Goal> goals = [];

  //for error handling
  late String? _titleError;
  late String? _startDateError;
  late String? _limitDateError;

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (selectedDate != null) {
      controller.text = "${selectedDate.day.toString().padLeft(2, '0')}/"
          "${selectedDate.month.toString().padLeft(2, '0')}/"
          "${selectedDate.year}";
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _titleError = null;
    _startDateError = null;
    _limitDateError = null;

    if (widget.goal != null) {
      _titleController.text = widget.goal!.title;
      _startDateController.text =
          DateFormat('dd/MM/yyyy').format(widget.goal!.start_date);
      _limitDateController.text =
          DateFormat('dd/MM/yyyy').format(widget.goal!.limit_date);
      _descriptionController.text = widget.goal!.description;
      _status.text = widget.goal!.status;
    }
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

  Goal updateGoal() {
    DateTime startDate =
        DateFormat('dd/MM/yyyy').parse(_startDateController.text);
    DateTime limitDate =
        DateFormat('dd/MM/yyyy').parse(_limitDateController.text);

    return Goal(
      title: _titleController.text,
      status: _status.text.isNotEmpty ? _status.text : 'In Progress',
      start_date: startDate,
      limit_date: limitDate,
      description: _descriptionController.text,
    );
  }

  Goal addGoal() {
    DateTime startDate =
        DateFormat('dd/MM/yyyy').parse(_startDateController.text);
    DateTime limitDate =
        DateFormat('dd/MM/yyyy').parse(_limitDateController.text);

    Goal goal = Goal(
      title: _titleController.text,
      status: _status.text.isNotEmpty ? _status.text : 'In Progress',
      start_date: startDate,
      limit_date: limitDate,
      description: _descriptionController.text,
    );

    return goal;
  }

//form validation
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
    //start date should be either today or in the future today's date
    if (DateFormat('dd/MM/yyyy')
        .parse(_startDateController.text)
        .isBefore(DateTime.now())) {
      setState(() {
        _startDateError = 'Date passed';
      }); // if it is in the future then the user will receive it as reminder(notification)
      return false;
    }
    // the limit date should be in the future
    if (DateFormat('dd/MM/yyyy')
        .parse(_limitDateController.text)
        .isBefore(DateTime.now())) {
      setState(() {
        _limitDateError = 'Date passed';
      });
      return false;
    }

    //the description is not mandatory
    //the start date should be before the limit date
    if (DateFormat('dd/MM/yyyy')
        .parse(_startDateController.text)
        .isAfter(DateFormat('dd/MM/yyyy').parse(_limitDateController.text))) {
      setState(() {
        _limitDateError = 'start date after limit date';
      });
      return false;
    }
    return true;
  }

  @override
 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: BackArrow(
      onPressed: () {
        Navigator.pushNamed(context, '/goallist');
      },
      title: 'Goal Description',
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
              onPressed: () {
                if (_validateForm()) {
                  Goal newGoal = addGoal();
                  Navigator.pop(context, newGoal);
                }
              },
              style: button,
              child: const Text(
                'Add Goal',
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