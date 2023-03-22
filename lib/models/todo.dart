class Todos {
  final String id;
  String title;
  String subTask;
  DateTime dateTime;
  String priority;

  Todos(
      {required this.id,
      required this.title,
      required this.subTask,
      required this.dateTime,
      required this.priority});

  factory Todos.fromJson(Map<String, dynamic> json) {
    return Todos(
        id: json['id'] as String,
        title: json['title'] as String,
        subTask: json['subTask'] as String,
        dateTime: DateTime.parse(json['dateTime'] as String),
        priority: json['priority'] as String);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'subTask': subTask,
        'dateTime': dateTime.toIso8601String(),
        'priority': priority
      };
}
