import 'package:gitlab/gitlab.dart';
import 'package:gitlab/src/http_client.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'mocks.mocks.dart';

// Annotation which generates the cat.mocks.dart library and the BaseMockGitLabHttpClient class.
@GenerateMocks([http.Response, GitLab],
    customMocks: [MockSpec<GitLabHttpClient>(as: #BaseMockGitLabHttpClient)])
class Call {
  final MockGitLabHttpClient client;
  final Uri uri;
  final HttpMethod method;
  final Map<String, String> headers;

  Call(this.client, this.uri, this.method, this.headers);

  void verifyCalled(dynamic matcher) {
    verify(client.request(uri, headers, method)).called(matcher);
  }
}

class MockGitLabHttpClient extends BaseMockGitLabHttpClient {
  Call configureCall(
      {String? path,
      HttpMethod method = HttpMethod.get,
      int responseStatusCode = 200,
      String responseBody = ""}) {
    final uri = Uri.parse("https://gitlab.com/api/v4$path");
    final headers = {'PRIVATE-TOKEN': 'secret-token'};
    final mockResponse = new MockResponse();
    when(request(uri, headers, method)).thenAnswer((_) async => mockResponse);
    when(mockResponse.statusCode).thenReturn(responseStatusCode);
    when(mockResponse.body).thenReturn(responseBody);
    when(mockResponse.headers).thenReturn({});

    return Call(this, uri, method, headers);
  }
}
