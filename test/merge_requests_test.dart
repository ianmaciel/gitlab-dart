import 'dart:convert';
import 'dart:io';

import 'package:gitlab/gitlab.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'src/mocks.dart';

void main() {
  group('MergeRequestsApi', () {
    MockGitLabHttpClient mockHttpClient;
    MockResponse mockResponse;
    GitLab gitLab;
    ProjectsApi project;

    final projectId = 1337;
    final headers = {'PRIVATE-TOKEN': 'secret-token'};

    final mergeRequestsJson = new File('test/assets/merge_requests.get.json').readAsStringSync();
    final mergeRequestsMap = JSON.decode(mergeRequestsJson);
    final mergeRequestId = mergeRequestsMap['id'];

    setUp(() {
      mockResponse = new MockResponse();
      mockHttpClient = new MockGitLabHttpClient();
      gitLab = getTestable(mockHttpClient);
      project = gitLab.project(projectId);
    });

    test('MergeRequest class properly maps the JSON', () async {
      final mergeRequest = new MergeRequest.fromJson(mergeRequestsMap);
      await expect(mergeRequest.id, mergeRequestsMap['id']);
      await expect(mergeRequest.iid, mergeRequestsMap['iid']);

      await expect(mergeRequest.targetBranch, mergeRequestsMap['target_branch']);
      await expect(mergeRequest.sourceBranch, mergeRequestsMap['source_branch']);

      await expect(mergeRequest.projectId, mergeRequestsMap['project_id']);

      await expect(mergeRequest.title, mergeRequestsMap['title']);
      await expect(mergeRequest.state, mergeRequestsMap['state']);

      await expect(mergeRequest.labels, mergeRequestsMap['labels']);
      await expect(mergeRequest.labels, ["No Promotion"]);

      await expect(mergeRequest.upvotes, mergeRequestsMap['upvotes']);
      await expect(mergeRequest.downvotes, mergeRequestsMap['downvotes']);

      await expect(mergeRequest.description, mergeRequestsMap['description']);
      await expect(mergeRequest.webUrl, mergeRequestsMap['web_url']);
    });

    test('.get()', () async {
      final uri = Uri.parse('https://gitlab.com/api/v3/projects/$projectId/merge_requests/$mergeRequestId');
      when(mockHttpClient.request(uri, headers, HttpMethod.get)).thenReturn(mockResponse);
      when(mockResponse.statusCode).thenReturn(200);
      when(mockResponse.body).thenReturn(mergeRequestsJson);
      final mergeRequest = await project.mergeRequests.get(mergeRequestId);
      verify(mockHttpClient.request(uri, headers, HttpMethod.get)).called(1);
      await expect(mergeRequest.id, mergeRequestId);
    });
  });
}
