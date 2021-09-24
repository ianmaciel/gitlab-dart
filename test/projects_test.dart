import 'package:gitlab/gitlab.dart';
import 'package:test/test.dart';

import 'assets/json_data.dart' as data;
import 'src/mocks.dart';

void main() {
  group('ProjectsApi', () {
    final MockGitLabHttpClient mockHttpClient = MockGitLabHttpClient();
    GitLab gitLab;
    late ProjectsApi project;

    final projectId = 123;

    setUp(() {
      gitLab = getTestable(mockHttpClient);
      project = gitLab.project(projectId);
    });

    group('.buildUri()', () {
      test('adds project information', () {
        final uri = project.buildUri(['foo']);
        expect(uri.toString(),
            'https://gitlab.com/api/v4/projects/$projectId/foo');
      });
      test('forwards page and perPage', () {
        final uri = project.buildUri(['foo'], page: 5, perPage: 50);
        expect(uri.toString(),
            'https://gitlab.com/api/v4/projects/$projectId/foo?page=5&per_page=50');
      });
      test('forwards queryParameters', () {
        final uri = project.buildUri(['foo'],
            queryParameters: {'foo': 'bar'}, page: 5, perPage: 50);
        expect(uri.toString(),
            'https://gitlab.com/api/v4/projects/$projectId/foo?foo=bar&page=5&per_page=50');
      });
      test('.list()', () async {
        final call = mockHttpClient.configureCall(
          path: '/projects?search_namespaces=false&simple=true&sort=desc',
          responseBody: data.projects,
        );

        final List<Project> projects = await project.list();

        call.verifyCalled(1);
        expect(projects, hasLength(2));
        expect(projects.first.id, 4);
        expect(projects.first.description, null);
        expect(projects.first.defaultBranch, 'master');
        expect(projects.first.name, 'Diaspora Client');
        expect(projects.first.forksCount, 0);
        expect(projects.first.starCount, 0);
        expect(projects.first.avatarUrl,
            'http://example.com/uploads/project/avatar/4/uploads/avatar.png');
        expect(projects.first.pathWithNamespaceath, 'diaspora/diaspora-client');
        expect(projects.first.path, 'diaspora-client');
        expect(projects.first.topics!.first, 'example');
        expect(projects.first.readmeUrl,
            'http://example.com/diaspora/diaspora-client/blob/master/README.md');
        expect(projects.first.webUrl,
            'http://example.com/diaspora/diaspora-client');
        expect(projects.first.httpRrlToRepo,
            'http://example.com/diaspora/diaspora-client.git');
        expect(projects.first.sshUrlToRepo,
            'git@example.com:diaspora/diaspora-client.git');
      });
    });
  });
}
