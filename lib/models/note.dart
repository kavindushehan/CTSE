class Notes {
  final String noteId;
  String noteDescription;
  

  Notes({
    required this.noteId,
    required this.noteDescription,
    
  });

  factory Notes.fromJson(Map<String, dynamic> json) {
    return Notes(
      noteId: json['noteId'] as String,
      noteDescription: json['noteDescription'] as String,
      
    );
  }

  Map<String, dynamic> toJson() => {
        'noteId': noteId,
        'noteDescription': noteDescription,
        
      };
}
