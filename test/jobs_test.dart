import 'dart:async';

import 'package:gitlab/gitlab.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'assets/json_data.dart' as data;
import 'src/mocks.dart';

void main() {
  group('JobsApi', () {
    // Constants
    final projectId = 1337;
    final headers = {'PRIVATE-TOKEN': 'secret-token'};

    final jobMap = data.decodeMap(data.job);
    final int jobId = jobMap['id'];

    // Mocks
    final mockHttpClient = MockGitLabHttpClient();
    final mockResponse = MockResponse();

    // The objects being tested
    final gitLab = getTestable(mockHttpClient);
    final project = gitLab.project(projectId);

    setUp(() {
      clearInteractions(mockHttpClient);
      clearInteractions(mockResponse);

      // Always return the response. The test should check whether the
      // arguments were correct.
      when(mockHttpClient.request(any, any, any))
          .thenAnswer((_) => new Future.value(mockResponse));
      when(mockResponse.statusCode).thenReturn(200);
    });

    test('Job class properly maps the JSON', () async {
      final job = new Job.fromJson(jobMap);

      // Since the plan is to migrate to json_serializable the testing
      // for the mapping here is very limited.
      expect(job.id, jobMap['id']);
    });

    test('.get()', () async {
      final uri = Uri.parse(
          'https://gitlab.com/api/v4/projects/$projectId/jobs/$jobId');
      when(mockResponse.body).thenReturn(data.job);
      final job = await project.jobs.get(jobId);
      verify(mockHttpClient.request(uri, headers, HttpMethod.get)).called(1);
      expect(job.id, jobId);
    });
    test('.list()', () async {
      final uri =
          Uri.parse('https://gitlab.com/api/v4/projects/$projectId/jobs?');
      when(mockResponse.body).thenReturn(data.jobs);
      final jobs = await project.jobs.list();
      verify(mockHttpClient.request(uri, headers, HttpMethod.get)).called(1);
      expect(jobs, hasLength(2));
    });
  });
}
