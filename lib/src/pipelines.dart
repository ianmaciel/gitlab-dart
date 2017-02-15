part of exitlive.gitlab;

/// The documentation for this API is here: https://docs.gitlab.com/ee/api/builds.html
class PipelinesApi {
  final GitLab _gitLab;
  final ProjectsApi _project;

  PipelinesApi(this._gitLab, this._project);

  Future<Pipeline> get(int id) async {
    final uri = _project._buildUri(['pipelines', '$id']);

    final Map json = await _gitLab.request(uri);

    return new Pipeline.fromJson(json);
  }

  Future<List<Pipeline>> list({int page, int perPage}) async {
    final uri = _project._buildUri(['builds'], page: page, perPage: perPage);

    final List<Map> jsonList = await _gitLab.request(uri);

    return jsonList.map((json) => new Pipeline.fromJson(json)).toList();
  }
}

class Pipeline {
  final Map originalJson;

  Pipeline.fromJson(this.originalJson);

  int get id => originalJson['id'];
  String get status => originalJson['status'];
  String get ref => originalJson['ref'];
  String get sha => originalJson['sha'];
  String get beforeSha => originalJson['before_sha'];
  String get tag => originalJson['tag'];
  Commit get commit => new Commit.fromJson(originalJson['commit']);
  DateTime get createdAt => DateTime.parse(originalJson['created_at']);
  DateTime get updatedAt => DateTime.parse(originalJson['updated_at']);
  DateTime get startedAt => DateTime.parse(originalJson['started_at']);
  DateTime get finishedAt => DateTime.parse(originalJson['finished_at']);
  DateTime get commitedAt => DateTime.parse(originalJson['committed_at']);

  @override
  String toString() => 'Pipeline id#$id (Ref: $ref)';
}
