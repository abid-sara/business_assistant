class Goal {
  int? id;
  String title;
  String description;
  DateTime startDate;
  DateTime limitDate;
  String status;
  bool deleted;

  Goal({
    this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.limitDate,
    required this.status,
    this.deleted = false, 
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'limitDate': limitDate.toIso8601String(),
      'status': status,
      'deleted': deleted ? 1 : 0, 
    };
  }

  static Goal fromMap(Map<String, dynamic> map) {
    return Goal(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      startDate: DateTime.parse(map['startDate']),
      limitDate: DateTime.parse(map['limitDate']),
      status: map['status'],
      deleted: map['deleted'] == 1, 
    );
  }
}
