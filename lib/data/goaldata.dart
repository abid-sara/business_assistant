class Goal {
  
  final String title ;
  final String description ; 
  final DateTime start_date ;
  final DateTime limit_date ;
  String status ;
  

 Goal(
  {
    required this.title,
    required this.start_date,
    required this.limit_date,
    required this.description,
    required this.status,
  }
 );
  void setStatus(String newStatus) {
    if (newStatus == 'missed' || newStatus == 'in progress' || newStatus == 'completed') {
      status = newStatus;
    } else {
      throw ArgumentError('Invalid status: $newStatus');
    }
  }
  //to get obly the date and not the time also
   DateTime get startDateOnly => DateTime(start_date.year, start_date.month, start_date.day);
  DateTime get limitDateOnly => DateTime(limit_date.year, limit_date.month, limit_date.day);
  
}
List <Goal> goallist = [
  Goal(
    title: 'Goal 1',
    start_date: DateTime(2025, 4, 23),
    limit_date : DateTime(2026, 4, 23),
    status: 'In progress',
    description : 'description',
    
  ),
  Goal(
    title: 'Goal 2',
    start_date: DateTime(2024, 4, 23),
    limit_date : DateTime(2026, 4, 23),
    status: 'In progress',
    description : 'description',
  ),
  
  
 
  
  Goal(
    title: 'Goal 9',
    start_date: DateTime(2024, 4, 23),
    limit_date : DateTime(2024, 4, 23),
    status: 'In progress',
 
  description : 'description'),

  Goal(
    title: 'Goal 10',
    start_date: DateTime(2024, 4, 23),
    limit_date : DateTime(2024, 4, 23),
    status: 'Completed',
 
  description : 'description',),
  Goal(
    title: 'Goal 11',
    start_date: DateTime(2024, 4, 23),
    limit_date : DateTime(2024, 4, 23),
    status: 'Completed'
    ,description : 'description',
  ),
  Goal(
    title: 'Goal 12',
    start_date: DateTime(2024, 4, 23),
    limit_date : DateTime(2024, 4, 23),
    status: 'Completed'
    ,description : 'description',
  ),
  
  Goal(
    title: 'Goal 17',
    start_date: DateTime(2024, 4, 23),
    limit_date : DateTime(2024, 4, 23),
    status: 'Completed',
     description : 'description',
   ),
];