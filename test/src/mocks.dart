import 'package:gitlab/gitlab.dart';
import 'package:gitlab/src/http_client.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

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

class MockGitLabHttpClient extends Mock implements GitLabHttpClient {
  Call replyWith(
      {String path,
      HttpMethod method = HttpMethod.get,
      int statusCode = 200,
      String body = ""}) {
    final uri = Uri.parse("https://gitlab.com/api/v4$path");
    final headers = {'PRIVATE-TOKEN': 'secret-token'};
    final mockResponse = new MockResponse();
    when(request(uri, headers, method)).thenAnswer((_) async => mockResponse);
    when(mockResponse.statusCode).thenReturn(statusCode);
    when(mockResponse.body).thenReturn(body);

    return Call(this, uri, method, headers);
  }
}

class MockResponse extends Mock implements http.Response {}

class MockGitLab extends Mock implements GitLab {}
