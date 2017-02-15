import 'package:gitlab/gitlab.dart';
import 'package:gitlab/src/http_client.dart';
import 'package:mockito/mockito.dart';

class MockGitLabHttpClient extends Mock implements GitLabHttpClient {}

class MockGitLab extends Mock implements GitLab {}
