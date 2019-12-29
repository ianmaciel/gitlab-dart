import 'package:gitlab/src/notes.dart';
import 'package:test/test.dart';

import 'assets/json_data.dart' as data;

void main() {
  group('NotesApi for Issues', () {
    final notes = data.decodeList(data.issueNotes);

    setUp(() {});

    test('Note class properly maps the JSON', () async {
      final noteMap = notes[0] as Map<String, dynamic>;
      final authorMap = notes[0]["author"] as Map<String, dynamic>;

      final Note note = Note.fromJsonList(notes).first;
      final Author author = note.author;

      expect(note.id, noteMap['id']);
      expect(note.type, noteMap['type']);
      expect(note.body, noteMap['body']);
      expect(note.createdAt, DateTime.parse(noteMap['created_at'].toString()));
      expect(note.updatedAt, DateTime.parse(noteMap['updated_at'].toString()));
      expect(note.isSystemNote, noteMap['system']);

      expect(note.noteableId, noteMap['noteable_id']);
      expect(note.noteableType, noteMap['noteable_type']);
      expect(note.noteableIid, noteMap['noteable_iid']);

      expect(author.id, authorMap['id']);
      expect(author.name, authorMap['name']);
      expect(author.state, authorMap['state']);
      expect(author.avatarUrl, authorMap['avatar_url']);
      expect(author.webUrl, authorMap['web_url']);
    });
  });
}
