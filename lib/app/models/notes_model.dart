class NoteModel {
  final String noteId;
  final String noteTitle;
  final String noteContent;
  final String noteUser;
  final String noteImage;

  NoteModel({
    required this.noteId,
    required this.noteTitle,
    required this.noteContent,
    required this.noteUser,
    required this.noteImage,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      noteId: json['note_id'],
      noteTitle: json['note_title'],
      noteContent: json['note_content'],
      noteUser: json['note_user'],
      noteImage: json['note_image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'note_id': noteId,
      'note_title': noteTitle,
      'note_content': noteContent,
      'note_user': noteUser,
      'note_image': noteImage,
    };
  }
}
