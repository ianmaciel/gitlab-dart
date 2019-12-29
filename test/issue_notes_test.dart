import 'package:gitlab/gitlab.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'assets/json_data.dart' as data;
import 'src/mocks.dart';

void main() {
  group('NotesApi for Issues', () {
    MockGitLabHttpClient mockHttpClient;
    MockResponse mockResponse;
    GitLab gitLab;
    ProjectsApi project;

    final projectId = 1337;
    final issue = Issue.fromJson(data.decodeMap(data.issue));
    final headers = {'PRIVATE-TOKEN': 'secret-token'};

    final notesJson = data.decodeList(data.issueNotes);

    setUp(() {
      mockResponse = new MockResponse();
      mockHttpClient = new MockGitLabHttpClient();
      gitLab = getTestable(mockHttpClient);
      project = gitLab.project(projectId);
    });

    test('Note class properly maps the JSON', () async {
      for (var item in notesJson) {
        final noteJson = item as Map<String, dynamic>;
        final authorJson = noteJson["author"] as Map<String, dynamic>;

        final Note note = Note.fromJson(noteJson);
        final Author author = note.author;

        expect(note.id, noteJson['id']);
        expect(note.type, noteJson['type']);
        expect(note.body, noteJson['body']);
        expect(
            note.createdAt, DateTime.parse(noteJson['created_at'].toString()));
        expect(
            note.updatedAt, DateTime.parse(noteJson['updated_at'].toString()));
        expect(note.isSystemNote, noteJson['system']);

        expect(note.noteableId, noteJson['noteable_id']);
        expect(note.noteableType, noteJson['noteable_type']);
        expect(note.noteableIid, noteJson['noteable_iid']);

        expect(author.id, authorJson['id']);
        expect(author.name, authorJson['name']);
        expect(author.state, authorJson['state']);
        expect(author.avatarUrl, authorJson['avatar_url']);
        expect(author.webUrl, authorJson['web_url']);
      }
    });

    test('.list()', () async {
      final uri = Uri.parse(
          'https://gitlab.com/api/v4/projects/$projectId/issues/${issue.iid}/notes?');
      when(mockHttpClient.request(uri, headers, HttpMethod.get))
          .thenAnswer((_) async => mockResponse);
      when(mockResponse.statusCode).thenReturn(200);
      when(mockResponse.body).thenReturn(data.issueNotes);

      final notes = await project.notes.listForIssue(issue);
      verify(mockHttpClient.request(uri, headers, HttpMethod.get)).called(1);
      expect(notes, hasLength(2));
      expect(notes.first.id, 302);
    });
  });
}
