/// This library allows you to communicate with the GitLab api.
/// It supports the default `gitlab.com` but also any other GitLab deployment you might have.
///
/// Usage:
///
///     // Setup your gitLab or gitLabProject once
///     final gitLab  = new GitLab(secretToken);
///     final gitLabProject = await gitLab.project('exit-live');
///
///     // Then use it whenever you need in your app
///     final allMergeRequests = await gitLabProject.mergeRequests.list();
///     final allIssues = await gitLabProject.issues.list(page: 3, perPage: 30);
///     final issue = await gitLabProject.issues.get(allIssues.first.id);
///
/// For more information, please refer to the [official GitLab API documentation at gitlab.com](https://docs.gitlab.com/ee/api/README.html).
library exitlive.gitlab;

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';

part 'src/build.dart';
part 'src/commit.dart';
part 'src/issue.dart';
part 'src/merge_request.dart';
part 'src/pipeline.dart';
part 'src/project.dart';
part 'src/snippet.dart';
part 'src/utils.dart';

final _log = new Logger('GitLab');

/// The main class and entry point to use this library.
///
/// See the library documentation for information on how to use it.
class GitLab {
  final String token;

  final String host;
  final String scheme;

  static const String apiVersion = 'v3';

  GitLab(this.token, {this.host: 'gitlab.com', this.scheme: 'https'});

  ProjectsApi project(int id) => new ProjectsApi(this, id);

  /// Returns the decoded JSON
  Future<dynamic> _request(Uri uri, {String httpMethod: 'GET', String body, bool asJson: true}) async {
    final headers = <String, String>{
      'PRIVATE-TOKEN': token,
    };

    _log.fine('Making GitLab $httpMethod request to $uri.');

    http.Response response;
    if (httpMethod == 'GET') {
      response = await http.get(uri, headers: headers);
    } else if (httpMethod == 'PUT') {
      response = await http.put(uri, headers: headers);
    } else if (httpMethod == 'POST') {
      response = await http.post(uri, headers: headers);
    } else {
      throw new ArgumentError('Invalid http method: $httpMethod');
    }

    if (!(response.statusCode >= 200 && response.statusCode < 300)) {
      throw new GitLabException(response.statusCode, response.body);
    }

    return asJson ? JSON.decode(response.body) : response.body;
  }

  /// This function is used internally to build the URIs for API calls.
  Uri _buildUri(Iterable<String> pathSegments, {Map<String, dynamic> queryParameters, int page, int perPage}) {
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
