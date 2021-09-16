import 'package:gitlab/gitlab.dart';
import 'package:test/test.dart';

import 'assets/json_data.dart' as data;
import 'src/mocks.dart';

void main() {
  group('MergeRequestsApi', () {
    late MockGitLabHttpClient mockHttpClient;
    GitLab gitLab;
    late ProjectsApi project;

    final projectId = 1337;

    final mergeRequestsMap = data.decodeMap(data.mergeRequest)!;
    final mergeRequestId = mergeRequestsMap['id'] as int;
    final mergeRequestIid = mergeRequestsMap['iid'] as int?;

    setUp(() {
      mockHttpClient = new MockGitLabHttpClient();

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
      final call = mockHttpClient.configureCall(
        path: '/projects/$projectId/merge_requests/$mergeRequestIid',
        responseBody: data.mergeRequest,
      );

      final mergeRequest = await project.mergeRequests.get(mergeRequestId);

      call.verifyCalled(1);
      expect(mergeRequest.id, mergeRequestId);
    });
    test('.list()', () async {
      final call = mockHttpClient.configureCall(
        path: '/projects/$projectId/merge_requests?',
        responseBody: data.mergeRequests,
      );

      final mergeRequests = await project.mergeRequests.list();

      call.verifyCalled(1);
      expect(mergeRequests, hasLength(1));
    });
  });
}
