import 'dart:async';

import 'package:gitlab/gitlab.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'assets/json_data.dart' as data;
import 'src/mocks.dart';

void main() {
  group('MergeRequestsApi', () {
    MockGitLabHttpClient mockHttpClient;
    MockResponse mockResponse;
    GitLab gitLab;
    ProjectsApi project;

    final projectId = 1337;
    final headers = {'PRIVATE-TOKEN': 'secret-token'};

    final mergeRequestsMap = data.decodeMap(data.mergeRequest);
    final int mergeRequestId = mergeRequestsMap['id'];
    final int mergeRequestIid = mergeRequestsMap['iid'];

    setUp(() {
      mockResponse = new MockResponse();
      mockHttpClient = new MockGitLabHttpClient();

      when(mockHttpClient.request(any, any, any))
          .thenAnswer((_) => new Future.value(mockResponse));

      gitLab = getTestable(mockHttpClient);
      project = gitLab.project(projectId);
    });

    test('MergeRequest class properly maps the JSON', () async {
      final mergeRequest = new MergeRequest.fromJson(mergeRequestsMap);
      expect(mergeRequest.id, mergeRequestsMap['id']);
      expect(mergeRequest.iid, mergeRequestsMap['iid']);

      expect(mergeRequest.targetBranch, mergeRequestsMap['target_branch']);
      expect(mergeRequest.sourceBranch, mergeRequestsMap['source_branch']);

      expect(mergeRequest.projectId, mergeRequestsMap['project_id']);

      expect(mergeRequest.title, mergeRequestsMap['title']);
      expect(mergeRequest.state, mergeRequestsMap['state']);

      expect(mergeRequest.labels, mergeRequestsMap['labels']);
      expect(mergeRequest.labels, ["No Promotion"]);

      expect(mergeRequest.upvotes, mergeRequestsMap['upvotes']);
      expect(mergeRequest.downvotes, mergeRequestsMap['downvotes']);

      expect(mergeRequest.description, mergeRequestsMap['description']);
      expect(mergeRequest.webUrl, mergeRequestsMap['web_url']);
    });

    test('.get()', () async {
      final uri = Uri.parse('https://gitlab.com/api/v4'
          '/projects/$projectId/merge_requests/$mergeRequestIid');
      when(mockResponse.statusCode).thenReturn(200);
      when(mockResponse.body).thenReturn(data.mergeRequest);
      final mergeRequest = await project.mergeRequests.get(mergeRequestId);
      verify(mockHttpClient.request(uri, headers, HttpMethod.get)).called(1);
      expect(mergeRequest.id, mergeRequestId);
    });
    test('.list()', () async {
      final uri = Uri.parse('https://gitlab.com/api/v4'
          '/projects/$projectId/merge_requests?');
      when(mockResponse.statusCode).thenReturn(200);
      when(mockResponse.body).thenReturn(data.mergeRequests);
      final mergeRequests = await project.mergeRequests.list();
      verify(mockHttpClient.request(uri, headers, HttpMethod.get)).called(1);
      expect(mergeRequests, hasLength(1));
    });
  });
}
