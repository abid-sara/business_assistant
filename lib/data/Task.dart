class Task {
  final int? id;
  final String title;
  final String description;
  final DateTime date;
  final DateTime startTime;
  final DateTime endTime;
  String status;
  String? reminder;  // New field for reminder
  String repeatFrequency;  // New field for repeat frequency
  bool deleted;  // New field for deleted status

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.status = "In progress",
    this.reminder,  // Initialize reminder
    this.repeatFrequency = "None",  // Initialize repeatFrequency
    this.deleted = false , // Default value for deleted
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'status': status,
      'reminder': reminder,
      'repeatFrequency': repeatFrequency,
      'deleted': deleted ? 1 : 0,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      date: DateTime.parse(map['date']),
      startTime: DateTime.parse(map['startTime']),
      endTime: DateTime.parse(map['endTime']),
      status: map['status'],
      reminder: map['reminder'],  // Parse reminder from map
      repeatFrequency: map['repeatFrequency'],  // Parse repeatFrequency from map
      deleted: map['deleted'] == 1,  // Parse deleted status
    );
  }
}
