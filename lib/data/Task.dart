class Task {
  final String title;
  final DateTime date;
  String status;  
  final String description;
  final String? reminder;
  final String? repeatFrequency; // Repeat task option (Daily, Weekly, Monthly)

  Task({
    required this.title,
    required this.date,
    required this.status,
    required this.description,
    this.reminder,
    this.repeatFrequency, // Accept repeat frequency in constructor
  });
}
