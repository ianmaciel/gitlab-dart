import 'package:gitlab/gitlab.dart';
import 'package:gitlab/src/http_client.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

class MockGitLabHttpClient extends Mock implements GitLabHttpClient {}

class MockResponse extends Mock implements http.Response {}

class MockGitLab extends Mock implements GitLab {}
