import 'json_map.ext.dart';

class Note {
  Note.fromJson(Map<String, dynamic> note)
      : id = note.getIntOrNull("id"),
        type = note.getStringOrNull("type"),
        body = note.getStringOrNull("body"),
        author = Author.fromJson(note.getJsonMap("author")),
        createdAt = note.getISODateTimeOrNull("created_at"),
        updatedAt = note.getISODateTimeOrNull("updated_at"),
        isSystemNote = note.getBoolOrNull("system"),
        noteableId = note.getIntOrNull("noteable_id"),
        noteableType = note.getStringOrNull("noteable_type"),
        noteableIid = note.getIntOrNull("noteable_iid");

  static List<Note> fromJsonList(List notes) => notes
      .map((n) => n is Map<String, dynamic> ? Note.fromJson(n) : null)
      .where((note) => note != null)
      .toList();

  final int id;
  String type;
  String body;

  Author author;

  DateTime createdAt;
  DateTime updatedAt;

  bool isSystemNote;

  int noteableId;
  String noteableType;
  int noteableIid;
}

class Author {
  Author.fromJson(Map<String, dynamic> author)
      : id = author.getIntOrNull("id"),
        name = author.getStringOrNull("name"),
        username = author.getStringOrNull("username"),
        state = author.getStringOrNull("state"),
        avatarUrl = author.getStringOrNull("avatar_url"),
        webUrl = author.getStringOrNull("web_url");

  final int id;
  String name;
  String username;
  String state;
  String avatarUrl;
  String webUrl;
}
