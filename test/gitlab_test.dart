import 'package:gitlab/gitlab.dart';
import 'package:test/test.dart';

void main() {
  group('GitLab', () {
    test('.project() returns a new configured project', () {
      final gitLab = new GitLab('private-token');
      final project = gitLab.project(123);
      expect(project, new isInstanceOf<ProjectsApi>());
      expect(project.id, 123);
    });
  });
}
