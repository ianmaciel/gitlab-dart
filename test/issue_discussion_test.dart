import 'package:gitlab/src/discussions.dart';
import 'package:test/test.dart';

import 'assets/json_data.dart' as data;

void main() {
  group('DiscussionApi for Issues', () {
    final discussions = data.decodeList(data.issueDiscussions);
    final simpleMap = discussions[1] as Map<String, dynamic>;

    setUp(() {});

    test('Discussion class properly maps the JSON', () async {
      final notes = (simpleMap['notes'] as List);
      final noteMap = notes[0] as Map<String, dynamic>;
      final authorMap = notes[0]["author"] as Map<String, dynamic>;

      final simple = Discussion.fromJson(simpleMap);
      final Note note = simple.notes.first;
      final Author author = note.author;

      expect(simple.id, simpleMap['id']);
      expect(simple.isIndividualNote, simpleMap['individual_note']);
      expect(simple.notes.length, notes.length);

      expect(note.id, noteMap['id']);
      expect(note.type, noteMap['type']);
      expect(note.body, noteMap['body']);
      expect(note.createdAt.toIso8601String(), noteMap['created_at']);
      expect(note.updatedAt.toIso8601String(), noteMap['updated_at']);
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
