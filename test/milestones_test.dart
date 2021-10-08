import 'package:gitlab/gitlab.dart';
import 'package:test/test.dart';

import 'assets/json_data.dart' as data;
import 'src/mocks.dart';

void main() {
  group('MilestonesApi', () {
    late MockGitLabHttpClient mockHttpClient;
    GitLab gitLab;
    late ProjectsApi project;

    final projectId = 1337;

    final Map milestoneMap = data.decodeMap(data.milestone)!;

    setUp(() {
      mockHttpClient = MockGitLabHttpClient();
      gitLab = getTestable(mockHttpClient);
      project = gitLab.project(projectId);
    });

    test('Milestone class properly maps the JSON', () async {
      final Milestone milestone = new Milestone.fromJson(milestoneMap);
      expect(milestone.projectId, milestoneMap['project_id']);
      expect(milestone.id, milestoneMap['id']);
      expect(milestone.iid, milestoneMap['iid']);

      expect(milestone.title, milestoneMap['title']);
      expect(milestone.description, milestoneMap['description']);

      expect(milestone.state, MilestoneState.active);

      expect(milestone.webUrl, '');

      expect(milestone.createdAt,
          DateTime.parse(milestoneMap['created_at'] as String));
      expect(milestone.updatedAt,
          DateTime.parse(milestoneMap['updated_at'] as String));
      expect(milestone.dueDate,
          DateTime.parse(milestoneMap['due_date'] as String));
    });
    test('.list()', () async {
      final call = mockHttpClient.configureCall(
        path: '/projects/$projectId/milestones?',
        responseBody: data.milestones,
      );

      final List<Milestone> milestones = await project.milestones.list();

      call.verifyCalled(1);
      expect(milestones, hasLength(2));
      expect(milestones.first.id, 12);
      expect(milestones.first.title, '10.0');
      expect(milestones.first.description, 'Version');
    });
  });
}
