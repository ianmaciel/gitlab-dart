/// This library allows you to communicate with the GitLab api.
/// It supports the default `gitlab.com` but also any other GitLab deployment you might have.
///
/// Usage:
///
///     // Setup your gitLab or gitLabProject once.
///     final gitLab  = new GitLab(secretToken);
///     final gitLabProject = gitLab.project('exit-live');
///
///     // Then use it whenever you need in your app.
///     final allMergeRequests = await gitLabProject.mergeRequests.list();
///     final allIssues = await gitLabProject.issues.list(page: 3, perPage: 30);
///     final issue = await gitLabProject.issues.get(allIssues.first.id);
///
/// For more information, please refer to the
/// [official GitLab API documentation at gitlab.com](https://docs.gitlab.com/ee/api/README.html).
library exitlive.gitlab;

import 'dart:async';
import 'dart:convert';

import 'package:gitlab/src/http_client.dart';
import 'package:gitlab/src/json_map.ext.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

part 'src/commits.dart';
part 'src/issues.dart';
part 'src/jobs.dart';
part 'src/merge_requests.dart';
part 'src/notes.dart';
part 'src/pipelines.dart';
part 'src/projects.dart';
part 'src/snippets.dart';
part 'src/utils.dart';

final _log = new Logger('GitLab');

enum HttpMethod { get, post, put }

/// The main class and entry point to use this library.
///
/// See the library documentation for information on how to use it.
class GitLab {
  final String token;

  final String host;
  final String scheme;

  final GitLabHttpClient _httpClient;

  static const String apiVersion = 'v4';

  GitLab(this.token, {this.host: 'gitlab.com', this.scheme: 'https'})
      : _httpClient = new GitLabHttpClient();

  GitLab._test(GitLabHttpClient httpClient, this.token,
      {this.host: 'gitlab.com', this.scheme: 'https'})
      : _httpClient = httpClient;

  /// Get the [ProjectsApi] for this [id].
  ///
  /// This call doesn't do anything by itself, other than return the configured object.
  /// You can safely store the returned object and reuse it.
  ProjectsApi project(int id) => new ProjectsApi(this, id);

  /// Returns the decoded JSON.
  @visibleForTesting
  Future<dynamic> request(Uri uri,
      {HttpMethod method: HttpMethod.get,
      String body,
      bool asJson: true}) async {
    final headers = <String, String>{'PRIVATE-TOKEN': token};

    _log.fine('Making GitLab $method request to $uri.');

    final response = await _httpClient.request(uri, headers, method);

    if (!(response.statusCode >= 200 && response.statusCode < 300)) {
      throw new GitLabException(response.statusCode, response.body);
    }

    return asJson ? jsonDecode(response.body) : response.body;
  }

  /// This function is used internally to build the URIs for API calls.
  @visibleForTesting
  Uri buildUri(Iterable<String> pathSegments,
      {Map<String, dynamic> queryParameters, int page, int perPage}) {
    dynamic _addQueryParameter(String key, dynamic value) =>
        (queryParameters ??= new Map<String, dynamic>())[key] = '$value';

    if (page != null) _addQueryParameter('page', page);
    if (perPage != null) _addQueryParameter('per_page', perPage);
    return new Uri(
        scheme: scheme,
        host: host,
        pathSegments: ['api', apiVersion]..addAll(pathSegments),
        queryParameters: queryParameters);
  }
}

class GitLabException implements Exception {
  final int statusCode;
  final String message;

  GitLabException(this.statusCode, this.message);

  @override
  String toString() => 'GitLabException ($statusCode): $message';
}

/// A helper function to get a [GitLab] instance with a [GitLabHttpClient] that
/// can be mocked.
@visibleForTesting
GitLab getTestable(GitLabHttpClient httpClient,
        [String token = 'secret-token']) =>
    new GitLab._test(httpClient, token);
