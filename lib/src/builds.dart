part of exitlive.gitlab;

/// The documentation for this API is here: https://docs.gitlab.com/ee/api/builds.html
class BuildsApi {
  final GitLab _gitLab;
  final ProjectsApi _project;

  BuildsApi(this._gitLab, this._project);

  Future<Build> get(int id) async {
    final uri = _project.buildUri(['builds', '$id']);

    final Map json = await _gitLab.request(uri);

    return new Build.fromJson(json);
  }

  Future<Build> cancel(int id) async {
    final uri = _project.buildUri(['builds', '$id', 'cancel']);

    final Map json = await _gitLab.request(uri, method: HttpMethod.post);

    return new Build.fromJson(json);
  }

  Future<List<Build>> list({List<BuildScope> scopes, int page, int perPage}) async {
    final queryParameters = <String, dynamic>{};

    if (scopes != null && scopes.isNotEmpty) {
      if (scopes.length == 1) {
        queryParameters['scope'] = _enumToString(scopes.first);
      } else {
        for (var i = 0; i < scopes.length; i++) {
          queryParameters['scope[$i]'] = _enumToString(scopes[i]);
        }
      }
    }

    final uri = _project.buildUri(['builds'], queryParameters: queryParameters, page: page, perPage: perPage);

    final List<Map> jsonList = await _gitLab.request(uri);

    return jsonList.map((json) => new Build.fromJson(json)).toList();
  }
}

enum BuildScope { created, pending, running, failed, success, canceled, skipped }

class Build {
  final Map originalJson;

  Build.fromJson(this.originalJson);

  int get id => originalJson['id'];
  String get name => originalJson['name'];
  String get ref => originalJson['ref'];
  String get stage => originalJson['stage'];
  String get status => originalJson['status'];
  DateTime get startedAt => DateTime.parse(originalJson['started_at']);
  DateTime get createdAt => DateTime.parse(originalJson['created_at']);
  DateTime get finishedAt => DateTime.parse(originalJson['finished_at']);
  Commit get commit => new Commit.fromJson(originalJson['commit']);

  @override
  String toString() => 'Build id#$id ($name)';
}
