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

    final issueJson = new File('test/assets/issues.get.json').readAsStringSync();
    final issueMap = JSON.decode(issueJson);
    final issueId = issueMap['id'];

    setUp(() {
      mockResponse = new MockResponse();
      mockHttpClient = new MockGitLabHttpClient();
      gitLab = getTestable(mockHttpClient);
      project = gitLab.project(projectId);
    });

    test('Issue class properly maps the JSON', () async {
      final issue = new Issue.fromJson(issueMap);
      await expect(issue.projectId, issueMap['project_id']);
      await expect(issue.id, issueMap['id']);
      await expect(issue.iid, issueMap['iid']);

      await expect(issue.title, issueMap['title']);
      await expect(issue.description, issueMap['description']);

      await expect(issue.state, issueMap['state']);
      await expect(issue.labels, ["Feature", "Bug"]);
      await expect(issue.labels, issueMap['labels']);

      await expect(issue.webUrl, issueMap['web_url']);

      await expect(issue.createdAt, DateTime.parse(issueMap['created_at']));
      await expect(issue.updatedAt, DateTime.parse(issueMap['updated_at']));

      await expect(issue.subscribed, issueMap['subscribed']);

      await expect(issue.userNotesCount, issueMap['user_notes_count']);

      await expect(issue.dueDate, isNull);
      issue.originalJson['due_date'] = '2016-01-04T15:31:46.176Z';
      await expect(issue.dueDate, DateTime.parse(issue.originalJson['due_date']));

      await expect(issue.confidential, issueMap['confidential']);
      await expect(issue.weight, issueMap['weight']);
    });

    test('.get()', () async {
      final uri = Uri.parse('https://gitlab.com/api/v3/projects/$projectId/issues/$issueId');
      when(mockHttpClient.request(uri, headers, HttpMethod.get)).thenReturn(mockResponse);
      when(mockResponse.statusCode).thenReturn(200);
      when(mockResponse.body).thenReturn(issueJson);
      final issue = await project.issues.get(issueId);
      verify(mockHttpClient.request(uri, headers, HttpMethod.get)).called(1);
      await expect(issue.id, issueId);
    });
  });
}
