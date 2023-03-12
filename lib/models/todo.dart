class Todos {
  final String id;
  String title;
  String description;

  Todos({
    required this.id,
    required this.title,
    required this.description,
  });

  factory Todos.fromJson(Map<String, dynamic> json) {
    return Todos(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
      };
}
