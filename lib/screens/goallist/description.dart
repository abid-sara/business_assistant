import 'package:flutter/material.dart';
import '../../style/colors.dart';
import '../../data/goaldata.dart';
import 'package:intl/intl.dart';
import 'package:business_assistant/data/goaldata.dart';


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
    
    return Column(
                children: [
                    Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        text,
                        style:  const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    ),
                  Row(
                    children: [
                      Expanded(
                        child:
                        Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0), 
                        
                  child:TextField(
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
                      contentPadding: const EdgeInsets.symmetric(vertical :12),
                    ),
                  ))
    ),
                  if(isDate)
                  IconButton(
                    icon : const Icon(Icons.calendar_month_outlined ,color:Colors.white),
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
                  ])]);
    
  }
}
class Description extends StatefulWidget {
  
  final Goal? goal;
  const Description({super.key ,this.goal});
  @override
  _DescriptionState createState() => _DescriptionState();
  
}
class _DescriptionState extends State<Description> with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _limitDateController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
   final TextEditingController _status = TextEditingController();
   final TextEditingController _descriptionController = TextEditingController();

    List<Goal> goals =[];

   //for error handling
   late String? _titleError;
   late String? _startDateError;
    late String? _limitDateError;
    
   
  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
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
      _startDateController.text = DateFormat('dd/MM/yyyy').format(widget.goal!.start_date);
      _limitDateController.text = DateFormat('dd/MM/yyyy').format(widget.goal!.limit_date);
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
    DateTime startDate = DateFormat('dd/MM/yyyy').parse(_startDateController.text);
    DateTime limitDate = DateFormat('dd/MM/yyyy').parse(_limitDateController.text);

    return Goal(
      title: _titleController.text,
      status: _status.text.isNotEmpty ? _status.text : 'In Progress',
      start_date: startDate,
      limit_date: limitDate,
      description: _descriptionController.text,
    );
  }

   Goal addGoal() {
  
  DateTime startDate = DateFormat('dd/MM/yyyy').parse(_startDateController.text);
  DateTime limitDate = DateFormat('dd/MM/yyyy').parse(_limitDateController.text);

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
  if(DateFormat('dd/MM/yyyy').parse(_startDateController.text).isBefore(DateTime.now())) {
    setState(() {
      _startDateError = 'Date passed';
    });// if it is in the future then the user will receive it as reminder(notification)
    return false;
  }
  // the limit date should be in the future
  if(DateFormat('dd/MM/yyyy').parse(_limitDateController.text).isBefore(DateTime.now())) {
    setState(() {
      _limitDateError = 'Date passed';
    });
    return false;
  }
  
  //the description is not mandatory
  //the start date should be before the limit date
  if (DateFormat('dd/MM/yyyy').parse(_startDateController.text).isAfter(DateFormat('dd/MM/yyyy').parse(_limitDateController.text))) {
    setState(() {
      _limitDateError = 'start date after limit date';
    });
    return false;
  }
  return true;
}
 
  


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    
      return Scaffold(
       appBar: AppBar(
        
        centerTitle:true,
        title:  const Text(
          'Goal description',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      
      body: 
      Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),  
                fit: BoxFit.cover, 
              ),
            ),
      child :Padding(
         padding: const EdgeInsets.symmetric(vertical: 10),
        child:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
           Expanded(
             child: Container(
             
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(color:AppColors.green,
                borderRadius:BorderRadius.circular(12),),
                width :screenWidth * 0.8,
                height: screenHeight * 0.5,
                child: Column(
                  children: [
                    Column(
                      children: [
                     DataField(
                      text: 'Title',
                      description: 'Enter the title',
                      controller: _titleController,
                    ),
                    if (_titleError != null)
                      Text(
                        _titleError!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                    ),


                  
                     DataField(
                      text: 'Description',
                      description: 'Enter the description',
                      isDescription: true,
                      controller: _descriptionController,
                      ),

                      
                     Row(
                          children: [
                            Expanded(
                              child: Column(
                                  children: [
                                    Column(
                                      children: [
                                    DataField(
                                      text: 'Start date', 
                                      description: 'DD/MM/YYYY',
                                      controller: _startDateController,
                                      isDate: true,
                                    ),
                                    if (_startDateError != null)
                                    
                                     Padding(
                                              padding: const EdgeInsets.only(top: 8.0),
                                              child: Row(
                                                children: [
                                                  Flexible(
                                                    child: Text(
                                                      _startDateError!,
                                                      style: const TextStyle(color: Colors.red),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                      ],
                                    ),
                                   
                                  ],
                                ),

                            ),
                            
                            Expanded(
                              child: Column(
                                          children: [
                                            Column(
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
                                           
                                           
                              ),],
                                        ),

                            ),
                          ],
                        ),
               
             
                  ],
                ),
              ),
           ),
            
             
                  ElevatedButton(
          onPressed: () {
             if (_validateForm()) {
              Goal newGoal = addGoal();
              Navigator.pop(context, newGoal); 
            }
          },
          child: const Text('Add Goal'),
        ),







          ],
        ),
        ),

        )
        
        )
      );
    
  }
  
}
