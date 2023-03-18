class Todos {
  final String id;
  String title;
  String description;
  DateTime dateTime;

  Todos({
    required this.id,
    required this.title,
    required this.description,
    required this.dateTime,
  });

  factory Todos.fromJson(Map<String, dynamic> json) {
    return Todos(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      dateTime: DateTime.parse(json['dateTime'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'dateTime': dateTime.toIso8601String(),
      };
}
