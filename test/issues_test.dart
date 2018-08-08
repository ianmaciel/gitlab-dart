import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:gitlab/gitlab.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'src/mocks.dart';

void main() {
  group('IssuesApi', () {
    MockGitLabHttpClient mockHttpClient;
    MockResponse mockResponse;
    GitLab gitLab;
    ProjectsApi project;

    final projectId = 1337;
    final headers = {'PRIVATE-TOKEN': 'secret-token'};

    final issueJson =
        new File('test/assets/issues.get.json').readAsStringSync();
    final Map issueMap = jsonDecode(issueJson);
    final int issueId = issueMap['id'];

    setUp(() {
      mockResponse = new MockResponse();
      mockHttpClient = new MockGitLabHttpClient();
      gitLab = getTestable(mockHttpClient);
      project = gitLab.project(projectId);
    });

    test('Issue class properly maps the JSON', () async {
      final issue = new Issue.fromJson(issueMap);
      expect(issue.projectId, issueMap['project_id']);
      expect(issue.id, issueMap['id']);
      expect(issue.iid, issueMap['iid']);

      expect(issue.title, issueMap['title']);
      expect(issue.description, issueMap['description']);

      expect(issue.state, issueMap['state']);
      expect(issue.labels, ["Feature", "Bug"]);
      expect(issue.labels, issueMap['labels']);

      expect(issue.webUrl, issueMap['web_url']);

      expect(issue.createdAt, DateTime.parse(issueMap['created_at'] as String));
      expect(issue.updatedAt, DateTime.parse(issueMap['updated_at'] as String));

      expect(issue.subscribed, issueMap['subscribed']);

      expect(issue.userNotesCount, issueMap['user_notes_count']);

      expect(issue.dueDate, isNull);
      issue.originalJson['due_date'] = '2016-01-04T15:31:46.176Z';
      expect(issue.dueDate,
          DateTime.parse(issue.originalJson['due_date'] as String));

      expect(issue.confidential, issueMap['confidential']);
      expect(issue.weight, issueMap['weight']);
    });

    test('.get()', () async {
      final uri = Uri.parse(
          'https://gitlab.com/api/v4/projects/$projectId/issues/$issueId');
      when(mockHttpClient.request(uri, headers, HttpMethod.get))
          .thenAnswer((_) => new Future.value(mockResponse));
      when(mockResponse.statusCode).thenReturn(200);
      when(mockResponse.body).thenReturn(issueJson);
      final issue = await project.issues.get(issueId);
      verify(mockHttpClient.request(uri, headers, HttpMethod.get)).called(1);
      expect(issue.id, issueId);
    });
  });
}
