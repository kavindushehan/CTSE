class Notes {
  final String noteId;
  String noteDescription;
  String noteTitle;
  String noteType;
  

  Notes({
    required this.noteId,
    required this.noteTitle,
    required this.noteDescription,
    required this.noteType,
    
  });

  factory Notes.fromJson(Map<String, dynamic> json) {
    return Notes(
      noteId: json['noteId'] as String,
      noteTitle: json['noteTitle'] as String,
      noteDescription: json['noteDescription'] as String,
      noteType: json['noteType'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'noteId': noteId,
        'noteTitle': noteTitle,
        'noteDescription': noteDescription,
        'noteType': noteType,
        
      };
}
